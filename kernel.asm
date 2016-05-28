
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 bd 33 10 80       	mov    $0x801033bd,%eax
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
8010003a:	c7 44 24 04 74 85 10 	movl   $0x80108574,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 69 4e 00 00       	call   80104eb7 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb0
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb4
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
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
801000b6:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000bd:	e8 16 4e 00 00       	call   80104ed8 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
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
801000fd:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100104:	e8 31 4e 00 00       	call   80104f3a <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 43 4a 00 00       	call   80104b67 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 db 10 80       	mov    0x8010dbb0,%eax
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
80100175:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017c:	e8 b9 4d 00 00       	call   80104f3a <release>
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
8010018f:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 7b 85 10 80 	movl   $0x8010857b,(%esp)
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
801001ef:	c7 04 24 8c 85 10 80 	movl   $0x8010858c,(%esp)
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
80100229:	c7 04 24 93 85 10 80 	movl   $0x80108593,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010023c:	e8 97 4c 00 00       	call   80104ed8 <acquire>

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
8010025f:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

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
8010029d:	e8 09 4a 00 00       	call   80104cab <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002a9:	e8 8c 4c 00 00       	call   80104f3a <release>
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
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
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
801003a6:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003bb:	e8 18 4b 00 00       	call   80104ed8 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 9a 85 10 80 	movl   $0x8010859a,(%esp)
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
801004b0:	c7 45 ec a3 85 10 80 	movl   $0x801085a3,-0x14(%ebp)
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
8010052c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100533:	e8 02 4a 00 00       	call   80104f3a <release>
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
80100545:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 aa 85 10 80 	movl   $0x801085aa,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 b9 85 10 80 	movl   $0x801085b9,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 f5 49 00 00       	call   80104f89 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 bb 85 10 80 	movl   $0x801085bb,(%esp)
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
801005be:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
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
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
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
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 44 4b 00 00       	call   801051fb <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 46 4a 00 00       	call   8010512c <memset>
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
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
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
80100756:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
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
80100776:	e8 39 64 00 00       	call   80106bb4 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 2d 64 00 00       	call   80106bb4 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 21 64 00 00       	call   80106bb4 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 14 64 00 00       	call   80106bb4 <uartputc>
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
801007b3:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801007ba:	e8 19 47 00 00       	call   80104ed8 <acquire>
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
801007ea:	e8 62 45 00 00       	call   80104d51 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 7c de 10 80       	mov    %eax,0x8010de7c
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
80100810:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100816:	a1 78 de 10 80       	mov    0x8010de78,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
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
8010083a:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100840:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 7c de 10 80       	mov    0x8010de7c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 7c de 10 80       	mov    %eax,0x8010de7c
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
80100876:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
8010087c:	a1 74 de 10 80       	mov    0x8010de74,%eax
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
8010089d:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 7c de 10 80    	mov    %edx,0x8010de7c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 f4 dd 10 80    	mov    %al,-0x7fef220c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008d5:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008e7:	a3 78 de 10 80       	mov    %eax,0x8010de78
          wakeup(&input.r);
801008ec:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
801008f3:	e8 b3 43 00 00       	call   80104cab <wakeup>
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
8010090d:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100914:	e8 21 46 00 00       	call   80104f3a <release>
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
80100932:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100939:	e8 9a 45 00 00       	call   80104ed8 <acquire>
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
80100952:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100959:	e8 dc 45 00 00       	call   80104f3a <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 ea 0e 00 00       	call   80101853 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 c0 dd 10 	movl   $0x8010ddc0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
80100982:	e8 e0 41 00 00       	call   80104b67 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
8010098d:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 74 de 10 80       	mov    0x8010de74,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 74 de 10 80    	mov    %edx,0x8010de74
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
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
801009c2:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 74 de 10 80       	mov    %eax,0x8010de74
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
801009f7:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801009fe:	e8 37 45 00 00       	call   80104f3a <release>
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
80100a2b:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a32:	e8 a1 44 00 00       	call   80104ed8 <acquire>
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
80100a65:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a6c:	e8 c9 44 00 00       	call   80104f3a <release>
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
80100a87:	c7 44 24 04 bf 85 10 	movl   $0x801085bf,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a96:	e8 1c 44 00 00       	call   80104eb7 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 c7 85 10 	movl   $0x801085c7,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100aaa:	e8 08 44 00 00       	call   80104eb7 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 2c e8 10 80 1a 	movl   $0x80100a1a,0x8010e82c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 28 e8 10 80 1b 	movl   $0x8010091b,0x8010e828
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 81 2f 00 00       	call   80103a5a <picenable>
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
80100b69:	e8 97 71 00 00       	call   80107d05 <setupkvm>
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
80100c0a:	e8 c4 74 00 00       	call   801080d3 <allocuvm>
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
80100c48:	e8 9b 73 00 00       	call   80107fe8 <loaduvm>
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
80100cb1:	e8 1d 74 00 00       	call   801080d3 <allocuvm>
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
80100ce2:	e8 1c 76 00 00       	call   80108303 <clearpteu>

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
80100d18:	e8 79 46 00 00       	call   80105396 <strlen>
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
80100d41:	e8 50 46 00 00       	call   80105396 <strlen>
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
80100d71:	e8 52 77 00 00       	call   801084c8 <copyout>
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
80100e18:	e8 ab 76 00 00       	call   801084c8 <copyout>
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
80100e70:	e8 d7 44 00 00       	call   8010534c <safestrcpy>

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
80100ec2:	e8 2f 6f 00 00       	call   80107df6 <switchuvm>
  freevm(oldpgdir);
80100ec7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eca:	89 04 24             	mov    %eax,(%esp)
80100ecd:	e8 97 73 00 00       	call   80108269 <freevm>
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
80100ee5:	e8 7f 73 00 00       	call   80108269 <freevm>
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
80100f08:	c7 44 24 04 cd 85 10 	movl   $0x801085cd,0x4(%esp)
80100f0f:	80 
80100f10:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f17:	e8 9b 3f 00 00       	call   80104eb7 <initlock>
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
80100f24:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f2b:	e8 a8 3f 00 00       	call   80104ed8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f30:	c7 45 f4 b4 de 10 80 	movl   $0x8010deb4,-0xc(%ebp)
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
80100f4d:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f54:	e8 e1 3f 00 00       	call   80104f3a <release>
      return f;
80100f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5c:	eb 1e                	jmp    80100f7c <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5e:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f62:	81 7d f4 14 e8 10 80 	cmpl   $0x8010e814,-0xc(%ebp)
80100f69:	72 ce                	jb     80100f39 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f6b:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f72:	e8 c3 3f 00 00       	call   80104f3a <release>
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
80100f84:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f8b:	e8 48 3f 00 00       	call   80104ed8 <acquire>
  if(f->ref < 1)
80100f90:	8b 45 08             	mov    0x8(%ebp),%eax
80100f93:	8b 40 04             	mov    0x4(%eax),%eax
80100f96:	85 c0                	test   %eax,%eax
80100f98:	7f 0c                	jg     80100fa6 <filedup+0x28>
    panic("filedup");
80100f9a:	c7 04 24 d4 85 10 80 	movl   $0x801085d4,(%esp)
80100fa1:	e8 94 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa9:	8b 40 04             	mov    0x4(%eax),%eax
80100fac:	8d 50 01             	lea    0x1(%eax),%edx
80100faf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb2:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb5:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fbc:	e8 79 3f 00 00       	call   80104f3a <release>
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
80100fcc:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fd3:	e8 00 3f 00 00       	call   80104ed8 <acquire>
  if(f->ref < 1)
80100fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdb:	8b 40 04             	mov    0x4(%eax),%eax
80100fde:	85 c0                	test   %eax,%eax
80100fe0:	7f 0c                	jg     80100fee <fileclose+0x28>
    panic("fileclose");
80100fe2:	c7 04 24 dc 85 10 80 	movl   $0x801085dc,(%esp)
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
80101007:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
8010100e:	e8 27 3f 00 00       	call   80104f3a <release>
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
80101051:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80101058:	e8 dd 3e 00 00       	call   80104f3a <release>
  
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
80101076:	e8 8f 2c 00 00       	call   80103d0a <pipeclose>
8010107b:	eb 1d                	jmp    8010109a <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010107d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101080:	83 f8 02             	cmp    $0x2,%eax
80101083:	75 15                	jne    8010109a <fileclose+0xd4>
    begin_trans();
80101085:	e8 53 21 00 00       	call   801031dd <begin_trans>
    iput(ff.ip);
8010108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010108d:	89 04 24             	mov    %eax,(%esp)
80101090:	e8 71 09 00 00       	call   80101a06 <iput>
    commit_trans();
80101095:	e8 8c 21 00 00       	call   80103226 <commit_trans>
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
80101127:	e8 5f 2d 00 00       	call   80103e8b <piperead>
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
80101199:	c7 04 24 e6 85 10 80 	movl   $0x801085e6,(%esp)
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
801011e4:	e8 b3 2b 00 00       	call   80103d9c <pipewrite>
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
8010122a:	e8 ae 1f 00 00       	call   801031dd <begin_trans>
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
80101290:	e8 91 1f 00 00       	call   80103226 <commit_trans>

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
801012a5:	c7 04 24 ef 85 10 80 	movl   $0x801085ef,(%esp)
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
801012d7:	c7 04 24 ff 85 10 80 	movl   $0x801085ff,(%esp)
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
8010131d:	e8 d9 3e 00 00       	call   801051fb <memmove>
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
80101363:	e8 c4 3d 00 00       	call   8010512c <memset>
  log_write(bp);
80101368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136b:	89 04 24             	mov    %eax,(%esp)
8010136e:	e8 0b 1f 00 00       	call   8010327e <log_write>
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
8010144d:	e8 2c 1e 00 00       	call   8010327e <log_write>
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
801014c0:	c7 04 24 09 86 10 80 	movl   $0x80108609,(%esp)
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
80101552:	c7 04 24 1f 86 10 80 	movl   $0x8010861f,(%esp)
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
8010158a:	e8 ef 1c 00 00       	call   8010327e <log_write>
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
801015a2:	c7 44 24 04 32 86 10 	movl   $0x80108632,0x4(%esp)
801015a9:	80 
801015aa:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801015b1:	e8 01 39 00 00       	call   80104eb7 <initlock>
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
80101633:	e8 f4 3a 00 00       	call   8010512c <memset>
      dip->type = type;
80101638:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163b:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010163f:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101645:	89 04 24             	mov    %eax,(%esp)
80101648:	e8 31 1c 00 00       	call   8010327e <log_write>
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
80101689:	c7 04 24 39 86 10 80 	movl   $0x80108639,(%esp)
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
80101732:	e8 c4 3a 00 00       	call   801051fb <memmove>
  log_write(bp);
80101737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 3c 1b 00 00       	call   8010327e <log_write>
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
80101755:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010175c:	e8 77 37 00 00       	call   80104ed8 <acquire>

  // Is the inode already cached?
  empty = 0;
80101761:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101768:	c7 45 f4 b4 e8 10 80 	movl   $0x8010e8b4,-0xc(%ebp)
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
8010179f:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801017a6:	e8 8f 37 00 00       	call   80104f3a <release>
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
801017ca:	81 7d f4 54 f8 10 80 	cmpl   $0x8010f854,-0xc(%ebp)
801017d1:	72 9e                	jb     80101771 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017d7:	75 0c                	jne    801017e5 <iget+0x96>
    panic("iget: no inodes");
801017d9:	c7 04 24 4b 86 10 80 	movl   $0x8010864b,(%esp)
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
80101810:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101817:	e8 1e 37 00 00       	call   80104f3a <release>

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
80101827:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010182e:	e8 a5 36 00 00       	call   80104ed8 <acquire>
  ip->ref++;
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	8b 40 08             	mov    0x8(%eax),%eax
80101839:	8d 50 01             	lea    0x1(%eax),%edx
8010183c:	8b 45 08             	mov    0x8(%ebp),%eax
8010183f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101842:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101849:	e8 ec 36 00 00       	call   80104f3a <release>
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
80101869:	c7 04 24 5b 86 10 80 	movl   $0x8010865b,(%esp)
80101870:	e8 c5 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101875:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010187c:	e8 57 36 00 00       	call   80104ed8 <acquire>
  while(ip->flags & I_BUSY)
80101881:	eb 13                	jmp    80101896 <ilock+0x43>
    sleep(ip, &icache.lock);
80101883:	c7 44 24 04 80 e8 10 	movl   $0x8010e880,0x4(%esp)
8010188a:	80 
8010188b:	8b 45 08             	mov    0x8(%ebp),%eax
8010188e:	89 04 24             	mov    %eax,(%esp)
80101891:	e8 d1 32 00 00       	call   80104b67 <sleep>

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
801018b4:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801018bb:	e8 7a 36 00 00       	call   80104f3a <release>

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
80101966:	e8 90 38 00 00       	call   801051fb <memmove>
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
80101993:	c7 04 24 61 86 10 80 	movl   $0x80108661,(%esp)
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
801019c4:	c7 04 24 70 86 10 80 	movl   $0x80108670,(%esp)
801019cb:	e8 6a eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019d0:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801019d7:	e8 fc 34 00 00       	call   80104ed8 <acquire>
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
801019f3:	e8 b3 32 00 00       	call   80104cab <wakeup>
  release(&icache.lock);
801019f8:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801019ff:	e8 36 35 00 00       	call   80104f3a <release>
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
80101a0c:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a13:	e8 c0 34 00 00       	call   80104ed8 <acquire>
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
80101a51:	c7 04 24 78 86 10 80 	movl   $0x80108678,(%esp)
80101a58:	e8 dd ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 c8 01             	or     $0x1,%eax
80101a66:	89 c2                	mov    %eax,%edx
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a6e:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a75:	e8 c0 34 00 00       	call   80104f3a <release>
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
80101a99:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101aa0:	e8 33 34 00 00       	call   80104ed8 <acquire>
    ip->flags = 0;
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 f1 31 00 00       	call   80104cab <wakeup>
  }
  ip->ref--;
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	8b 40 08             	mov    0x8(%eax),%eax
80101ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ac9:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101ad0:	e8 65 34 00 00       	call   80104f3a <release>
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
80101bdb:	e8 9e 16 00 00       	call   8010327e <log_write>
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
80101bf0:	c7 04 24 82 86 10 80 	movl   $0x80108682,(%esp)
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
80101d94:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
80101d9b:	85 c0                	test   %eax,%eax
80101d9d:	75 0a                	jne    80101da9 <readi+0x49>
      return -1;
80101d9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da4:	e9 19 01 00 00       	jmp    80101ec2 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101da9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dac:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db0:	98                   	cwtl   
80101db1:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
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
80101e91:	e8 65 33 00 00       	call   801051fb <memmove>
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
80101ef8:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
80101eff:	85 c0                	test   %eax,%eax
80101f01:	75 0a                	jne    80101f0d <writei+0x49>
      return -1;
80101f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f08:	e9 44 01 00 00       	jmp    80102051 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f10:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f14:	98                   	cwtl   
80101f15:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
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
80101ff0:	e8 06 32 00 00       	call   801051fb <memmove>
    log_write(bp);
80101ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff8:	89 04 24             	mov    %eax,(%esp)
80101ffb:	e8 7e 12 00 00       	call   8010327e <log_write>
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
8010206e:	e8 2b 32 00 00       	call   8010529e <strncmp>
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
80102088:	c7 04 24 95 86 10 80 	movl   $0x80108695,(%esp)
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
801020c6:	c7 04 24 a7 86 10 80 	movl   $0x801086a7,(%esp)
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
801021ab:	c7 04 24 a7 86 10 80 	movl   $0x801086a7,(%esp)
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
801021f0:	e8 ff 30 00 00       	call   801052f4 <strncpy>
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
80102222:	c7 04 24 b4 86 10 80 	movl   $0x801086b4,(%esp)
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
801022a7:	e8 4f 2f 00 00       	call   801051fb <memmove>
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
801022c2:	e8 34 2f 00 00       	call   801051fb <memmove>
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
80102511:	c7 44 24 04 bc 86 10 	movl   $0x801086bc,0x4(%esp)
80102518:	80 
80102519:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102520:	e8 92 29 00 00       	call   80104eb7 <initlock>
  picenable(IRQ_IDE);
80102525:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010252c:	e8 29 15 00 00       	call   80103a5a <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102531:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
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
80102582:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
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
801025bd:	c7 04 24 c0 86 10 80 	movl   $0x801086c0,(%esp)
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
801026dc:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801026e3:	e8 f0 27 00 00       	call   80104ed8 <acquire>
  if((b = idequeue) == 0){
801026e8:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801026ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026f4:	75 11                	jne    80102707 <ideintr+0x31>
    release(&idelock);
801026f6:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801026fd:	e8 38 28 00 00       	call   80104f3a <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102702:	e9 90 00 00 00       	jmp    80102797 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010270a:	8b 40 14             	mov    0x14(%eax),%eax
8010270d:	a3 54 b6 10 80       	mov    %eax,0x8010b654

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
80102770:	e8 36 25 00 00       	call   80104cab <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102775:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010277a:	85 c0                	test   %eax,%eax
8010277c:	74 0d                	je     8010278b <ideintr+0xb5>
    idestart(idequeue);
8010277e:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102783:	89 04 24             	mov    %eax,(%esp)
80102786:	e8 26 fe ff ff       	call   801025b1 <idestart>

  release(&idelock);
8010278b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102792:	e8 a3 27 00 00       	call   80104f3a <release>
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
801027ab:	c7 04 24 c9 86 10 80 	movl   $0x801086c9,(%esp)
801027b2:	e8 83 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 00                	mov    (%eax),%eax
801027bc:	83 e0 06             	and    $0x6,%eax
801027bf:	83 f8 02             	cmp    $0x2,%eax
801027c2:	75 0c                	jne    801027d0 <iderw+0x37>
    panic("iderw: nothing to do");
801027c4:	c7 04 24 dd 86 10 80 	movl   $0x801086dd,(%esp)
801027cb:	e8 6a dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027d0:	8b 45 08             	mov    0x8(%ebp),%eax
801027d3:	8b 40 04             	mov    0x4(%eax),%eax
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 15                	je     801027ef <iderw+0x56>
801027da:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801027df:	85 c0                	test   %eax,%eax
801027e1:	75 0c                	jne    801027ef <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027e3:	c7 04 24 f2 86 10 80 	movl   $0x801086f2,(%esp)
801027ea:	e8 4b dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027ef:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027f6:	e8 dd 26 00 00       	call   80104ed8 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027fb:	8b 45 08             	mov    0x8(%ebp),%eax
801027fe:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102805:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
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
8010282a:	a1 54 b6 10 80       	mov    0x8010b654,%eax
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
80102843:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
8010284a:	80 
8010284b:	8b 45 08             	mov    0x8(%ebp),%eax
8010284e:	89 04 24             	mov    %eax,(%esp)
80102851:	e8 11 23 00 00       	call   80104b67 <sleep>
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
80102863:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010286a:	e8 cb 26 00 00       	call   80104f3a <release>
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
80102874:	a1 54 f8 10 80       	mov    0x8010f854,%eax
80102879:	8b 55 08             	mov    0x8(%ebp),%edx
8010287c:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010287e:	a1 54 f8 10 80       	mov    0x8010f854,%eax
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
8010288b:	a1 54 f8 10 80       	mov    0x8010f854,%eax
80102890:	8b 55 08             	mov    0x8(%ebp),%edx
80102893:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102895:	a1 54 f8 10 80       	mov    0x8010f854,%eax
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
801028a8:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801028ad:	85 c0                	test   %eax,%eax
801028af:	75 05                	jne    801028b6 <ioapicinit+0x14>
    return;
801028b1:	e9 9d 00 00 00       	jmp    80102953 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028b6:	c7 05 54 f8 10 80 00 	movl   $0xfec00000,0x8010f854
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
801028e9:	0f b6 05 20 f9 10 80 	movzbl 0x8010f920,%eax
801028f0:	0f b6 c0             	movzbl %al,%eax
801028f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028f6:	74 0c                	je     80102904 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028f8:	c7 04 24 10 87 10 80 	movl   $0x80108710,(%esp)
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
8010295b:	a1 24 f9 10 80       	mov    0x8010f924,%eax
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
801029b2:	c7 44 24 04 42 87 10 	movl   $0x80108742,0x4(%esp)
801029b9:	80 
801029ba:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
801029c1:	e8 f1 24 00 00       	call   80104eb7 <initlock>
  kmem.use_lock = 0;
801029c6:	c7 05 94 f8 10 80 00 	movl   $0x0,0x8010f894
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
801029fc:	c7 05 94 f8 10 80 01 	movl   $0x1,0x8010f894
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
80102a53:	81 7d 08 1c 29 11 80 	cmpl   $0x8011291c,0x8(%ebp)
80102a5a:	72 12                	jb     80102a6e <kfree+0x2d>
80102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5f:	89 04 24             	mov    %eax,(%esp)
80102a62:	e8 38 ff ff ff       	call   8010299f <v2p>
80102a67:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a6c:	76 0c                	jbe    80102a7a <kfree+0x39>
    panic("kfree");
80102a6e:	c7 04 24 47 87 10 80 	movl   $0x80108747,(%esp)
80102a75:	e8 c0 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a7a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a81:	00 
80102a82:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a89:	00 
80102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8d:	89 04 24             	mov    %eax,(%esp)
80102a90:	e8 97 26 00 00       	call   8010512c <memset>

  if(kmem.use_lock)
80102a95:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102a9a:	85 c0                	test   %eax,%eax
80102a9c:	74 0c                	je     80102aaa <kfree+0x69>
    acquire(&kmem.lock);
80102a9e:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102aa5:	e8 2e 24 00 00       	call   80104ed8 <acquire>
  r = (struct run*)v;
80102aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80102aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ab0:	8b 15 98 f8 10 80    	mov    0x8010f898,%edx
80102ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab9:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102abe:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102ac3:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 0c                	je     80102ad8 <kfree+0x97>
    release(&kmem.lock);
80102acc:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102ad3:	e8 62 24 00 00       	call   80104f3a <release>
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
80102ae0:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102ae5:	85 c0                	test   %eax,%eax
80102ae7:	74 0c                	je     80102af5 <kalloc+0x1b>
    acquire(&kmem.lock);
80102ae9:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102af0:	e8 e3 23 00 00       	call   80104ed8 <acquire>
  r = kmem.freelist;
80102af5:	a1 98 f8 10 80       	mov    0x8010f898,%eax
80102afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b01:	74 0a                	je     80102b0d <kalloc+0x33>
    kmem.freelist = r->next;
80102b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b06:	8b 00                	mov    (%eax),%eax
80102b08:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102b0d:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b12:	85 c0                	test   %eax,%eax
80102b14:	74 0c                	je     80102b22 <kalloc+0x48>
    release(&kmem.lock);
80102b16:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b1d:	e8 18 24 00 00       	call   80104f3a <release>
  return (char*)r;
80102b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b25:	c9                   	leave  
80102b26:	c3                   	ret    

80102b27 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b27:	55                   	push   %ebp
80102b28:	89 e5                	mov    %esp,%ebp
80102b2a:	83 ec 14             	sub    $0x14,%esp
80102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b30:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b34:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	ec                   	in     (%dx),%al
80102b3b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b3e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b42:	c9                   	leave  
80102b43:	c3                   	ret    

80102b44 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b44:	55                   	push   %ebp
80102b45:	89 e5                	mov    %esp,%ebp
80102b47:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b4a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b51:	e8 d1 ff ff ff       	call   80102b27 <inb>
80102b56:	0f b6 c0             	movzbl %al,%eax
80102b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5f:	83 e0 01             	and    $0x1,%eax
80102b62:	85 c0                	test   %eax,%eax
80102b64:	75 0a                	jne    80102b70 <kbdgetc+0x2c>
    return -1;
80102b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b6b:	e9 25 01 00 00       	jmp    80102c95 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b70:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b77:	e8 ab ff ff ff       	call   80102b27 <inb>
80102b7c:	0f b6 c0             	movzbl %al,%eax
80102b7f:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b82:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b89:	75 17                	jne    80102ba2 <kbdgetc+0x5e>
    shift |= E0ESC;
80102b8b:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102b90:	83 c8 40             	or     $0x40,%eax
80102b93:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102b98:	b8 00 00 00 00       	mov    $0x0,%eax
80102b9d:	e9 f3 00 00 00       	jmp    80102c95 <kbdgetc+0x151>
  } else if(data & 0x80){
80102ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ba5:	25 80 00 00 00       	and    $0x80,%eax
80102baa:	85 c0                	test   %eax,%eax
80102bac:	74 45                	je     80102bf3 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bae:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bb3:	83 e0 40             	and    $0x40,%eax
80102bb6:	85 c0                	test   %eax,%eax
80102bb8:	75 08                	jne    80102bc2 <kbdgetc+0x7e>
80102bba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbd:	83 e0 7f             	and    $0x7f,%eax
80102bc0:	eb 03                	jmp    80102bc5 <kbdgetc+0x81>
80102bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bcb:	05 20 90 10 80       	add    $0x80109020,%eax
80102bd0:	0f b6 00             	movzbl (%eax),%eax
80102bd3:	83 c8 40             	or     $0x40,%eax
80102bd6:	0f b6 c0             	movzbl %al,%eax
80102bd9:	f7 d0                	not    %eax
80102bdb:	89 c2                	mov    %eax,%edx
80102bdd:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102be2:	21 d0                	and    %edx,%eax
80102be4:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102be9:	b8 00 00 00 00       	mov    $0x0,%eax
80102bee:	e9 a2 00 00 00       	jmp    80102c95 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102bf3:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bf8:	83 e0 40             	and    $0x40,%eax
80102bfb:	85 c0                	test   %eax,%eax
80102bfd:	74 14                	je     80102c13 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bff:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c06:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c0b:	83 e0 bf             	and    $0xffffffbf,%eax
80102c0e:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102c13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c16:	05 20 90 10 80       	add    $0x80109020,%eax
80102c1b:	0f b6 00             	movzbl (%eax),%eax
80102c1e:	0f b6 d0             	movzbl %al,%edx
80102c21:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c26:	09 d0                	or     %edx,%eax
80102c28:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c30:	05 20 91 10 80       	add    $0x80109120,%eax
80102c35:	0f b6 00             	movzbl (%eax),%eax
80102c38:	0f b6 d0             	movzbl %al,%edx
80102c3b:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c40:	31 d0                	xor    %edx,%eax
80102c42:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c47:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c4c:	83 e0 03             	and    $0x3,%eax
80102c4f:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c59:	01 d0                	add    %edx,%eax
80102c5b:	0f b6 00             	movzbl (%eax),%eax
80102c5e:	0f b6 c0             	movzbl %al,%eax
80102c61:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c64:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c69:	83 e0 08             	and    $0x8,%eax
80102c6c:	85 c0                	test   %eax,%eax
80102c6e:	74 22                	je     80102c92 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c70:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c74:	76 0c                	jbe    80102c82 <kbdgetc+0x13e>
80102c76:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c7a:	77 06                	ja     80102c82 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c7c:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c80:	eb 10                	jmp    80102c92 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c82:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c86:	76 0a                	jbe    80102c92 <kbdgetc+0x14e>
80102c88:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c8c:	77 04                	ja     80102c92 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102c8e:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c95:	c9                   	leave  
80102c96:	c3                   	ret    

80102c97 <kbdintr>:

void
kbdintr(void)
{
80102c97:	55                   	push   %ebp
80102c98:	89 e5                	mov    %esp,%ebp
80102c9a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102c9d:	c7 04 24 44 2b 10 80 	movl   $0x80102b44,(%esp)
80102ca4:	e8 04 db ff ff       	call   801007ad <consoleintr>
}
80102ca9:	c9                   	leave  
80102caa:	c3                   	ret    

80102cab <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cab:	55                   	push   %ebp
80102cac:	89 e5                	mov    %esp,%ebp
80102cae:	83 ec 08             	sub    $0x8,%esp
80102cb1:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cb7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cbb:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cbe:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cc2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cc6:	ee                   	out    %al,(%dx)
}
80102cc7:	c9                   	leave  
80102cc8:	c3                   	ret    

80102cc9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cc9:	55                   	push   %ebp
80102cca:	89 e5                	mov    %esp,%ebp
80102ccc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ccf:	9c                   	pushf  
80102cd0:	58                   	pop    %eax
80102cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cdc:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce4:	c1 e2 02             	shl    $0x2,%edx
80102ce7:	01 c2                	add    %eax,%edx
80102ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cec:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102cee:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102cf3:	83 c0 20             	add    $0x20,%eax
80102cf6:	8b 00                	mov    (%eax),%eax
}
80102cf8:	5d                   	pop    %ebp
80102cf9:	c3                   	ret    

80102cfa <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d00:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d05:	85 c0                	test   %eax,%eax
80102d07:	75 05                	jne    80102d0e <lapicinit+0x14>
    return;
80102d09:	e9 43 01 00 00       	jmp    80102e51 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d0e:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d15:	00 
80102d16:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d1d:	e8 b7 ff ff ff       	call   80102cd9 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d22:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d29:	00 
80102d2a:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d31:	e8 a3 ff ff ff       	call   80102cd9 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d36:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d3d:	00 
80102d3e:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d45:	e8 8f ff ff ff       	call   80102cd9 <lapicw>
  lapicw(TICR, 10000000); 
80102d4a:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d51:	00 
80102d52:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d59:	e8 7b ff ff ff       	call   80102cd9 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d5e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d65:	00 
80102d66:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d6d:	e8 67 ff ff ff       	call   80102cd9 <lapicw>
  lapicw(LINT1, MASKED);
80102d72:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d79:	00 
80102d7a:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d81:	e8 53 ff ff ff       	call   80102cd9 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d86:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d8b:	83 c0 30             	add    $0x30,%eax
80102d8e:	8b 00                	mov    (%eax),%eax
80102d90:	c1 e8 10             	shr    $0x10,%eax
80102d93:	0f b6 c0             	movzbl %al,%eax
80102d96:	83 f8 03             	cmp    $0x3,%eax
80102d99:	76 14                	jbe    80102daf <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102d9b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102da2:	00 
80102da3:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102daa:	e8 2a ff ff ff       	call   80102cd9 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102daf:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102db6:	00 
80102db7:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102dbe:	e8 16 ff ff ff       	call   80102cd9 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dc3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dca:	00 
80102dcb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dd2:	e8 02 ff ff ff       	call   80102cd9 <lapicw>
  lapicw(ESR, 0);
80102dd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dde:	00 
80102ddf:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102de6:	e8 ee fe ff ff       	call   80102cd9 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102deb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102df2:	00 
80102df3:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102dfa:	e8 da fe ff ff       	call   80102cd9 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102dff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e06:	00 
80102e07:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e0e:	e8 c6 fe ff ff       	call   80102cd9 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e13:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e1a:	00 
80102e1b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e22:	e8 b2 fe ff ff       	call   80102cd9 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e27:	90                   	nop
80102e28:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e2d:	05 00 03 00 00       	add    $0x300,%eax
80102e32:	8b 00                	mov    (%eax),%eax
80102e34:	25 00 10 00 00       	and    $0x1000,%eax
80102e39:	85 c0                	test   %eax,%eax
80102e3b:	75 eb                	jne    80102e28 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e44:	00 
80102e45:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e4c:	e8 88 fe ff ff       	call   80102cd9 <lapicw>
}
80102e51:	c9                   	leave  
80102e52:	c3                   	ret    

80102e53 <cpunum>:

int
cpunum(void)
{
80102e53:	55                   	push   %ebp
80102e54:	89 e5                	mov    %esp,%ebp
80102e56:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e59:	e8 6b fe ff ff       	call   80102cc9 <readeflags>
80102e5e:	25 00 02 00 00       	and    $0x200,%eax
80102e63:	85 c0                	test   %eax,%eax
80102e65:	74 25                	je     80102e8c <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e67:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102e6c:	8d 50 01             	lea    0x1(%eax),%edx
80102e6f:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102e75:	85 c0                	test   %eax,%eax
80102e77:	75 13                	jne    80102e8c <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e79:	8b 45 04             	mov    0x4(%ebp),%eax
80102e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e80:	c7 04 24 50 87 10 80 	movl   $0x80108750,(%esp)
80102e87:	e8 14 d5 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e8c:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e91:	85 c0                	test   %eax,%eax
80102e93:	74 0f                	je     80102ea4 <cpunum+0x51>
    return lapic[ID]>>24;
80102e95:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e9a:	83 c0 20             	add    $0x20,%eax
80102e9d:	8b 00                	mov    (%eax),%eax
80102e9f:	c1 e8 18             	shr    $0x18,%eax
80102ea2:	eb 05                	jmp    80102ea9 <cpunum+0x56>
  return 0;
80102ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ea9:	c9                   	leave  
80102eaa:	c3                   	ret    

80102eab <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102eab:	55                   	push   %ebp
80102eac:	89 e5                	mov    %esp,%ebp
80102eae:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eb1:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102eb6:	85 c0                	test   %eax,%eax
80102eb8:	74 14                	je     80102ece <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ec1:	00 
80102ec2:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ec9:	e8 0b fe ff ff       	call   80102cd9 <lapicw>
}
80102ece:	c9                   	leave  
80102ecf:	c3                   	ret    

80102ed0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
}
80102ed3:	5d                   	pop    %ebp
80102ed4:	c3                   	ret    

80102ed5 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ed5:	55                   	push   %ebp
80102ed6:	89 e5                	mov    %esp,%ebp
80102ed8:	83 ec 1c             	sub    $0x1c,%esp
80102edb:	8b 45 08             	mov    0x8(%ebp),%eax
80102ede:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102ee1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ee8:	00 
80102ee9:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102ef0:	e8 b6 fd ff ff       	call   80102cab <outb>
  outb(IO_RTC+1, 0x0A);
80102ef5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102efc:	00 
80102efd:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f04:	e8 a2 fd ff ff       	call   80102cab <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f09:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f13:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f1b:	8d 50 02             	lea    0x2(%eax),%edx
80102f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f21:	c1 e8 04             	shr    $0x4,%eax
80102f24:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f27:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f2b:	c1 e0 18             	shl    $0x18,%eax
80102f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f32:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f39:	e8 9b fd ff ff       	call   80102cd9 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f3e:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f45:	00 
80102f46:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f4d:	e8 87 fd ff ff       	call   80102cd9 <lapicw>
  microdelay(200);
80102f52:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f59:	e8 72 ff ff ff       	call   80102ed0 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f5e:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f65:	00 
80102f66:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f6d:	e8 67 fd ff ff       	call   80102cd9 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f72:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f79:	e8 52 ff ff ff       	call   80102ed0 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f85:	eb 40                	jmp    80102fc7 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102f87:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f8b:	c1 e0 18             	shl    $0x18,%eax
80102f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f92:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f99:	e8 3b fd ff ff       	call   80102cd9 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fa1:	c1 e8 0c             	shr    $0xc,%eax
80102fa4:	80 cc 06             	or     $0x6,%ah
80102fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fab:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fb2:	e8 22 fd ff ff       	call   80102cd9 <lapicw>
    microdelay(200);
80102fb7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fbe:	e8 0d ff ff ff       	call   80102ed0 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fc3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fc7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fcb:	7e ba                	jle    80102f87 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fcd:	c9                   	leave  
80102fce:	c3                   	ret    

80102fcf <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fcf:	55                   	push   %ebp
80102fd0:	89 e5                	mov    %esp,%ebp
80102fd2:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fd5:	c7 44 24 04 7c 87 10 	movl   $0x8010877c,0x4(%esp)
80102fdc:	80 
80102fdd:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80102fe4:	e8 ce 1e 00 00       	call   80104eb7 <initlock>
  readsb(ROOTDEV, &sb);
80102fe9:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102ff7:	e8 ed e2 ff ff       	call   801012e9 <readsb>
  log.start = sb.size - sb.nlog;
80102ffc:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103002:	29 c2                	sub    %eax,%edx
80103004:	89 d0                	mov    %edx,%eax
80103006:	a3 d4 f8 10 80       	mov    %eax,0x8010f8d4
  log.size = sb.nlog;
8010300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010300e:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  log.dev = ROOTDEV;
80103013:	c7 05 e0 f8 10 80 01 	movl   $0x1,0x8010f8e0
8010301a:	00 00 00 
  recover_from_log();
8010301d:	e8 9a 01 00 00       	call   801031bc <recover_from_log>
}
80103022:	c9                   	leave  
80103023:	c3                   	ret    

80103024 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010302a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103031:	e9 8c 00 00 00       	jmp    801030c2 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103036:	8b 15 d4 f8 10 80    	mov    0x8010f8d4,%edx
8010303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303f:	01 d0                	add    %edx,%eax
80103041:	83 c0 01             	add    $0x1,%eax
80103044:	89 c2                	mov    %eax,%edx
80103046:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
8010304b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010304f:	89 04 24             	mov    %eax,(%esp)
80103052:	e8 4f d1 ff ff       	call   801001a6 <bread>
80103057:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010305d:	83 c0 10             	add    $0x10,%eax
80103060:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
80103067:	89 c2                	mov    %eax,%edx
80103069:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
8010306e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103072:	89 04 24             	mov    %eax,(%esp)
80103075:	e8 2c d1 ff ff       	call   801001a6 <bread>
8010307a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103080:	8d 50 18             	lea    0x18(%eax),%edx
80103083:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103086:	83 c0 18             	add    $0x18,%eax
80103089:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103090:	00 
80103091:	89 54 24 04          	mov    %edx,0x4(%esp)
80103095:	89 04 24             	mov    %eax,(%esp)
80103098:	e8 5e 21 00 00       	call   801051fb <memmove>
    bwrite(dbuf);  // write dst to disk
8010309d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030a0:	89 04 24             	mov    %eax,(%esp)
801030a3:	e8 35 d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030ab:	89 04 24             	mov    %eax,(%esp)
801030ae:	e8 64 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030b6:	89 04 24             	mov    %eax,(%esp)
801030b9:	e8 59 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030c2:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801030c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030ca:	0f 8f 66 ff ff ff    	jg     80103036 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030d0:	c9                   	leave  
801030d1:	c3                   	ret    

801030d2 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030d2:	55                   	push   %ebp
801030d3:	89 e5                	mov    %esp,%ebp
801030d5:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030d8:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
801030dd:	89 c2                	mov    %eax,%edx
801030df:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
801030e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801030e8:	89 04 24             	mov    %eax,(%esp)
801030eb:	e8 b6 d0 ff ff       	call   801001a6 <bread>
801030f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030f6:	83 c0 18             	add    $0x18,%eax
801030f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801030fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030ff:	8b 00                	mov    (%eax),%eax
80103101:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  for (i = 0; i < log.lh.n; i++) {
80103106:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010310d:	eb 1b                	jmp    8010312a <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010310f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103112:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103115:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103119:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010311c:	83 c2 10             	add    $0x10,%edx
8010311f:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103126:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010312a:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010312f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103132:	7f db                	jg     8010310f <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103137:	89 04 24             	mov    %eax,(%esp)
8010313a:	e8 d8 d0 ff ff       	call   80100217 <brelse>
}
8010313f:	c9                   	leave  
80103140:	c3                   	ret    

80103141 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103141:	55                   	push   %ebp
80103142:	89 e5                	mov    %esp,%ebp
80103144:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103147:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
8010314c:	89 c2                	mov    %eax,%edx
8010314e:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103153:	89 54 24 04          	mov    %edx,0x4(%esp)
80103157:	89 04 24             	mov    %eax,(%esp)
8010315a:	e8 47 d0 ff ff       	call   801001a6 <bread>
8010315f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103162:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103165:	83 c0 18             	add    $0x18,%eax
80103168:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010316b:	8b 15 e4 f8 10 80    	mov    0x8010f8e4,%edx
80103171:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103174:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010317d:	eb 1b                	jmp    8010319a <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
8010317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103182:	83 c0 10             	add    $0x10,%eax
80103185:	8b 0c 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%ecx
8010318c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010318f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103192:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103196:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010319a:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010319f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031a2:	7f db                	jg     8010317f <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a7:	89 04 24             	mov    %eax,(%esp)
801031aa:	e8 2e d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031b2:	89 04 24             	mov    %eax,(%esp)
801031b5:	e8 5d d0 ff ff       	call   80100217 <brelse>
}
801031ba:	c9                   	leave  
801031bb:	c3                   	ret    

801031bc <recover_from_log>:

static void
recover_from_log(void)
{
801031bc:	55                   	push   %ebp
801031bd:	89 e5                	mov    %esp,%ebp
801031bf:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031c2:	e8 0b ff ff ff       	call   801030d2 <read_head>
  install_trans(); // if committed, copy from log to disk
801031c7:	e8 58 fe ff ff       	call   80103024 <install_trans>
  log.lh.n = 0;
801031cc:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
801031d3:	00 00 00 
  write_head(); // clear the log
801031d6:	e8 66 ff ff ff       	call   80103141 <write_head>
}
801031db:	c9                   	leave  
801031dc:	c3                   	ret    

801031dd <begin_trans>:

void
begin_trans(void)
{
801031dd:	55                   	push   %ebp
801031de:	89 e5                	mov    %esp,%ebp
801031e0:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031e3:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801031ea:	e8 e9 1c 00 00       	call   80104ed8 <acquire>
  while (log.busy) {
801031ef:	eb 14                	jmp    80103205 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031f1:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
801031f8:	80 
801031f9:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103200:	e8 62 19 00 00       	call   80104b67 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103205:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
8010320a:	85 c0                	test   %eax,%eax
8010320c:	75 e3                	jne    801031f1 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010320e:	c7 05 dc f8 10 80 01 	movl   $0x1,0x8010f8dc
80103215:	00 00 00 
  release(&log.lock);
80103218:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010321f:	e8 16 1d 00 00       	call   80104f3a <release>
}
80103224:	c9                   	leave  
80103225:	c3                   	ret    

80103226 <commit_trans>:

void
commit_trans(void)
{
80103226:	55                   	push   %ebp
80103227:	89 e5                	mov    %esp,%ebp
80103229:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010322c:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103231:	85 c0                	test   %eax,%eax
80103233:	7e 19                	jle    8010324e <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103235:	e8 07 ff ff ff       	call   80103141 <write_head>
    install_trans(); // Now install writes to home locations
8010323a:	e8 e5 fd ff ff       	call   80103024 <install_trans>
    log.lh.n = 0; 
8010323f:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
80103246:	00 00 00 
    write_head();    // Erase the transaction from the log
80103249:	e8 f3 fe ff ff       	call   80103141 <write_head>
  }
  
  acquire(&log.lock);
8010324e:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103255:	e8 7e 1c 00 00       	call   80104ed8 <acquire>
  log.busy = 0;
8010325a:	c7 05 dc f8 10 80 00 	movl   $0x0,0x8010f8dc
80103261:	00 00 00 
  wakeup(&log);
80103264:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010326b:	e8 3b 1a 00 00       	call   80104cab <wakeup>
  release(&log.lock);
80103270:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103277:	e8 be 1c 00 00       	call   80104f3a <release>
}
8010327c:	c9                   	leave  
8010327d:	c3                   	ret    

8010327e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010327e:	55                   	push   %ebp
8010327f:	89 e5                	mov    %esp,%ebp
80103281:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103284:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103289:	83 f8 09             	cmp    $0x9,%eax
8010328c:	7f 12                	jg     801032a0 <log_write+0x22>
8010328e:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103293:	8b 15 d8 f8 10 80    	mov    0x8010f8d8,%edx
80103299:	83 ea 01             	sub    $0x1,%edx
8010329c:	39 d0                	cmp    %edx,%eax
8010329e:	7c 0c                	jl     801032ac <log_write+0x2e>
    panic("too big a transaction");
801032a0:	c7 04 24 80 87 10 80 	movl   $0x80108780,(%esp)
801032a7:	e8 8e d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032ac:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
801032b1:	85 c0                	test   %eax,%eax
801032b3:	75 0c                	jne    801032c1 <log_write+0x43>
    panic("write outside of trans");
801032b5:	c7 04 24 96 87 10 80 	movl   $0x80108796,(%esp)
801032bc:	e8 79 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032c8:	eb 1f                	jmp    801032e9 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032cd:	83 c0 10             	add    $0x10,%eax
801032d0:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
801032d7:	89 c2                	mov    %eax,%edx
801032d9:	8b 45 08             	mov    0x8(%ebp),%eax
801032dc:	8b 40 08             	mov    0x8(%eax),%eax
801032df:	39 c2                	cmp    %eax,%edx
801032e1:	75 02                	jne    801032e5 <log_write+0x67>
      break;
801032e3:	eb 0e                	jmp    801032f3 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032e9:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801032ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032f1:	7f d7                	jg     801032ca <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
801032f3:	8b 45 08             	mov    0x8(%ebp),%eax
801032f6:	8b 40 08             	mov    0x8(%eax),%eax
801032f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032fc:	83 c2 10             	add    $0x10,%edx
801032ff:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103306:	8b 15 d4 f8 10 80    	mov    0x8010f8d4,%edx
8010330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330f:	01 d0                	add    %edx,%eax
80103311:	83 c0 01             	add    $0x1,%eax
80103314:	89 c2                	mov    %eax,%edx
80103316:	8b 45 08             	mov    0x8(%ebp),%eax
80103319:	8b 40 04             	mov    0x4(%eax),%eax
8010331c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103320:	89 04 24             	mov    %eax,(%esp)
80103323:	e8 7e ce ff ff       	call   801001a6 <bread>
80103328:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010332b:	8b 45 08             	mov    0x8(%ebp),%eax
8010332e:	8d 50 18             	lea    0x18(%eax),%edx
80103331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103334:	83 c0 18             	add    $0x18,%eax
80103337:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010333e:	00 
8010333f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103343:	89 04 24             	mov    %eax,(%esp)
80103346:	e8 b0 1e 00 00       	call   801051fb <memmove>
  bwrite(lbuf);
8010334b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334e:	89 04 24             	mov    %eax,(%esp)
80103351:	e8 87 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103356:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103359:	89 04 24             	mov    %eax,(%esp)
8010335c:	e8 b6 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103361:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103366:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103369:	75 0d                	jne    80103378 <log_write+0xfa>
    log.lh.n++;
8010336b:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103370:	83 c0 01             	add    $0x1,%eax
80103373:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  b->flags |= B_DIRTY; // XXX prevent eviction
80103378:	8b 45 08             	mov    0x8(%ebp),%eax
8010337b:	8b 00                	mov    (%eax),%eax
8010337d:	83 c8 04             	or     $0x4,%eax
80103380:	89 c2                	mov    %eax,%edx
80103382:	8b 45 08             	mov    0x8(%ebp),%eax
80103385:	89 10                	mov    %edx,(%eax)
}
80103387:	c9                   	leave  
80103388:	c3                   	ret    

80103389 <v2p>:
80103389:	55                   	push   %ebp
8010338a:	89 e5                	mov    %esp,%ebp
8010338c:	8b 45 08             	mov    0x8(%ebp),%eax
8010338f:	05 00 00 00 80       	add    $0x80000000,%eax
80103394:	5d                   	pop    %ebp
80103395:	c3                   	ret    

80103396 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103396:	55                   	push   %ebp
80103397:	89 e5                	mov    %esp,%ebp
80103399:	8b 45 08             	mov    0x8(%ebp),%eax
8010339c:	05 00 00 00 80       	add    $0x80000000,%eax
801033a1:	5d                   	pop    %ebp
801033a2:	c3                   	ret    

801033a3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033a3:	55                   	push   %ebp
801033a4:	89 e5                	mov    %esp,%ebp
801033a6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033a9:	8b 55 08             	mov    0x8(%ebp),%edx
801033ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801033af:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033b2:	f0 87 02             	lock xchg %eax,(%edx)
801033b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033bb:	c9                   	leave  
801033bc:	c3                   	ret    

801033bd <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033bd:	55                   	push   %ebp
801033be:	89 e5                	mov    %esp,%ebp
801033c0:	83 e4 f0             	and    $0xfffffff0,%esp
801033c3:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033c6:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033cd:	80 
801033ce:	c7 04 24 1c 29 11 80 	movl   $0x8011291c,(%esp)
801033d5:	e8 d2 f5 ff ff       	call   801029ac <kinit1>
  kvmalloc();      // kernel page table
801033da:	e8 e3 49 00 00       	call   80107dc2 <kvmalloc>
  mpinit();        // collect info about this machine
801033df:	e8 46 04 00 00       	call   8010382a <mpinit>
  lapicinit();
801033e4:	e8 11 f9 ff ff       	call   80102cfa <lapicinit>
  seginit();       // set up segments
801033e9:	e8 67 43 00 00       	call   80107755 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033ee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033f4:	0f b6 00             	movzbl (%eax),%eax
801033f7:	0f b6 c0             	movzbl %al,%eax
801033fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801033fe:	c7 04 24 ad 87 10 80 	movl   $0x801087ad,(%esp)
80103405:	e8 96 cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010340a:	e8 79 06 00 00       	call   80103a88 <picinit>
  ioapicinit();    // another interrupt controller
8010340f:	e8 8e f4 ff ff       	call   801028a2 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103414:	e8 68 d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
80103419:	e8 86 36 00 00       	call   80106aa4 <uartinit>
  pinit();         // process table
8010341e:	e8 f1 0b 00 00       	call   80104014 <pinit>
  tvinit();        // trap vectors
80103423:	e8 2e 32 00 00       	call   80106656 <tvinit>
  binit();         // buffer cache
80103428:	e8 07 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010342d:	e8 d0 da ff ff       	call   80100f02 <fileinit>
  iinit();         // inode cache
80103432:	e8 65 e1 ff ff       	call   8010159c <iinit>
  ideinit();       // disk
80103437:	e8 cf f0 ff ff       	call   8010250b <ideinit>
  if(!ismp)
8010343c:	a1 24 f9 10 80       	mov    0x8010f924,%eax
80103441:	85 c0                	test   %eax,%eax
80103443:	75 05                	jne    8010344a <main+0x8d>
    timerinit();   // uniprocessor timer
80103445:	e8 57 31 00 00       	call   801065a1 <timerinit>
  startothers();   // start other processors
8010344a:	e8 7f 00 00 00       	call   801034ce <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010344f:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103456:	8e 
80103457:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010345e:	e8 81 f5 ff ff       	call   801029e4 <kinit2>
  userinit();      // first user process
80103463:	e8 ca 0c 00 00       	call   80104132 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103468:	e8 1a 00 00 00       	call   80103487 <mpmain>

8010346d <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010346d:	55                   	push   %ebp
8010346e:	89 e5                	mov    %esp,%ebp
80103470:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103473:	e8 61 49 00 00       	call   80107dd9 <switchkvm>
  seginit();
80103478:	e8 d8 42 00 00       	call   80107755 <seginit>
  lapicinit();
8010347d:	e8 78 f8 ff ff       	call   80102cfa <lapicinit>
  mpmain();
80103482:	e8 00 00 00 00       	call   80103487 <mpmain>

80103487 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103487:	55                   	push   %ebp
80103488:	89 e5                	mov    %esp,%ebp
8010348a:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010348d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103493:	0f b6 00             	movzbl (%eax),%eax
80103496:	0f b6 c0             	movzbl %al,%eax
80103499:	89 44 24 04          	mov    %eax,0x4(%esp)
8010349d:	c7 04 24 c4 87 10 80 	movl   $0x801087c4,(%esp)
801034a4:	e8 f7 ce ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801034a9:	e8 1c 33 00 00       	call   801067ca <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034b4:	05 a8 00 00 00       	add    $0xa8,%eax
801034b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034c0:	00 
801034c1:	89 04 24             	mov    %eax,(%esp)
801034c4:	e8 da fe ff ff       	call   801033a3 <xchg>
  scheduler();     // start running processes
801034c9:	e8 c5 14 00 00       	call   80104993 <scheduler>

801034ce <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034ce:	55                   	push   %ebp
801034cf:	89 e5                	mov    %esp,%ebp
801034d1:	53                   	push   %ebx
801034d2:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034d5:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034dc:	e8 b5 fe ff ff       	call   80103396 <p2v>
801034e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034e4:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801034ed:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
801034f4:	80 
801034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f8:	89 04 24             	mov    %eax,(%esp)
801034fb:	e8 fb 1c 00 00       	call   801051fb <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103500:	c7 45 f4 40 f9 10 80 	movl   $0x8010f940,-0xc(%ebp)
80103507:	e9 85 00 00 00       	jmp    80103591 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
8010350c:	e8 42 f9 ff ff       	call   80102e53 <cpunum>
80103511:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103517:	05 40 f9 10 80       	add    $0x8010f940,%eax
8010351c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010351f:	75 02                	jne    80103523 <startothers+0x55>
      continue;
80103521:	eb 67                	jmp    8010358a <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103523:	e8 b2 f5 ff ff       	call   80102ada <kalloc>
80103528:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010352e:	83 e8 04             	sub    $0x4,%eax
80103531:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103534:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010353a:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010353f:	83 e8 08             	sub    $0x8,%eax
80103542:	c7 00 6d 34 10 80    	movl   $0x8010346d,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103548:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010354b:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010354e:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
80103555:	e8 2f fe ff ff       	call   80103389 <v2p>
8010355a:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010355f:	89 04 24             	mov    %eax,(%esp)
80103562:	e8 22 fe ff ff       	call   80103389 <v2p>
80103567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010356a:	0f b6 12             	movzbl (%edx),%edx
8010356d:	0f b6 d2             	movzbl %dl,%edx
80103570:	89 44 24 04          	mov    %eax,0x4(%esp)
80103574:	89 14 24             	mov    %edx,(%esp)
80103577:	e8 59 f9 ff ff       	call   80102ed5 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010357c:	90                   	nop
8010357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103580:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103586:	85 c0                	test   %eax,%eax
80103588:	74 f3                	je     8010357d <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010358a:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103591:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103596:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010359c:	05 40 f9 10 80       	add    $0x8010f940,%eax
801035a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035a4:	0f 87 62 ff ff ff    	ja     8010350c <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035aa:	83 c4 24             	add    $0x24,%esp
801035ad:	5b                   	pop    %ebx
801035ae:	5d                   	pop    %ebp
801035af:	c3                   	ret    

801035b0 <p2v>:
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	8b 45 08             	mov    0x8(%ebp),%eax
801035b6:	05 00 00 00 80       	add    $0x80000000,%eax
801035bb:	5d                   	pop    %ebp
801035bc:	c3                   	ret    

801035bd <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035bd:	55                   	push   %ebp
801035be:	89 e5                	mov    %esp,%ebp
801035c0:	83 ec 14             	sub    $0x14,%esp
801035c3:	8b 45 08             	mov    0x8(%ebp),%eax
801035c6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035ca:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035ce:	89 c2                	mov    %eax,%edx
801035d0:	ec                   	in     (%dx),%al
801035d1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035d4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035d8:	c9                   	leave  
801035d9:	c3                   	ret    

801035da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801035da:	55                   	push   %ebp
801035db:	89 e5                	mov    %esp,%ebp
801035dd:	83 ec 08             	sub    $0x8,%esp
801035e0:	8b 55 08             	mov    0x8(%ebp),%edx
801035e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801035e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801035ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801035f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801035f5:	ee                   	out    %al,(%dx)
}
801035f6:	c9                   	leave  
801035f7:	c3                   	ret    

801035f8 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801035f8:	55                   	push   %ebp
801035f9:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801035fb:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103600:	89 c2                	mov    %eax,%edx
80103602:	b8 40 f9 10 80       	mov    $0x8010f940,%eax
80103607:	29 c2                	sub    %eax,%edx
80103609:	89 d0                	mov    %edx,%eax
8010360b:	c1 f8 02             	sar    $0x2,%eax
8010360e:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103614:	5d                   	pop    %ebp
80103615:	c3                   	ret    

80103616 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103616:	55                   	push   %ebp
80103617:	89 e5                	mov    %esp,%ebp
80103619:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010361c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103623:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010362a:	eb 15                	jmp    80103641 <sum+0x2b>
    sum += addr[i];
8010362c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010362f:	8b 45 08             	mov    0x8(%ebp),%eax
80103632:	01 d0                	add    %edx,%eax
80103634:	0f b6 00             	movzbl (%eax),%eax
80103637:	0f b6 c0             	movzbl %al,%eax
8010363a:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
8010363d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103641:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103644:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103647:	7c e3                	jl     8010362c <sum+0x16>
    sum += addr[i];
  return sum;
80103649:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010364c:	c9                   	leave  
8010364d:	c3                   	ret    

8010364e <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010364e:	55                   	push   %ebp
8010364f:	89 e5                	mov    %esp,%ebp
80103651:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103654:	8b 45 08             	mov    0x8(%ebp),%eax
80103657:	89 04 24             	mov    %eax,(%esp)
8010365a:	e8 51 ff ff ff       	call   801035b0 <p2v>
8010365f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103662:	8b 55 0c             	mov    0xc(%ebp),%edx
80103665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103668:	01 d0                	add    %edx,%eax
8010366a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010366d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103670:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103673:	eb 3f                	jmp    801036b4 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103675:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010367c:	00 
8010367d:	c7 44 24 04 d8 87 10 	movl   $0x801087d8,0x4(%esp)
80103684:	80 
80103685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103688:	89 04 24             	mov    %eax,(%esp)
8010368b:	e8 13 1b 00 00       	call   801051a3 <memcmp>
80103690:	85 c0                	test   %eax,%eax
80103692:	75 1c                	jne    801036b0 <mpsearch1+0x62>
80103694:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010369b:	00 
8010369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369f:	89 04 24             	mov    %eax,(%esp)
801036a2:	e8 6f ff ff ff       	call   80103616 <sum>
801036a7:	84 c0                	test   %al,%al
801036a9:	75 05                	jne    801036b0 <mpsearch1+0x62>
      return (struct mp*)p;
801036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ae:	eb 11                	jmp    801036c1 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036b0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036ba:	72 b9                	jb     80103675 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036c1:	c9                   	leave  
801036c2:	c3                   	ret    

801036c3 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036c3:	55                   	push   %ebp
801036c4:	89 e5                	mov    %esp,%ebp
801036c6:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036c9:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d3:	83 c0 0f             	add    $0xf,%eax
801036d6:	0f b6 00             	movzbl (%eax),%eax
801036d9:	0f b6 c0             	movzbl %al,%eax
801036dc:	c1 e0 08             	shl    $0x8,%eax
801036df:	89 c2                	mov    %eax,%edx
801036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e4:	83 c0 0e             	add    $0xe,%eax
801036e7:	0f b6 00             	movzbl (%eax),%eax
801036ea:	0f b6 c0             	movzbl %al,%eax
801036ed:	09 d0                	or     %edx,%eax
801036ef:	c1 e0 04             	shl    $0x4,%eax
801036f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801036f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801036f9:	74 21                	je     8010371c <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
801036fb:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103702:	00 
80103703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103706:	89 04 24             	mov    %eax,(%esp)
80103709:	e8 40 ff ff ff       	call   8010364e <mpsearch1>
8010370e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103711:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103715:	74 50                	je     80103767 <mpsearch+0xa4>
      return mp;
80103717:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010371a:	eb 5f                	jmp    8010377b <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371f:	83 c0 14             	add    $0x14,%eax
80103722:	0f b6 00             	movzbl (%eax),%eax
80103725:	0f b6 c0             	movzbl %al,%eax
80103728:	c1 e0 08             	shl    $0x8,%eax
8010372b:	89 c2                	mov    %eax,%edx
8010372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103730:	83 c0 13             	add    $0x13,%eax
80103733:	0f b6 00             	movzbl (%eax),%eax
80103736:	0f b6 c0             	movzbl %al,%eax
80103739:	09 d0                	or     %edx,%eax
8010373b:	c1 e0 0a             	shl    $0xa,%eax
8010373e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103744:	2d 00 04 00 00       	sub    $0x400,%eax
80103749:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103750:	00 
80103751:	89 04 24             	mov    %eax,(%esp)
80103754:	e8 f5 fe ff ff       	call   8010364e <mpsearch1>
80103759:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010375c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103760:	74 05                	je     80103767 <mpsearch+0xa4>
      return mp;
80103762:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103765:	eb 14                	jmp    8010377b <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103767:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010376e:	00 
8010376f:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103776:	e8 d3 fe ff ff       	call   8010364e <mpsearch1>
}
8010377b:	c9                   	leave  
8010377c:	c3                   	ret    

8010377d <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010377d:	55                   	push   %ebp
8010377e:	89 e5                	mov    %esp,%ebp
80103780:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103783:	e8 3b ff ff ff       	call   801036c3 <mpsearch>
80103788:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010378b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010378f:	74 0a                	je     8010379b <mpconfig+0x1e>
80103791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103794:	8b 40 04             	mov    0x4(%eax),%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	75 0a                	jne    801037a5 <mpconfig+0x28>
    return 0;
8010379b:	b8 00 00 00 00       	mov    $0x0,%eax
801037a0:	e9 83 00 00 00       	jmp    80103828 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037a8:	8b 40 04             	mov    0x4(%eax),%eax
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 fd fd ff ff       	call   801035b0 <p2v>
801037b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037b6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037bd:	00 
801037be:	c7 44 24 04 dd 87 10 	movl   $0x801087dd,0x4(%esp)
801037c5:	80 
801037c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037c9:	89 04 24             	mov    %eax,(%esp)
801037cc:	e8 d2 19 00 00       	call   801051a3 <memcmp>
801037d1:	85 c0                	test   %eax,%eax
801037d3:	74 07                	je     801037dc <mpconfig+0x5f>
    return 0;
801037d5:	b8 00 00 00 00       	mov    $0x0,%eax
801037da:	eb 4c                	jmp    80103828 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801037dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037df:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037e3:	3c 01                	cmp    $0x1,%al
801037e5:	74 12                	je     801037f9 <mpconfig+0x7c>
801037e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ea:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037ee:	3c 04                	cmp    $0x4,%al
801037f0:	74 07                	je     801037f9 <mpconfig+0x7c>
    return 0;
801037f2:	b8 00 00 00 00       	mov    $0x0,%eax
801037f7:	eb 2f                	jmp    80103828 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
801037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037fc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103800:	0f b7 c0             	movzwl %ax,%eax
80103803:	89 44 24 04          	mov    %eax,0x4(%esp)
80103807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010380a:	89 04 24             	mov    %eax,(%esp)
8010380d:	e8 04 fe ff ff       	call   80103616 <sum>
80103812:	84 c0                	test   %al,%al
80103814:	74 07                	je     8010381d <mpconfig+0xa0>
    return 0;
80103816:	b8 00 00 00 00       	mov    $0x0,%eax
8010381b:	eb 0b                	jmp    80103828 <mpconfig+0xab>
  *pmp = mp;
8010381d:	8b 45 08             	mov    0x8(%ebp),%eax
80103820:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103823:	89 10                	mov    %edx,(%eax)
  return conf;
80103825:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103828:	c9                   	leave  
80103829:	c3                   	ret    

8010382a <mpinit>:

void
mpinit(void)
{
8010382a:	55                   	push   %ebp
8010382b:	89 e5                	mov    %esp,%ebp
8010382d:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103830:	c7 05 64 b6 10 80 40 	movl   $0x8010f940,0x8010b664
80103837:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
8010383a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010383d:	89 04 24             	mov    %eax,(%esp)
80103840:	e8 38 ff ff ff       	call   8010377d <mpconfig>
80103845:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010384c:	75 05                	jne    80103853 <mpinit+0x29>
    return;
8010384e:	e9 9c 01 00 00       	jmp    801039ef <mpinit+0x1c5>
  ismp = 1;
80103853:	c7 05 24 f9 10 80 01 	movl   $0x1,0x8010f924
8010385a:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010385d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103860:	8b 40 24             	mov    0x24(%eax),%eax
80103863:	a3 9c f8 10 80       	mov    %eax,0x8010f89c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103868:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010386b:	83 c0 2c             	add    $0x2c,%eax
8010386e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103871:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103874:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103878:	0f b7 d0             	movzwl %ax,%edx
8010387b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387e:	01 d0                	add    %edx,%eax
80103880:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103883:	e9 f4 00 00 00       	jmp    8010397c <mpinit+0x152>
    switch(*p){
80103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388b:	0f b6 00             	movzbl (%eax),%eax
8010388e:	0f b6 c0             	movzbl %al,%eax
80103891:	83 f8 04             	cmp    $0x4,%eax
80103894:	0f 87 bf 00 00 00    	ja     80103959 <mpinit+0x12f>
8010389a:	8b 04 85 20 88 10 80 	mov    -0x7fef77e0(,%eax,4),%eax
801038a1:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ac:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038b0:	0f b6 d0             	movzbl %al,%edx
801038b3:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038b8:	39 c2                	cmp    %eax,%edx
801038ba:	74 2d                	je     801038e9 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038bf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038c3:	0f b6 d0             	movzbl %al,%edx
801038c6:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038cb:	89 54 24 08          	mov    %edx,0x8(%esp)
801038cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801038d3:	c7 04 24 e2 87 10 80 	movl   $0x801087e2,(%esp)
801038da:	e8 c1 ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801038df:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
801038e6:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801038e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ec:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801038f0:	0f b6 c0             	movzbl %al,%eax
801038f3:	83 e0 02             	and    $0x2,%eax
801038f6:	85 c0                	test   %eax,%eax
801038f8:	74 15                	je     8010390f <mpinit+0xe5>
        bcpu = &cpus[ncpu];
801038fa:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038ff:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103905:	05 40 f9 10 80       	add    $0x8010f940,%eax
8010390a:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
8010390f:	8b 15 20 ff 10 80    	mov    0x8010ff20,%edx
80103915:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010391a:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103920:	81 c2 40 f9 10 80    	add    $0x8010f940,%edx
80103926:	88 02                	mov    %al,(%edx)
      ncpu++;
80103928:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010392d:	83 c0 01             	add    $0x1,%eax
80103930:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
      p += sizeof(struct mpproc);
80103935:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103939:	eb 41                	jmp    8010397c <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010393e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103944:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103948:	a2 20 f9 10 80       	mov    %al,0x8010f920
      p += sizeof(struct mpioapic);
8010394d:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103951:	eb 29                	jmp    8010397c <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103953:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103957:	eb 23                	jmp    8010397c <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010395c:	0f b6 00             	movzbl (%eax),%eax
8010395f:	0f b6 c0             	movzbl %al,%eax
80103962:	89 44 24 04          	mov    %eax,0x4(%esp)
80103966:	c7 04 24 00 88 10 80 	movl   $0x80108800,(%esp)
8010396d:	e8 2e ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103972:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
80103979:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010397f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103982:	0f 82 00 ff ff ff    	jb     80103888 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103988:	a1 24 f9 10 80       	mov    0x8010f924,%eax
8010398d:	85 c0                	test   %eax,%eax
8010398f:	75 1d                	jne    801039ae <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103991:	c7 05 20 ff 10 80 01 	movl   $0x1,0x8010ff20
80103998:	00 00 00 
    lapic = 0;
8010399b:	c7 05 9c f8 10 80 00 	movl   $0x0,0x8010f89c
801039a2:	00 00 00 
    ioapicid = 0;
801039a5:	c6 05 20 f9 10 80 00 	movb   $0x0,0x8010f920
    return;
801039ac:	eb 41                	jmp    801039ef <mpinit+0x1c5>
  }

  if(mp->imcrp){
801039ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039b1:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039b5:	84 c0                	test   %al,%al
801039b7:	74 36                	je     801039ef <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039b9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039c0:	00 
801039c1:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039c8:	e8 0d fc ff ff       	call   801035da <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039cd:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039d4:	e8 e4 fb ff ff       	call   801035bd <inb>
801039d9:	83 c8 01             	or     $0x1,%eax
801039dc:	0f b6 c0             	movzbl %al,%eax
801039df:	89 44 24 04          	mov    %eax,0x4(%esp)
801039e3:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039ea:	e8 eb fb ff ff       	call   801035da <outb>
  }
}
801039ef:	c9                   	leave  
801039f0:	c3                   	ret    

801039f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039f1:	55                   	push   %ebp
801039f2:	89 e5                	mov    %esp,%ebp
801039f4:	83 ec 08             	sub    $0x8,%esp
801039f7:	8b 55 08             	mov    0x8(%ebp),%edx
801039fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801039fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a01:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a04:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a08:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a0c:	ee                   	out    %al,(%dx)
}
80103a0d:	c9                   	leave  
80103a0e:	c3                   	ret    

80103a0f <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a0f:	55                   	push   %ebp
80103a10:	89 e5                	mov    %esp,%ebp
80103a12:	83 ec 0c             	sub    $0xc,%esp
80103a15:	8b 45 08             	mov    0x8(%ebp),%eax
80103a18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a1c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a20:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a26:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a2a:	0f b6 c0             	movzbl %al,%eax
80103a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a31:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a38:	e8 b4 ff ff ff       	call   801039f1 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a3d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a41:	66 c1 e8 08          	shr    $0x8,%ax
80103a45:	0f b6 c0             	movzbl %al,%eax
80103a48:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a4c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a53:	e8 99 ff ff ff       	call   801039f1 <outb>
}
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    

80103a5a <picenable>:

void
picenable(int irq)
{
80103a5a:	55                   	push   %ebp
80103a5b:	89 e5                	mov    %esp,%ebp
80103a5d:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a60:	8b 45 08             	mov    0x8(%ebp),%eax
80103a63:	ba 01 00 00 00       	mov    $0x1,%edx
80103a68:	89 c1                	mov    %eax,%ecx
80103a6a:	d3 e2                	shl    %cl,%edx
80103a6c:	89 d0                	mov    %edx,%eax
80103a6e:	f7 d0                	not    %eax
80103a70:	89 c2                	mov    %eax,%edx
80103a72:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103a79:	21 d0                	and    %edx,%eax
80103a7b:	0f b7 c0             	movzwl %ax,%eax
80103a7e:	89 04 24             	mov    %eax,(%esp)
80103a81:	e8 89 ff ff ff       	call   80103a0f <picsetmask>
}
80103a86:	c9                   	leave  
80103a87:	c3                   	ret    

80103a88 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103a88:	55                   	push   %ebp
80103a89:	89 e5                	mov    %esp,%ebp
80103a8b:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103a8e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103a95:	00 
80103a96:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9d:	e8 4f ff ff ff       	call   801039f1 <outb>
  outb(IO_PIC2+1, 0xFF);
80103aa2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103aa9:	00 
80103aaa:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ab1:	e8 3b ff ff ff       	call   801039f1 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ab6:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103abd:	00 
80103abe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ac5:	e8 27 ff ff ff       	call   801039f1 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103aca:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103ad1:	00 
80103ad2:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ad9:	e8 13 ff ff ff       	call   801039f1 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ade:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103ae5:	00 
80103ae6:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103aed:	e8 ff fe ff ff       	call   801039f1 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103af2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103af9:	00 
80103afa:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b01:	e8 eb fe ff ff       	call   801039f1 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b06:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b0d:	00 
80103b0e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b15:	e8 d7 fe ff ff       	call   801039f1 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b1a:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b21:	00 
80103b22:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b29:	e8 c3 fe ff ff       	call   801039f1 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b2e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b35:	00 
80103b36:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b3d:	e8 af fe ff ff       	call   801039f1 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b42:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b49:	00 
80103b4a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b51:	e8 9b fe ff ff       	call   801039f1 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b56:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b5d:	00 
80103b5e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b65:	e8 87 fe ff ff       	call   801039f1 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b6a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b71:	00 
80103b72:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b79:	e8 73 fe ff ff       	call   801039f1 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103b7e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b85:	00 
80103b86:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b8d:	e8 5f fe ff ff       	call   801039f1 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103b92:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b99:	00 
80103b9a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ba1:	e8 4b fe ff ff       	call   801039f1 <outb>

  if(irqmask != 0xFFFF)
80103ba6:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bad:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bb1:	74 12                	je     80103bc5 <picinit+0x13d>
    picsetmask(irqmask);
80103bb3:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bba:	0f b7 c0             	movzwl %ax,%eax
80103bbd:	89 04 24             	mov    %eax,(%esp)
80103bc0:	e8 4a fe ff ff       	call   80103a0f <picsetmask>
}
80103bc5:	c9                   	leave  
80103bc6:	c3                   	ret    

80103bc7 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bc7:	55                   	push   %ebp
80103bc8:	89 e5                	mov    %esp,%ebp
80103bca:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103be0:	8b 10                	mov    (%eax),%edx
80103be2:	8b 45 08             	mov    0x8(%ebp),%eax
80103be5:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103be7:	e8 32 d3 ff ff       	call   80100f1e <filealloc>
80103bec:	8b 55 08             	mov    0x8(%ebp),%edx
80103bef:	89 02                	mov    %eax,(%edx)
80103bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf4:	8b 00                	mov    (%eax),%eax
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	0f 84 c8 00 00 00    	je     80103cc6 <pipealloc+0xff>
80103bfe:	e8 1b d3 ff ff       	call   80100f1e <filealloc>
80103c03:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c06:	89 02                	mov    %eax,(%edx)
80103c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c0b:	8b 00                	mov    (%eax),%eax
80103c0d:	85 c0                	test   %eax,%eax
80103c0f:	0f 84 b1 00 00 00    	je     80103cc6 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c15:	e8 c0 ee ff ff       	call   80102ada <kalloc>
80103c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c21:	75 05                	jne    80103c28 <pipealloc+0x61>
    goto bad;
80103c23:	e9 9e 00 00 00       	jmp    80103cc6 <pipealloc+0xff>
  p->readopen = 1;
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c32:	00 00 00 
  p->writeopen = 1;
80103c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c38:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c3f:	00 00 00 
  p->nwrite = 0;
80103c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c45:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c4c:	00 00 00 
  p->nread = 0;
80103c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c52:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c59:	00 00 00 
  initlock(&p->lock, "pipe");
80103c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5f:	c7 44 24 04 34 88 10 	movl   $0x80108834,0x4(%esp)
80103c66:	80 
80103c67:	89 04 24             	mov    %eax,(%esp)
80103c6a:	e8 48 12 00 00       	call   80104eb7 <initlock>
  (*f0)->type = FD_PIPE;
80103c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c72:	8b 00                	mov    (%eax),%eax
80103c74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c7d:	8b 00                	mov    (%eax),%eax
80103c7f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c83:	8b 45 08             	mov    0x8(%ebp),%eax
80103c86:	8b 00                	mov    (%eax),%eax
80103c88:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8f:	8b 00                	mov    (%eax),%eax
80103c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c94:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c9a:	8b 00                	mov    (%eax),%eax
80103c9c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cae:	8b 00                	mov    (%eax),%eax
80103cb0:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cb7:	8b 00                	mov    (%eax),%eax
80103cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cbc:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103cbf:	b8 00 00 00 00       	mov    $0x0,%eax
80103cc4:	eb 42                	jmp    80103d08 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cca:	74 0b                	je     80103cd7 <pipealloc+0x110>
    kfree((char*)p);
80103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccf:	89 04 24             	mov    %eax,(%esp)
80103cd2:	e8 6a ed ff ff       	call   80102a41 <kfree>
  if(*f0)
80103cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cda:	8b 00                	mov    (%eax),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 0d                	je     80103ced <pipealloc+0x126>
    fileclose(*f0);
80103ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce3:	8b 00                	mov    (%eax),%eax
80103ce5:	89 04 24             	mov    %eax,(%esp)
80103ce8:	e8 d9 d2 ff ff       	call   80100fc6 <fileclose>
  if(*f1)
80103ced:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf0:	8b 00                	mov    (%eax),%eax
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	74 0d                	je     80103d03 <pipealloc+0x13c>
    fileclose(*f1);
80103cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf9:	8b 00                	mov    (%eax),%eax
80103cfb:	89 04 24             	mov    %eax,(%esp)
80103cfe:	e8 c3 d2 ff ff       	call   80100fc6 <fileclose>
  return -1;
80103d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d08:	c9                   	leave  
80103d09:	c3                   	ret    

80103d0a <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d0a:	55                   	push   %ebp
80103d0b:	89 e5                	mov    %esp,%ebp
80103d0d:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d10:	8b 45 08             	mov    0x8(%ebp),%eax
80103d13:	89 04 24             	mov    %eax,(%esp)
80103d16:	e8 bd 11 00 00       	call   80104ed8 <acquire>
  if(writable){
80103d1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d1f:	74 1f                	je     80103d40 <pipeclose+0x36>
    p->writeopen = 0;
80103d21:	8b 45 08             	mov    0x8(%ebp),%eax
80103d24:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d2b:	00 00 00 
    wakeup(&p->nread);
80103d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d31:	05 34 02 00 00       	add    $0x234,%eax
80103d36:	89 04 24             	mov    %eax,(%esp)
80103d39:	e8 6d 0f 00 00       	call   80104cab <wakeup>
80103d3e:	eb 1d                	jmp    80103d5d <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d40:	8b 45 08             	mov    0x8(%ebp),%eax
80103d43:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d4a:	00 00 00 
    wakeup(&p->nwrite);
80103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d50:	05 38 02 00 00       	add    $0x238,%eax
80103d55:	89 04 24             	mov    %eax,(%esp)
80103d58:	e8 4e 0f 00 00       	call   80104cab <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d60:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d66:	85 c0                	test   %eax,%eax
80103d68:	75 25                	jne    80103d8f <pipeclose+0x85>
80103d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d73:	85 c0                	test   %eax,%eax
80103d75:	75 18                	jne    80103d8f <pipeclose+0x85>
    release(&p->lock);
80103d77:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7a:	89 04 24             	mov    %eax,(%esp)
80103d7d:	e8 b8 11 00 00       	call   80104f3a <release>
    kfree((char*)p);
80103d82:	8b 45 08             	mov    0x8(%ebp),%eax
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 b4 ec ff ff       	call   80102a41 <kfree>
80103d8d:	eb 0b                	jmp    80103d9a <pipeclose+0x90>
  } else
    release(&p->lock);
80103d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d92:	89 04 24             	mov    %eax,(%esp)
80103d95:	e8 a0 11 00 00       	call   80104f3a <release>
}
80103d9a:	c9                   	leave  
80103d9b:	c3                   	ret    

80103d9c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d9c:	55                   	push   %ebp
80103d9d:	89 e5                	mov    %esp,%ebp
80103d9f:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103da2:	8b 45 08             	mov    0x8(%ebp),%eax
80103da5:	89 04 24             	mov    %eax,(%esp)
80103da8:	e8 2b 11 00 00       	call   80104ed8 <acquire>
  for(i = 0; i < n; i++){
80103dad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103db4:	e9 a6 00 00 00       	jmp    80103e5f <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103db9:	eb 57                	jmp    80103e12 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbe:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	74 0d                	je     80103dd5 <pipewrite+0x39>
80103dc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dce:	8b 40 24             	mov    0x24(%eax),%eax
80103dd1:	85 c0                	test   %eax,%eax
80103dd3:	74 15                	je     80103dea <pipewrite+0x4e>
        release(&p->lock);
80103dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd8:	89 04 24             	mov    %eax,(%esp)
80103ddb:	e8 5a 11 00 00       	call   80104f3a <release>
        return -1;
80103de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103de5:	e9 9f 00 00 00       	jmp    80103e89 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103dea:	8b 45 08             	mov    0x8(%ebp),%eax
80103ded:	05 34 02 00 00       	add    $0x234,%eax
80103df2:	89 04 24             	mov    %eax,(%esp)
80103df5:	e8 b1 0e 00 00       	call   80104cab <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfd:	8b 55 08             	mov    0x8(%ebp),%edx
80103e00:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e06:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e0a:	89 14 24             	mov    %edx,(%esp)
80103e0d:	e8 55 0d 00 00       	call   80104b67 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e12:	8b 45 08             	mov    0x8(%ebp),%eax
80103e15:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e24:	05 00 02 00 00       	add    $0x200,%eax
80103e29:	39 c2                	cmp    %eax,%edx
80103e2b:	74 8e                	je     80103dbb <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e30:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e36:	8d 48 01             	lea    0x1(%eax),%ecx
80103e39:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3c:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e42:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e47:	89 c1                	mov    %eax,%ecx
80103e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4f:	01 d0                	add    %edx,%eax
80103e51:	0f b6 10             	movzbl (%eax),%edx
80103e54:	8b 45 08             	mov    0x8(%ebp),%eax
80103e57:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e62:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e65:	0f 8c 4e ff ff ff    	jl     80103db9 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6e:	05 34 02 00 00       	add    $0x234,%eax
80103e73:	89 04 24             	mov    %eax,(%esp)
80103e76:	e8 30 0e 00 00       	call   80104cab <wakeup>
  release(&p->lock);
80103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7e:	89 04 24             	mov    %eax,(%esp)
80103e81:	e8 b4 10 00 00       	call   80104f3a <release>
  return n;
80103e86:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103e89:	c9                   	leave  
80103e8a:	c3                   	ret    

80103e8b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e8b:	55                   	push   %ebp
80103e8c:	89 e5                	mov    %esp,%ebp
80103e8e:	53                   	push   %ebx
80103e8f:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e92:	8b 45 08             	mov    0x8(%ebp),%eax
80103e95:	89 04 24             	mov    %eax,(%esp)
80103e98:	e8 3b 10 00 00       	call   80104ed8 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e9d:	eb 3a                	jmp    80103ed9 <piperead+0x4e>
    if(proc->killed){
80103e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ea5:	8b 40 24             	mov    0x24(%eax),%eax
80103ea8:	85 c0                	test   %eax,%eax
80103eaa:	74 15                	je     80103ec1 <piperead+0x36>
      release(&p->lock);
80103eac:	8b 45 08             	mov    0x8(%ebp),%eax
80103eaf:	89 04 24             	mov    %eax,(%esp)
80103eb2:	e8 83 10 00 00       	call   80104f3a <release>
      return -1;
80103eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ebc:	e9 b5 00 00 00       	jmp    80103f76 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ec7:	81 c2 34 02 00 00    	add    $0x234,%edx
80103ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ed1:	89 14 24             	mov    %edx,(%esp)
80103ed4:	e8 8e 0c 00 00       	call   80104b67 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103eeb:	39 c2                	cmp    %eax,%edx
80103eed:	75 0d                	jne    80103efc <piperead+0x71>
80103eef:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ef8:	85 c0                	test   %eax,%eax
80103efa:	75 a3                	jne    80103e9f <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103efc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f03:	eb 4b                	jmp    80103f50 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103f05:	8b 45 08             	mov    0x8(%ebp),%eax
80103f08:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f11:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f17:	39 c2                	cmp    %eax,%edx
80103f19:	75 02                	jne    80103f1d <piperead+0x92>
      break;
80103f1b:	eb 3b                	jmp    80103f58 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f23:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f26:	8b 45 08             	mov    0x8(%ebp),%eax
80103f29:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f2f:	8d 48 01             	lea    0x1(%eax),%ecx
80103f32:	8b 55 08             	mov    0x8(%ebp),%edx
80103f35:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f3b:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f40:	89 c2                	mov    %eax,%edx
80103f42:	8b 45 08             	mov    0x8(%ebp),%eax
80103f45:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f4a:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f53:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f56:	7c ad                	jl     80103f05 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f58:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5b:	05 38 02 00 00       	add    $0x238,%eax
80103f60:	89 04 24             	mov    %eax,(%esp)
80103f63:	e8 43 0d 00 00       	call   80104cab <wakeup>
  release(&p->lock);
80103f68:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6b:	89 04 24             	mov    %eax,(%esp)
80103f6e:	e8 c7 0f 00 00       	call   80104f3a <release>
  return i;
80103f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f76:	83 c4 24             	add    $0x24,%esp
80103f79:	5b                   	pop    %ebx
80103f7a:	5d                   	pop    %ebp
80103f7b:	c3                   	ret    

80103f7c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103f7c:	55                   	push   %ebp
80103f7d:	89 e5                	mov    %esp,%ebp
80103f7f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f82:	9c                   	pushf  
80103f83:	58                   	pop    %eax
80103f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103f8a:	c9                   	leave  
80103f8b:	c3                   	ret    

80103f8c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103f8c:	55                   	push   %ebp
80103f8d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103f8f:	fb                   	sti    
}
80103f90:	5d                   	pop    %ebp
80103f91:	c3                   	ret    

80103f92 <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
80103f92:	55                   	push   %ebp
80103f93:	89 e5                	mov    %esp,%ebp
80103f95:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
80103f98:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    d = dst;
80103f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(s < d && s + n > d){
80103fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103fa7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80103faa:	73 3d                	jae    80103fe9 <memcop+0x57>
80103fac:	8b 45 10             	mov    0x10(%ebp),%eax
80103faf:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103fb2:	01 d0                	add    %edx,%eax
80103fb4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80103fb7:	76 30                	jbe    80103fe9 <memcop+0x57>
        s += n;
80103fb9:	8b 45 10             	mov    0x10(%ebp),%eax
80103fbc:	01 45 fc             	add    %eax,-0x4(%ebp)
        d += n;
80103fbf:	8b 45 10             	mov    0x10(%ebp),%eax
80103fc2:	01 45 f8             	add    %eax,-0x8(%ebp)
        while(n-- > 0)
80103fc5:	eb 13                	jmp    80103fda <memcop+0x48>
            *--d = *--s;
80103fc7:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80103fcb:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80103fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103fd2:	0f b6 10             	movzbl (%eax),%edx
80103fd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103fd8:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
80103fda:	8b 45 10             	mov    0x10(%ebp),%eax
80103fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
80103fe0:	89 55 10             	mov    %edx,0x10(%ebp)
80103fe3:	85 c0                	test   %eax,%eax
80103fe5:	75 e0                	jne    80103fc7 <memcop+0x35>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
80103fe7:	eb 26                	jmp    8010400f <memcop+0x7d>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80103fe9:	eb 17                	jmp    80104002 <memcop+0x70>
            *d++ = *s++;
80103feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103fee:	8d 50 01             	lea    0x1(%eax),%edx
80103ff1:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103ff4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ff7:	8d 4a 01             	lea    0x1(%edx),%ecx
80103ffa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80103ffd:	0f b6 12             	movzbl (%edx),%edx
80104000:	88 10                	mov    %dl,(%eax)
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80104002:	8b 45 10             	mov    0x10(%ebp),%eax
80104005:	8d 50 ff             	lea    -0x1(%eax),%edx
80104008:	89 55 10             	mov    %edx,0x10(%ebp)
8010400b:	85 c0                	test   %eax,%eax
8010400d:	75 dc                	jne    80103feb <memcop+0x59>
            *d++ = *s++;

    return dst;
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104012:	c9                   	leave  
80104013:	c3                   	ret    

80104014 <pinit>:


    void
pinit(void)
{
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
8010401a:	c7 44 24 04 3c 88 10 	movl   $0x8010883c,0x4(%esp)
80104021:	80 
80104022:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104029:	e8 89 0e 00 00       	call   80104eb7 <initlock>
}
8010402e:	c9                   	leave  
8010402f:	c3                   	ret    

80104030 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
80104036:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010403d:	e8 96 0e 00 00       	call   80104ed8 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104042:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104049:	eb 53                	jmp    8010409e <allocproc+0x6e>
        if(p->state == UNUSED)
8010404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404e:	8b 40 0c             	mov    0xc(%eax),%eax
80104051:	85 c0                	test   %eax,%eax
80104053:	75 42                	jne    80104097 <allocproc+0x67>
            goto found;
80104055:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
80104056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104059:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
80104060:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104065:	8d 50 01             	lea    0x1(%eax),%edx
80104068:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010406e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104071:	89 42 10             	mov    %eax,0x10(%edx)
    release(&ptable.lock);
80104074:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010407b:	e8 ba 0e 00 00       	call   80104f3a <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80104080:	e8 55 ea ff ff       	call   80102ada <kalloc>
80104085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104088:	89 42 08             	mov    %eax,0x8(%edx)
8010408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010408e:	8b 40 08             	mov    0x8(%eax),%eax
80104091:	85 c0                	test   %eax,%eax
80104093:	75 36                	jne    801040cb <allocproc+0x9b>
80104095:	eb 23                	jmp    801040ba <allocproc+0x8a>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104097:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010409e:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
801040a5:	72 a4                	jb     8010404b <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
801040a7:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801040ae:	e8 87 0e 00 00       	call   80104f3a <release>
    return 0;
801040b3:	b8 00 00 00 00       	mov    $0x0,%eax
801040b8:	eb 76                	jmp    80104130 <allocproc+0x100>
    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
801040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
801040c4:	b8 00 00 00 00       	mov    $0x0,%eax
801040c9:	eb 65                	jmp    80104130 <allocproc+0x100>
    }
    sp = p->kstack + KSTACKSIZE;
801040cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ce:	8b 40 08             	mov    0x8(%eax),%eax
801040d1:	05 00 10 00 00       	add    $0x1000,%eax
801040d6:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801040d9:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
801040dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040e3:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
801040e6:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
801040ea:	ba 11 66 10 80       	mov    $0x80106611,%edx
801040ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040f2:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
801040f4:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040fe:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104104:	8b 40 1c             	mov    0x1c(%eax),%eax
80104107:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010410e:	00 
8010410f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104116:	00 
80104117:	89 04 24             	mov    %eax,(%esp)
8010411a:	e8 0d 10 00 00       	call   8010512c <memset>
    p->context->eip = (uint)forkret;
8010411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104122:	8b 40 1c             	mov    0x1c(%eax),%eax
80104125:	ba 3b 4b 10 80       	mov    $0x80104b3b,%edx
8010412a:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
8010412d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104130:	c9                   	leave  
80104131:	c3                   	ret    

80104132 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
80104132:	55                   	push   %ebp
80104133:	89 e5                	mov    %esp,%ebp
80104135:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80104138:	e8 f3 fe ff ff       	call   80104030 <allocproc>
8010413d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
80104140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104143:	a3 68 b6 10 80       	mov    %eax,0x8010b668
    if((p->pgdir = setupkvm()) == 0)
80104148:	e8 b8 3b 00 00       	call   80107d05 <setupkvm>
8010414d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104150:	89 42 04             	mov    %eax,0x4(%edx)
80104153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104156:	8b 40 04             	mov    0x4(%eax),%eax
80104159:	85 c0                	test   %eax,%eax
8010415b:	75 0c                	jne    80104169 <userinit+0x37>
        panic("userinit: out of memory?");
8010415d:	c7 04 24 43 88 10 80 	movl   $0x80108843,(%esp)
80104164:	e8 d1 c3 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104169:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010416e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104171:	8b 40 04             	mov    0x4(%eax),%eax
80104174:	89 54 24 08          	mov    %edx,0x8(%esp)
80104178:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
8010417f:	80 
80104180:	89 04 24             	mov    %eax,(%esp)
80104183:	e8 d5 3d 00 00       	call   80107f5d <inituvm>
    p->sz = PGSIZE;
80104188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
80104191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104194:	8b 40 18             	mov    0x18(%eax),%eax
80104197:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010419e:	00 
8010419f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041a6:	00 
801041a7:	89 04 24             	mov    %eax,(%esp)
801041aa:	e8 7d 0f 00 00       	call   8010512c <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b2:	8b 40 18             	mov    0x18(%eax),%eax
801041b5:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041be:	8b 40 18             	mov    0x18(%eax),%eax
801041c1:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801041c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ca:	8b 40 18             	mov    0x18(%eax),%eax
801041cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d0:	8b 52 18             	mov    0x18(%edx),%edx
801041d3:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801041d7:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041de:	8b 40 18             	mov    0x18(%eax),%eax
801041e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e4:	8b 52 18             	mov    0x18(%edx),%edx
801041e7:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801041eb:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801041ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f2:	8b 40 18             	mov    0x18(%eax),%eax
801041f5:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ff:	8b 40 18             	mov    0x18(%eax),%eax
80104202:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420c:	8b 40 18             	mov    0x18(%eax),%eax
8010420f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104219:	83 c0 6c             	add    $0x6c,%eax
8010421c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104223:	00 
80104224:	c7 44 24 04 5c 88 10 	movl   $0x8010885c,0x4(%esp)
8010422b:	80 
8010422c:	89 04 24             	mov    %eax,(%esp)
8010422f:	e8 18 11 00 00       	call   8010534c <safestrcpy>
    p->cwd = namei("/");
80104234:	c7 04 24 65 88 10 80 	movl   $0x80108865,(%esp)
8010423b:	e8 be e1 ff ff       	call   801023fe <namei>
80104240:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104243:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
80104246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104249:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104250:	c9                   	leave  
80104251:	c3                   	ret    

80104252 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
80104252:	55                   	push   %ebp
80104253:	89 e5                	mov    %esp,%ebp
80104255:	83 ec 28             	sub    $0x28,%esp
    uint sz;

    sz = proc->sz;
80104258:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010425e:	8b 00                	mov    (%eax),%eax
80104260:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
80104263:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104267:	7e 34                	jle    8010429d <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104269:	8b 55 08             	mov    0x8(%ebp),%edx
8010426c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426f:	01 c2                	add    %eax,%edx
80104271:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104277:	8b 40 04             	mov    0x4(%eax),%eax
8010427a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010427e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104281:	89 54 24 04          	mov    %edx,0x4(%esp)
80104285:	89 04 24             	mov    %eax,(%esp)
80104288:	e8 46 3e 00 00       	call   801080d3 <allocuvm>
8010428d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104294:	75 41                	jne    801042d7 <growproc+0x85>
            return -1;
80104296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429b:	eb 58                	jmp    801042f5 <growproc+0xa3>
    } else if(n < 0){
8010429d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042a1:	79 34                	jns    801042d7 <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042a3:	8b 55 08             	mov    0x8(%ebp),%edx
801042a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a9:	01 c2                	add    %eax,%edx
801042ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b1:	8b 40 04             	mov    0x4(%eax),%eax
801042b4:	89 54 24 08          	mov    %edx,0x8(%esp)
801042b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801042bf:	89 04 24             	mov    %eax,(%esp)
801042c2:	e8 e6 3e 00 00       	call   801081ad <deallocuvm>
801042c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042ce:	75 07                	jne    801042d7 <growproc+0x85>
            return -1;
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d5:	eb 1e                	jmp    801042f5 <growproc+0xa3>
    }
    proc->sz = sz;
801042d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042e0:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
801042e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e8:	89 04 24             	mov    %eax,(%esp)
801042eb:	e8 06 3b 00 00       	call   80107df6 <switchuvm>
    return 0;
801042f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042f5:	c9                   	leave  
801042f6:	c3                   	ret    

801042f7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
801042f7:	55                   	push   %ebp
801042f8:	89 e5                	mov    %esp,%ebp
801042fa:	57                   	push   %edi
801042fb:	56                   	push   %esi
801042fc:	53                   	push   %ebx
801042fd:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
80104300:	e8 2b fd ff ff       	call   80104030 <allocproc>
80104305:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104308:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010430c:	75 0a                	jne    80104318 <fork+0x21>
        return -1;
8010430e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104313:	e9 47 01 00 00       	jmp    8010445f <fork+0x168>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104318:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431e:	8b 10                	mov    (%eax),%edx
80104320:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104326:	8b 40 04             	mov    0x4(%eax),%eax
80104329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010432d:	89 04 24             	mov    %eax,(%esp)
80104330:	e8 14 40 00 00       	call   80108349 <copyuvm>
80104335:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104338:	89 42 04             	mov    %eax,0x4(%edx)
8010433b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433e:	8b 40 04             	mov    0x4(%eax),%eax
80104341:	85 c0                	test   %eax,%eax
80104343:	75 2c                	jne    80104371 <fork+0x7a>
        kfree(np->kstack);
80104345:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104348:	8b 40 08             	mov    0x8(%eax),%eax
8010434b:	89 04 24             	mov    %eax,(%esp)
8010434e:	e8 ee e6 ff ff       	call   80102a41 <kfree>
        np->kstack = 0;
80104353:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104356:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
8010435d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104360:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
80104367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010436c:	e9 ee 00 00 00       	jmp    8010445f <fork+0x168>
    }
    np->sz = proc->sz;
80104371:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104377:	8b 10                	mov    (%eax),%edx
80104379:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010437c:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
8010437e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104385:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104388:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
8010438b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438e:	8b 50 18             	mov    0x18(%eax),%edx
80104391:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104397:	8b 40 18             	mov    0x18(%eax),%eax
8010439a:	89 c3                	mov    %eax,%ebx
8010439c:	b8 13 00 00 00       	mov    $0x13,%eax
801043a1:	89 d7                	mov    %edx,%edi
801043a3:	89 de                	mov    %ebx,%esi
801043a5:	89 c1                	mov    %eax,%ecx
801043a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
801043a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043ac:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801043b3:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801043b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b9:	8b 40 18             	mov    0x18(%eax),%eax
801043bc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
801043c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801043ca:	eb 3d                	jmp    80104409 <fork+0x112>
        if(proc->ofile[i])
801043cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043d5:	83 c2 08             	add    $0x8,%edx
801043d8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043dc:	85 c0                	test   %eax,%eax
801043de:	74 25                	je     80104405 <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
801043e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043e9:	83 c2 08             	add    $0x8,%edx
801043ec:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043f0:	89 04 24             	mov    %eax,(%esp)
801043f3:	e8 86 cb ff ff       	call   80100f7e <filedup>
801043f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043fe:	83 c1 08             	add    $0x8,%ecx
80104401:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80104405:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104409:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010440d:	7e bd                	jle    801043cc <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
8010440f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104415:	8b 40 68             	mov    0x68(%eax),%eax
80104418:	89 04 24             	mov    %eax,(%esp)
8010441b:	e8 01 d4 ff ff       	call   80101821 <idup>
80104420:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104423:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
80104426:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104429:	8b 40 10             	mov    0x10(%eax),%eax
8010442c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    np->state = RUNNABLE;
8010442f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104432:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104439:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010443f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104442:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104445:	83 c0 6c             	add    $0x6c,%eax
80104448:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010444f:	00 
80104450:	89 54 24 04          	mov    %edx,0x4(%esp)
80104454:	89 04 24             	mov    %eax,(%esp)
80104457:	e8 f0 0e 00 00       	call   8010534c <safestrcpy>
    return pid;
8010445c:	8b 45 dc             	mov    -0x24(%ebp),%eax

}
8010445f:	83 c4 2c             	add    $0x2c,%esp
80104462:	5b                   	pop    %ebx
80104463:	5e                   	pop    %esi
80104464:	5f                   	pop    %edi
80104465:	5d                   	pop    %ebp
80104466:	c3                   	ret    

80104467 <clone>:

//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
80104467:	55                   	push   %ebp
80104468:	89 e5                	mov    %esp,%ebp
8010446a:	57                   	push   %edi
8010446b:	56                   	push   %esi
8010446c:	53                   	push   %ebx
8010446d:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
80104473:	e8 b8 fb ff ff       	call   80104030 <allocproc>
80104478:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010447b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
8010447f:	75 0a                	jne    8010448b <clone+0x24>
        return -1;
80104481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104486:	e9 f4 01 00 00       	jmp    8010467f <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
8010448b:	8b 45 08             	mov    0x8(%ebp),%eax
8010448e:	25 ff 0f 00 00       	and    $0xfff,%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	75 0c                	jne    801044a3 <clone+0x3c>
80104497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010449b:	74 06                	je     801044a3 <clone+0x3c>
8010449d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801044a1:	75 0a                	jne    801044ad <clone+0x46>
        return -1;
801044a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044a8:	e9 d2 01 00 00       	jmp    8010467f <clone+0x218>

    np->pgdir = proc->pgdir;
801044ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b3:	8b 50 04             	mov    0x4(%eax),%edx
801044b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044b9:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
801044bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c2:	8b 10                	mov    (%eax),%edx
801044c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044c7:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801044c9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044d3:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
801044d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044d9:	8b 50 18             	mov    0x18(%eax),%edx
801044dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e2:	8b 40 18             	mov    0x18(%eax),%eax
801044e5:	89 c3                	mov    %eax,%ebx
801044e7:	b8 13 00 00 00       	mov    $0x13,%eax
801044ec:	89 d7                	mov    %edx,%edi
801044ee:	89 de                	mov    %ebx,%esi
801044f0:	89 c1                	mov    %eax,%ecx
801044f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
801044f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044f7:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801044fe:	00 00 00 
    pid = np->pid;
80104501:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104504:	8b 40 10             	mov    0x10(%eax),%eax
80104507:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
8010450a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104510:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
80104513:	eb 09                	jmp    8010451e <clone+0xb7>
        pp = pp->parent;
80104515:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104518:	8b 40 14             	mov    0x14(%eax),%eax
8010451b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
8010451e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104521:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104527:	83 f8 01             	cmp    $0x1,%eax
8010452a:	74 e9                	je     80104515 <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
8010452c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010452f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104532:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
80104535:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010453c:	eb 3d                	jmp    8010457b <clone+0x114>
        if(proc->ofile[i])
8010453e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104544:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104547:	83 c2 08             	add    $0x8,%edx
8010454a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010454e:	85 c0                	test   %eax,%eax
80104550:	74 25                	je     80104577 <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
80104552:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104558:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010455b:	83 c2 08             	add    $0x8,%edx
8010455e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104562:	89 04 24             	mov    %eax,(%esp)
80104565:	e8 14 ca ff ff       	call   80100f7e <filedup>
8010456a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010456d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104570:	83 c1 08             	add    $0x8,%ecx
80104573:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
80104577:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010457b:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010457f:	7e bd                	jle    8010453e <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104581:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104584:	8b 40 18             	mov    0x18(%eax),%eax
80104587:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
8010458e:	8b 45 08             	mov    0x8(%ebp),%eax
80104591:	05 00 10 00 00       	add    $0x1000,%eax
80104596:	89 45 d4             	mov    %eax,-0x2c(%ebp)
//


//modify here <<<<<

    np->tf->ebp = sp;
80104599:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010459c:	8b 40 18             	mov    0x18(%eax),%eax
8010459f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045a2:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
801045a5:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
801045ac:	ff ff ff 
    ustack[1] = arg;
801045af:	8b 45 14             	mov    0x14(%ebp),%eax
801045b2:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
801045b8:	83 6d d4 08          	subl   $0x8,-0x2c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
801045bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045bf:	8b 40 04             	mov    0x4(%eax),%eax
801045c2:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
801045c9:	00 
801045ca:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
801045d0:	89 54 24 08          	mov    %edx,0x8(%esp)
801045d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045d7:	89 54 24 04          	mov    %edx,0x4(%esp)
801045db:	89 04 24             	mov    %eax,(%esp)
801045de:	e8 e5 3e 00 00       	call   801084c8 <copyout>
801045e3:	85 c0                	test   %eax,%eax
801045e5:	79 16                	jns    801045fd <clone+0x196>
        cprintf("push arg fails\n");
801045e7:	c7 04 24 67 88 10 80 	movl   $0x80108867,(%esp)
801045ee:	e8 ad bd ff ff       	call   801003a0 <cprintf>
        return -1;
801045f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f8:	e9 82 00 00 00       	jmp    8010467f <clone+0x218>
    }

    np->tf->eip = routine;
801045fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104600:	8b 40 18             	mov    0x18(%eax),%eax
80104603:	8b 55 10             	mov    0x10(%ebp),%edx
80104606:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
80104609:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010460c:	8b 40 18             	mov    0x18(%eax),%eax
8010460f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104612:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
80104615:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461b:	8b 40 68             	mov    0x68(%eax),%eax
8010461e:	89 04 24             	mov    %eax,(%esp)
80104621:	e8 fb d1 ff ff       	call   80101821 <idup>
80104626:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104629:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
8010462c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010462f:	89 04 24             	mov    %eax,(%esp)
80104632:	e8 bf 37 00 00       	call   80107df6 <switchuvm>

     acquire(&ptable.lock);
80104637:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010463e:	e8 95 08 00 00       	call   80104ed8 <acquire>
    np->state = RUNNABLE;
80104643:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104646:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
     release(&ptable.lock);
8010464d:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104654:	e8 e1 08 00 00       	call   80104f3a <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104659:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010465f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104662:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104665:	83 c0 6c             	add    $0x6c,%eax
80104668:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010466f:	00 
80104670:	89 54 24 04          	mov    %edx,0x4(%esp)
80104674:	89 04 24             	mov    %eax,(%esp)
80104677:	e8 d0 0c 00 00       	call   8010534c <safestrcpy>


    return pid;
8010467c:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
8010467f:	81 c4 bc 00 00 00    	add    $0xbc,%esp
80104685:	5b                   	pop    %ebx
80104686:	5e                   	pop    %esi
80104687:	5f                   	pop    %edi
80104688:	5d                   	pop    %ebp
80104689:	c3                   	ret    

8010468a <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
8010468a:	55                   	push   %ebp
8010468b:	89 e5                	mov    %esp,%ebp
8010468d:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
80104690:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104697:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010469c:	39 c2                	cmp    %eax,%edx
8010469e:	75 0c                	jne    801046ac <exit+0x22>
        panic("init exiting");
801046a0:	c7 04 24 77 88 10 80 	movl   $0x80108877,(%esp)
801046a7:	e8 8e be ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801046ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801046b3:	eb 44                	jmp    801046f9 <exit+0x6f>
        if(proc->ofile[fd]){
801046b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046be:	83 c2 08             	add    $0x8,%edx
801046c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c5:	85 c0                	test   %eax,%eax
801046c7:	74 2c                	je     801046f5 <exit+0x6b>
            fileclose(proc->ofile[fd]);
801046c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046d2:	83 c2 08             	add    $0x8,%edx
801046d5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046d9:	89 04 24             	mov    %eax,(%esp)
801046dc:	e8 e5 c8 ff ff       	call   80100fc6 <fileclose>
            proc->ofile[fd] = 0;
801046e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046ea:	83 c2 08             	add    $0x8,%edx
801046ed:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801046f4:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801046f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801046f9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801046fd:	7e b6                	jle    801046b5 <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
801046ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104705:	8b 40 68             	mov    0x68(%eax),%eax
80104708:	89 04 24             	mov    %eax,(%esp)
8010470b:	e8 f6 d2 ff ff       	call   80101a06 <iput>
    proc->cwd = 0;
80104710:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104716:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
8010471d:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104724:	e8 af 07 00 00       	call   80104ed8 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104729:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010472f:	8b 40 14             	mov    0x14(%eax),%eax
80104732:	89 04 24             	mov    %eax,(%esp)
80104735:	e8 c8 04 00 00       	call   80104c02 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010473a:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104741:	eb 3b                	jmp    8010477e <exit+0xf4>
        if(p->parent == proc){
80104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104746:	8b 50 14             	mov    0x14(%eax),%edx
80104749:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010474f:	39 c2                	cmp    %eax,%edx
80104751:	75 24                	jne    80104777 <exit+0xed>
            p->parent = initproc;
80104753:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
80104759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475c:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
8010475f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104762:	8b 40 0c             	mov    0xc(%eax),%eax
80104765:	83 f8 05             	cmp    $0x5,%eax
80104768:	75 0d                	jne    80104777 <exit+0xed>
                wakeup1(initproc);
8010476a:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010476f:	89 04 24             	mov    %eax,(%esp)
80104772:	e8 8b 04 00 00       	call   80104c02 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104777:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010477e:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
80104785:	72 bc                	jb     80104743 <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104787:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478d:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104794:	e8 95 02 00 00       	call   80104a2e <sched>
    panic("zombie exit");
80104799:	c7 04 24 84 88 10 80 	movl   $0x80108884,(%esp)
801047a0:	e8 95 bd ff ff       	call   8010053a <panic>

801047a5 <texit>:
}
    void
texit(void)
{
801047a5:	55                   	push   %ebp
801047a6:	89 e5                	mov    %esp,%ebp
801047a8:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
801047ab:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047b2:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801047b7:	39 c2                	cmp    %eax,%edx
801047b9:	75 0c                	jne    801047c7 <texit+0x22>
        panic("init exiting");
801047bb:	c7 04 24 77 88 10 80 	movl   $0x80108877,(%esp)
801047c2:	e8 73 bd ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
801047c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801047ce:	eb 44                	jmp    80104814 <texit+0x6f>
        if(proc->ofile[fd]){
801047d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047d9:	83 c2 08             	add    $0x8,%edx
801047dc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047e0:	85 c0                	test   %eax,%eax
801047e2:	74 2c                	je     80104810 <texit+0x6b>
            fileclose(proc->ofile[fd]);
801047e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ed:	83 c2 08             	add    $0x8,%edx
801047f0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047f4:	89 04 24             	mov    %eax,(%esp)
801047f7:	e8 ca c7 ff ff       	call   80100fc6 <fileclose>
            proc->ofile[fd] = 0;
801047fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104802:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104805:	83 c2 08             	add    $0x8,%edx
80104808:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010480f:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104810:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104814:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104818:	7e b6                	jle    801047d0 <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
8010481a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104820:	8b 40 68             	mov    0x68(%eax),%eax
80104823:	89 04 24             	mov    %eax,(%esp)
80104826:	e8 db d1 ff ff       	call   80101a06 <iput>
    proc->cwd = 0;
8010482b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104831:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104838:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010483f:	e8 94 06 00 00       	call   80104ed8 <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104844:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484a:	8b 40 14             	mov    0x14(%eax),%eax
8010484d:	89 04 24             	mov    %eax,(%esp)
80104850:	e8 ad 03 00 00       	call   80104c02 <wakeup1>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104855:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104862:	e8 c7 01 00 00       	call   80104a2e <sched>
    panic("zombie exit");
80104867:	c7 04 24 84 88 10 80 	movl   $0x80108884,(%esp)
8010486e:	e8 c7 bc ff ff       	call   8010053a <panic>

80104873 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80104873:	55                   	push   %ebp
80104874:	89 e5                	mov    %esp,%ebp
80104876:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104879:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104880:	e8 53 06 00 00       	call   80104ed8 <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104885:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488c:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104893:	e9 ab 00 00 00       	jmp    80104943 <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
80104898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489b:	8b 50 14             	mov    0x14(%eax),%edx
8010489e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a4:	39 c2                	cmp    %eax,%edx
801048a6:	74 05                	je     801048ad <wait+0x3a>
                continue;
801048a8:	e9 8f 00 00 00       	jmp    8010493c <wait+0xc9>
            havekids = 1;
801048ad:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
801048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b7:	8b 40 0c             	mov    0xc(%eax),%eax
801048ba:	83 f8 05             	cmp    $0x5,%eax
801048bd:	75 7d                	jne    8010493c <wait+0xc9>
                // Found one.
                pid = p->pid;
801048bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c2:	8b 40 10             	mov    0x10(%eax),%eax
801048c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
801048c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048cb:	8b 40 08             	mov    0x8(%eax),%eax
801048ce:	89 04 24             	mov    %eax,(%esp)
801048d1:	e8 6b e1 ff ff       	call   80102a41 <kfree>
                p->kstack = 0;
801048d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
801048e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801048e9:	83 f8 01             	cmp    $0x1,%eax
801048ec:	74 0e                	je     801048fc <wait+0x89>
                    freevm(p->pgdir);
801048ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f1:	8b 40 04             	mov    0x4(%eax),%eax
801048f4:	89 04 24             	mov    %eax,(%esp)
801048f7:	e8 6d 39 00 00       	call   80108269 <freevm>
                }
                p->state = UNUSED;
801048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
80104906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104909:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80104910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104913:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104924:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
8010492b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104932:	e8 03 06 00 00       	call   80104f3a <release>
                return pid;
80104937:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010493a:	eb 55                	jmp    80104991 <wait+0x11e>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493c:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104943:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
8010494a:	0f 82 48 ff ff ff    	jb     80104898 <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80104950:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104954:	74 0d                	je     80104963 <wait+0xf0>
80104956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010495c:	8b 40 24             	mov    0x24(%eax),%eax
8010495f:	85 c0                	test   %eax,%eax
80104961:	74 13                	je     80104976 <wait+0x103>
            release(&ptable.lock);
80104963:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010496a:	e8 cb 05 00 00       	call   80104f3a <release>
            return -1;
8010496f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104974:	eb 1b                	jmp    80104991 <wait+0x11e>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104976:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497c:	c7 44 24 04 40 ff 10 	movl   $0x8010ff40,0x4(%esp)
80104983:	80 
80104984:	89 04 24             	mov    %eax,(%esp)
80104987:	e8 db 01 00 00       	call   80104b67 <sleep>
    }
8010498c:	e9 f4 fe ff ff       	jmp    80104885 <wait+0x12>
}
80104991:	c9                   	leave  
80104992:	c3                   	ret    

80104993 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104993:	55                   	push   %ebp
80104994:	89 e5                	mov    %esp,%ebp
80104996:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104999:	e8 ee f5 ff ff       	call   80103f8c <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
8010499e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801049a5:	e8 2e 05 00 00       	call   80104ed8 <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049aa:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
801049b1:	eb 61                	jmp    80104a14 <scheduler+0x81>
            if(p->state != RUNNABLE)
801049b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b6:	8b 40 0c             	mov    0xc(%eax),%eax
801049b9:	83 f8 03             	cmp    $0x3,%eax
801049bc:	74 02                	je     801049c0 <scheduler+0x2d>
                continue;
801049be:	eb 4d                	jmp    80104a0d <scheduler+0x7a>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
801049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c3:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
801049c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049cc:	89 04 24             	mov    %eax,(%esp)
801049cf:	e8 22 34 00 00       	call   80107df6 <switchuvm>
            p->state = RUNNING;
801049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d7:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
801049de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e4:	8b 40 1c             	mov    0x1c(%eax),%eax
801049e7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801049ee:	83 c2 04             	add    $0x4,%edx
801049f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801049f5:	89 14 24             	mov    %edx,(%esp)
801049f8:	e8 c0 09 00 00       	call   801053bd <swtch>
            switchkvm();
801049fd:	e8 d7 33 00 00       	call   80107dd9 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104a02:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104a09:	00 00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a0d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a14:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
80104a1b:	72 96                	jb     801049b3 <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104a1d:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104a24:	e8 11 05 00 00       	call   80104f3a <release>

    }
80104a29:	e9 6b ff ff ff       	jmp    80104999 <scheduler+0x6>

80104a2e <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104a2e:	55                   	push   %ebp
80104a2f:	89 e5                	mov    %esp,%ebp
80104a31:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104a34:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104a3b:	e8 c2 05 00 00       	call   80105002 <holding>
80104a40:	85 c0                	test   %eax,%eax
80104a42:	75 0c                	jne    80104a50 <sched+0x22>
        panic("sched ptable.lock");
80104a44:	c7 04 24 90 88 10 80 	movl   $0x80108890,(%esp)
80104a4b:	e8 ea ba ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104a50:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a56:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104a5c:	83 f8 01             	cmp    $0x1,%eax
80104a5f:	74 35                	je     80104a96 <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104a61:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a67:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 40 10             	mov    0x10(%eax),%eax
80104a76:	89 54 24 08          	mov    %edx,0x8(%esp)
80104a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7e:	c7 04 24 a4 88 10 80 	movl   $0x801088a4,(%esp)
80104a85:	e8 16 b9 ff ff       	call   801003a0 <cprintf>
        panic("sched locks");
80104a8a:	c7 04 24 c3 88 10 80 	movl   $0x801088c3,(%esp)
80104a91:	e8 a4 ba ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104a96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9f:	83 f8 04             	cmp    $0x4,%eax
80104aa2:	75 0c                	jne    80104ab0 <sched+0x82>
        panic("sched running");
80104aa4:	c7 04 24 cf 88 10 80 	movl   $0x801088cf,(%esp)
80104aab:	e8 8a ba ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104ab0:	e8 c7 f4 ff ff       	call   80103f7c <readeflags>
80104ab5:	25 00 02 00 00       	and    $0x200,%eax
80104aba:	85 c0                	test   %eax,%eax
80104abc:	74 0c                	je     80104aca <sched+0x9c>
        panic("sched interruptible");
80104abe:	c7 04 24 dd 88 10 80 	movl   $0x801088dd,(%esp)
80104ac5:	e8 70 ba ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104aca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ad0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104ad9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104adf:	8b 40 04             	mov    0x4(%eax),%eax
80104ae2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ae9:	83 c2 1c             	add    $0x1c,%edx
80104aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104af0:	89 14 24             	mov    %edx,(%esp)
80104af3:	e8 c5 08 00 00       	call   801053bd <swtch>
    cpu->intena = intena;
80104af8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b01:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104b07:	c9                   	leave  
80104b08:	c3                   	ret    

80104b09 <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104b09:	55                   	push   %ebp
80104b0a:	89 e5                	mov    %esp,%ebp
80104b0c:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104b0f:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b16:	e8 bd 03 00 00       	call   80104ed8 <acquire>
    proc->state = RUNNABLE;
80104b1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b21:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104b28:	e8 01 ff ff ff       	call   80104a2e <sched>
    release(&ptable.lock);
80104b2d:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b34:	e8 01 04 00 00       	call   80104f3a <release>
}
80104b39:	c9                   	leave  
80104b3a:	c3                   	ret    

80104b3b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104b3b:	55                   	push   %ebp
80104b3c:	89 e5                	mov    %esp,%ebp
80104b3e:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104b41:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b48:	e8 ed 03 00 00       	call   80104f3a <release>

    if (first) {
80104b4d:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104b52:	85 c0                	test   %eax,%eax
80104b54:	74 0f                	je     80104b65 <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104b56:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104b5d:	00 00 00 
        initlog();
80104b60:	e8 6a e4 ff ff       	call   80102fcf <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    

80104b67 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104b67:	55                   	push   %ebp
80104b68:	89 e5                	mov    %esp,%ebp
80104b6a:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104b6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b73:	85 c0                	test   %eax,%eax
80104b75:	75 0c                	jne    80104b83 <sleep+0x1c>
        panic("sleep");
80104b77:	c7 04 24 f1 88 10 80 	movl   $0x801088f1,(%esp)
80104b7e:	e8 b7 b9 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104b83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b87:	75 0c                	jne    80104b95 <sleep+0x2e>
        panic("sleep without lk");
80104b89:	c7 04 24 f7 88 10 80 	movl   $0x801088f7,(%esp)
80104b90:	e8 a5 b9 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104b95:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104b9c:	74 17                	je     80104bb5 <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104b9e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ba5:	e8 2e 03 00 00       	call   80104ed8 <acquire>
        release(lk);
80104baa:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bad:	89 04 24             	mov    %eax,(%esp)
80104bb0:	e8 85 03 00 00       	call   80104f3a <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bbb:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbe:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104bc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104bce:	e8 5b fe ff ff       	call   80104a2e <sched>

    // Tidy up.
    proc->chan = 0;
80104bd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104be0:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104be7:	74 17                	je     80104c00 <sleep+0x99>
        release(&ptable.lock);
80104be9:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104bf0:	e8 45 03 00 00       	call   80104f3a <release>
        acquire(lk);
80104bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf8:	89 04 24             	mov    %eax,(%esp)
80104bfb:	e8 d8 02 00 00       	call   80104ed8 <acquire>
    }
}
80104c00:	c9                   	leave  
80104c01:	c3                   	ret    

80104c02 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104c02:	55                   	push   %ebp
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c08:	c7 45 fc 74 ff 10 80 	movl   $0x8010ff74,-0x4(%ebp)
80104c0f:	eb 27                	jmp    80104c38 <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c14:	8b 40 0c             	mov    0xc(%eax),%eax
80104c17:	83 f8 02             	cmp    $0x2,%eax
80104c1a:	75 15                	jne    80104c31 <wakeup1+0x2f>
80104c1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c1f:	8b 40 20             	mov    0x20(%eax),%eax
80104c22:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c25:	75 0a                	jne    80104c31 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c2a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c31:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104c38:	81 7d fc 74 20 11 80 	cmpl   $0x80112074,-0x4(%ebp)
80104c3f:	72 d0                	jb     80104c11 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104c41:	c9                   	leave  
80104c42:	c3                   	ret    

80104c43 <twakeup>:

void 
twakeup(int tid){
80104c43:	55                   	push   %ebp
80104c44:	89 e5                	mov    %esp,%ebp
80104c46:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104c49:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104c50:	e8 83 02 00 00       	call   80104ed8 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c55:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104c5c:	eb 36                	jmp    80104c94 <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c61:	8b 40 0c             	mov    0xc(%eax),%eax
80104c64:	83 f8 02             	cmp    $0x2,%eax
80104c67:	75 24                	jne    80104c8d <twakeup+0x4a>
80104c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6c:	8b 40 10             	mov    0x10(%eax),%eax
80104c6f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c72:	75 19                	jne    80104c8d <twakeup+0x4a>
80104c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c77:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104c7d:	83 f8 01             	cmp    $0x1,%eax
80104c80:	75 0b                	jne    80104c8d <twakeup+0x4a>
            wakeup1(p);
80104c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c85:	89 04 24             	mov    %eax,(%esp)
80104c88:	e8 75 ff ff ff       	call   80104c02 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c8d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104c94:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
80104c9b:	72 c1                	jb     80104c5e <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104c9d:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ca4:	e8 91 02 00 00       	call   80104f3a <release>
}
80104ca9:	c9                   	leave  
80104caa:	c3                   	ret    

80104cab <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104cab:	55                   	push   %ebp
80104cac:	89 e5                	mov    %esp,%ebp
80104cae:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104cb1:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104cb8:	e8 1b 02 00 00       	call   80104ed8 <acquire>
    wakeup1(chan);
80104cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc0:	89 04 24             	mov    %eax,(%esp)
80104cc3:	e8 3a ff ff ff       	call   80104c02 <wakeup1>
    release(&ptable.lock);
80104cc8:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ccf:	e8 66 02 00 00       	call   80104f3a <release>
}
80104cd4:	c9                   	leave  
80104cd5:	c3                   	ret    

80104cd6 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104cd6:	55                   	push   %ebp
80104cd7:	89 e5                	mov    %esp,%ebp
80104cd9:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104cdc:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ce3:	e8 f0 01 00 00       	call   80104ed8 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce8:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104cef:	eb 44                	jmp    80104d35 <kill+0x5f>
        if(p->pid == pid){
80104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf4:	8b 40 10             	mov    0x10(%eax),%eax
80104cf7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104cfa:	75 32                	jne    80104d2e <kill+0x58>
            p->killed = 1;
80104cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cff:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d09:	8b 40 0c             	mov    0xc(%eax),%eax
80104d0c:	83 f8 02             	cmp    $0x2,%eax
80104d0f:	75 0a                	jne    80104d1b <kill+0x45>
                p->state = RUNNABLE;
80104d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d14:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104d1b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d22:	e8 13 02 00 00       	call   80104f3a <release>
            return 0;
80104d27:	b8 00 00 00 00       	mov    $0x0,%eax
80104d2c:	eb 21                	jmp    80104d4f <kill+0x79>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d2e:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104d35:	81 7d f4 74 20 11 80 	cmpl   $0x80112074,-0xc(%ebp)
80104d3c:	72 b3                	jb     80104cf1 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104d3e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d45:	e8 f0 01 00 00       	call   80104f3a <release>
    return -1;
80104d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d4f:	c9                   	leave  
80104d50:	c3                   	ret    

80104d51 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104d51:	55                   	push   %ebp
80104d52:	89 e5                	mov    %esp,%ebp
80104d54:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d57:	c7 45 f0 74 ff 10 80 	movl   $0x8010ff74,-0x10(%ebp)
80104d5e:	e9 d9 00 00 00       	jmp    80104e3c <procdump+0xeb>
        if(p->state == UNUSED)
80104d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d66:	8b 40 0c             	mov    0xc(%eax),%eax
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	75 05                	jne    80104d72 <procdump+0x21>
            continue;
80104d6d:	e9 c3 00 00 00       	jmp    80104e35 <procdump+0xe4>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d75:	8b 40 0c             	mov    0xc(%eax),%eax
80104d78:	83 f8 05             	cmp    $0x5,%eax
80104d7b:	77 23                	ja     80104da0 <procdump+0x4f>
80104d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d80:	8b 40 0c             	mov    0xc(%eax),%eax
80104d83:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	74 12                	je     80104da0 <procdump+0x4f>
            state = states[p->state];
80104d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d91:	8b 40 0c             	mov    0xc(%eax),%eax
80104d94:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104d9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d9e:	eb 07                	jmp    80104da7 <procdump+0x56>
        else
            state = "???";
80104da0:	c7 45 ec 08 89 10 80 	movl   $0x80108908,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80104da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104daa:	8d 50 6c             	lea    0x6c(%eax),%edx
80104dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db0:	8b 40 10             	mov    0x10(%eax),%eax
80104db3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104db7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104dba:	89 54 24 08          	mov    %edx,0x8(%esp)
80104dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dc2:	c7 04 24 0c 89 10 80 	movl   $0x8010890c,(%esp)
80104dc9:	e8 d2 b5 ff ff       	call   801003a0 <cprintf>
        if(p->state == SLEEPING){
80104dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dd1:	8b 40 0c             	mov    0xc(%eax),%eax
80104dd4:	83 f8 02             	cmp    $0x2,%eax
80104dd7:	75 50                	jne    80104e29 <procdump+0xd8>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80104dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ddc:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ddf:	8b 40 0c             	mov    0xc(%eax),%eax
80104de2:	83 c0 08             	add    $0x8,%eax
80104de5:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104de8:	89 54 24 04          	mov    %edx,0x4(%esp)
80104dec:	89 04 24             	mov    %eax,(%esp)
80104def:	e8 95 01 00 00       	call   80104f89 <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
80104df4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104dfb:	eb 1b                	jmp    80104e18 <procdump+0xc7>
                cprintf(" %p", pc[i]);
80104dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e00:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e04:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e08:	c7 04 24 15 89 10 80 	movl   $0x80108915,(%esp)
80104e0f:	e8 8c b5 ff ff       	call   801003a0 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80104e14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e18:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e1c:	7f 0b                	jg     80104e29 <procdump+0xd8>
80104e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e21:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e25:	85 c0                	test   %eax,%eax
80104e27:	75 d4                	jne    80104dfd <procdump+0xac>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104e29:	c7 04 24 19 89 10 80 	movl   $0x80108919,(%esp)
80104e30:	e8 6b b5 ff ff       	call   801003a0 <cprintf>
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e35:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104e3c:	81 7d f0 74 20 11 80 	cmpl   $0x80112074,-0x10(%ebp)
80104e43:	0f 82 1a ff ff ff    	jb     80104d63 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104e49:	c9                   	leave  
80104e4a:	c3                   	ret    

80104e4b <tsleep>:

void tsleep(void){
80104e4b:	55                   	push   %ebp
80104e4c:	89 e5                	mov    %esp,%ebp
80104e4e:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
80104e51:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104e58:	e8 7b 00 00 00       	call   80104ed8 <acquire>
    sleep(proc, &ptable.lock);
80104e5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e63:	c7 44 24 04 40 ff 10 	movl   $0x8010ff40,0x4(%esp)
80104e6a:	80 
80104e6b:	89 04 24             	mov    %eax,(%esp)
80104e6e:	e8 f4 fc ff ff       	call   80104b67 <sleep>
    release(&ptable.lock);
80104e73:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104e7a:	e8 bb 00 00 00       	call   80104f3a <release>

}
80104e7f:	c9                   	leave  
80104e80:	c3                   	ret    

80104e81 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104e81:	55                   	push   %ebp
80104e82:	89 e5                	mov    %esp,%ebp
80104e84:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e87:	9c                   	pushf  
80104e88:	58                   	pop    %eax
80104e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e8f:	c9                   	leave  
80104e90:	c3                   	ret    

80104e91 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104e91:	55                   	push   %ebp
80104e92:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104e94:	fa                   	cli    
}
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    

80104e97 <sti>:

static inline void
sti(void)
{
80104e97:	55                   	push   %ebp
80104e98:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104e9a:	fb                   	sti    
}
80104e9b:	5d                   	pop    %ebp
80104e9c:	c3                   	ret    

80104e9d <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104e9d:	55                   	push   %ebp
80104e9e:	89 e5                	mov    %esp,%ebp
80104ea0:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104ea3:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ea9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eac:	f0 87 02             	lock xchg %eax,(%edx)
80104eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    

80104eb7 <initlock>:
#include "spinlock.h"
#include "semaphore.h"

void
initlock(struct spinlock *lk, char *name)
{
80104eb7:	55                   	push   %ebp
80104eb8:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104eba:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ec0:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104ecc:	8b 45 08             	mov    0x8(%ebp),%eax
80104ecf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ed6:	5d                   	pop    %ebp
80104ed7:	c3                   	ret    

80104ed8 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104ed8:	55                   	push   %ebp
80104ed9:	89 e5                	mov    %esp,%ebp
80104edb:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ede:	e8 49 01 00 00       	call   8010502c <pushcli>
  if(holding(lk))
80104ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee6:	89 04 24             	mov    %eax,(%esp)
80104ee9:	e8 14 01 00 00       	call   80105002 <holding>
80104eee:	85 c0                	test   %eax,%eax
80104ef0:	74 0c                	je     80104efe <acquire+0x26>
    panic("acquire");
80104ef2:	c7 04 24 45 89 10 80 	movl   $0x80108945,(%esp)
80104ef9:	e8 3c b6 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104efe:	90                   	nop
80104eff:	8b 45 08             	mov    0x8(%ebp),%eax
80104f02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f09:	00 
80104f0a:	89 04 24             	mov    %eax,(%esp)
80104f0d:	e8 8b ff ff ff       	call   80104e9d <xchg>
80104f12:	85 c0                	test   %eax,%eax
80104f14:	75 e9                	jne    80104eff <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f16:	8b 45 08             	mov    0x8(%ebp),%eax
80104f19:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f20:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104f23:	8b 45 08             	mov    0x8(%ebp),%eax
80104f26:	83 c0 0c             	add    $0xc,%eax
80104f29:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f2d:	8d 45 08             	lea    0x8(%ebp),%eax
80104f30:	89 04 24             	mov    %eax,(%esp)
80104f33:	e8 51 00 00 00       	call   80104f89 <getcallerpcs>
}
80104f38:	c9                   	leave  
80104f39:	c3                   	ret    

80104f3a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104f3a:	55                   	push   %ebp
80104f3b:	89 e5                	mov    %esp,%ebp
80104f3d:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104f40:	8b 45 08             	mov    0x8(%ebp),%eax
80104f43:	89 04 24             	mov    %eax,(%esp)
80104f46:	e8 b7 00 00 00       	call   80105002 <holding>
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	75 0c                	jne    80104f5b <release+0x21>
    panic("release");
80104f4f:	c7 04 24 4d 89 10 80 	movl   $0x8010894d,(%esp)
80104f56:	e8 df b5 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104f65:	8b 45 08             	mov    0x8(%ebp),%eax
80104f68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104f79:	00 
80104f7a:	89 04 24             	mov    %eax,(%esp)
80104f7d:	e8 1b ff ff ff       	call   80104e9d <xchg>

  popcli();
80104f82:	e8 e9 00 00 00       	call   80105070 <popcli>
}
80104f87:	c9                   	leave  
80104f88:	c3                   	ret    

80104f89 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f89:	55                   	push   %ebp
80104f8a:	89 e5                	mov    %esp,%ebp
80104f8c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f92:	83 e8 08             	sub    $0x8,%eax
80104f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104f98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104f9f:	eb 38                	jmp    80104fd9 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104fa5:	74 38                	je     80104fdf <getcallerpcs+0x56>
80104fa7:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104fae:	76 2f                	jbe    80104fdf <getcallerpcs+0x56>
80104fb0:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104fb4:	74 29                	je     80104fdf <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fc3:	01 c2                	add    %eax,%edx
80104fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fc8:	8b 40 04             	mov    0x4(%eax),%eax
80104fcb:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd0:	8b 00                	mov    (%eax),%eax
80104fd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104fd5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fd9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104fdd:	7e c2                	jle    80104fa1 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104fdf:	eb 19                	jmp    80104ffa <getcallerpcs+0x71>
    pcs[i] = 0;
80104fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	01 d0                	add    %edx,%eax
80104ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ff6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104ffa:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ffe:	7e e1                	jle    80104fe1 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105000:	c9                   	leave  
80105001:	c3                   	ret    

80105002 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105002:	55                   	push   %ebp
80105003:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	8b 00                	mov    (%eax),%eax
8010500a:	85 c0                	test   %eax,%eax
8010500c:	74 17                	je     80105025 <holding+0x23>
8010500e:	8b 45 08             	mov    0x8(%ebp),%eax
80105011:	8b 50 08             	mov    0x8(%eax),%edx
80105014:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010501a:	39 c2                	cmp    %eax,%edx
8010501c:	75 07                	jne    80105025 <holding+0x23>
8010501e:	b8 01 00 00 00       	mov    $0x1,%eax
80105023:	eb 05                	jmp    8010502a <holding+0x28>
80105025:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010502a:	5d                   	pop    %ebp
8010502b:	c3                   	ret    

8010502c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010502c:	55                   	push   %ebp
8010502d:	89 e5                	mov    %esp,%ebp
8010502f:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105032:	e8 4a fe ff ff       	call   80104e81 <readeflags>
80105037:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010503a:	e8 52 fe ff ff       	call   80104e91 <cli>
  if(cpu->ncli++ == 0)
8010503f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105046:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010504c:	8d 48 01             	lea    0x1(%eax),%ecx
8010504f:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105055:	85 c0                	test   %eax,%eax
80105057:	75 15                	jne    8010506e <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105059:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010505f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105062:	81 e2 00 02 00 00    	and    $0x200,%edx
80105068:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010506e:	c9                   	leave  
8010506f:	c3                   	ret    

80105070 <popcli>:

void
popcli(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105076:	e8 06 fe ff ff       	call   80104e81 <readeflags>
8010507b:	25 00 02 00 00       	and    $0x200,%eax
80105080:	85 c0                	test   %eax,%eax
80105082:	74 0c                	je     80105090 <popcli+0x20>
    panic("popcli - interruptible");
80105084:	c7 04 24 55 89 10 80 	movl   $0x80108955,(%esp)
8010508b:	e8 aa b4 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105090:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105096:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010509c:	83 ea 01             	sub    $0x1,%edx
8010509f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050a5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801050ab:	85 c0                	test   %eax,%eax
801050ad:	79 0c                	jns    801050bb <popcli+0x4b>
    panic("popcli");
801050af:	c7 04 24 6c 89 10 80 	movl   $0x8010896c,(%esp)
801050b6:	e8 7f b4 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801050bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050c1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801050c7:	85 c0                	test   %eax,%eax
801050c9:	75 15                	jne    801050e0 <popcli+0x70>
801050cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050d1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801050d7:	85 c0                	test   %eax,%eax
801050d9:	74 05                	je     801050e0 <popcli+0x70>
    sti();
801050db:	e8 b7 fd ff ff       	call   80104e97 <sti>
}
801050e0:	c9                   	leave  
801050e1:	c3                   	ret    

801050e2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801050e2:	55                   	push   %ebp
801050e3:	89 e5                	mov    %esp,%ebp
801050e5:	57                   	push   %edi
801050e6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801050e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050ea:	8b 55 10             	mov    0x10(%ebp),%edx
801050ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f0:	89 cb                	mov    %ecx,%ebx
801050f2:	89 df                	mov    %ebx,%edi
801050f4:	89 d1                	mov    %edx,%ecx
801050f6:	fc                   	cld    
801050f7:	f3 aa                	rep stos %al,%es:(%edi)
801050f9:	89 ca                	mov    %ecx,%edx
801050fb:	89 fb                	mov    %edi,%ebx
801050fd:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105100:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105103:	5b                   	pop    %ebx
80105104:	5f                   	pop    %edi
80105105:	5d                   	pop    %ebp
80105106:	c3                   	ret    

80105107 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105107:	55                   	push   %ebp
80105108:	89 e5                	mov    %esp,%ebp
8010510a:	57                   	push   %edi
8010510b:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010510c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010510f:	8b 55 10             	mov    0x10(%ebp),%edx
80105112:	8b 45 0c             	mov    0xc(%ebp),%eax
80105115:	89 cb                	mov    %ecx,%ebx
80105117:	89 df                	mov    %ebx,%edi
80105119:	89 d1                	mov    %edx,%ecx
8010511b:	fc                   	cld    
8010511c:	f3 ab                	rep stos %eax,%es:(%edi)
8010511e:	89 ca                	mov    %ecx,%edx
80105120:	89 fb                	mov    %edi,%ebx
80105122:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105125:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105128:	5b                   	pop    %ebx
80105129:	5f                   	pop    %edi
8010512a:	5d                   	pop    %ebp
8010512b:	c3                   	ret    

8010512c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010512c:	55                   	push   %ebp
8010512d:	89 e5                	mov    %esp,%ebp
8010512f:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105132:	8b 45 08             	mov    0x8(%ebp),%eax
80105135:	83 e0 03             	and    $0x3,%eax
80105138:	85 c0                	test   %eax,%eax
8010513a:	75 49                	jne    80105185 <memset+0x59>
8010513c:	8b 45 10             	mov    0x10(%ebp),%eax
8010513f:	83 e0 03             	and    $0x3,%eax
80105142:	85 c0                	test   %eax,%eax
80105144:	75 3f                	jne    80105185 <memset+0x59>
    c &= 0xFF;
80105146:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010514d:	8b 45 10             	mov    0x10(%ebp),%eax
80105150:	c1 e8 02             	shr    $0x2,%eax
80105153:	89 c2                	mov    %eax,%edx
80105155:	8b 45 0c             	mov    0xc(%ebp),%eax
80105158:	c1 e0 18             	shl    $0x18,%eax
8010515b:	89 c1                	mov    %eax,%ecx
8010515d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105160:	c1 e0 10             	shl    $0x10,%eax
80105163:	09 c1                	or     %eax,%ecx
80105165:	8b 45 0c             	mov    0xc(%ebp),%eax
80105168:	c1 e0 08             	shl    $0x8,%eax
8010516b:	09 c8                	or     %ecx,%eax
8010516d:	0b 45 0c             	or     0xc(%ebp),%eax
80105170:	89 54 24 08          	mov    %edx,0x8(%esp)
80105174:	89 44 24 04          	mov    %eax,0x4(%esp)
80105178:	8b 45 08             	mov    0x8(%ebp),%eax
8010517b:	89 04 24             	mov    %eax,(%esp)
8010517e:	e8 84 ff ff ff       	call   80105107 <stosl>
80105183:	eb 19                	jmp    8010519e <memset+0x72>
  } else
    stosb(dst, c, n);
80105185:	8b 45 10             	mov    0x10(%ebp),%eax
80105188:	89 44 24 08          	mov    %eax,0x8(%esp)
8010518c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105193:	8b 45 08             	mov    0x8(%ebp),%eax
80105196:	89 04 24             	mov    %eax,(%esp)
80105199:	e8 44 ff ff ff       	call   801050e2 <stosb>
  return dst;
8010519e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051a1:	c9                   	leave  
801051a2:	c3                   	ret    

801051a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051a3:	55                   	push   %ebp
801051a4:	89 e5                	mov    %esp,%ebp
801051a6:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801051a9:	8b 45 08             	mov    0x8(%ebp),%eax
801051ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801051af:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801051b5:	eb 30                	jmp    801051e7 <memcmp+0x44>
    if(*s1 != *s2)
801051b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ba:	0f b6 10             	movzbl (%eax),%edx
801051bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051c0:	0f b6 00             	movzbl (%eax),%eax
801051c3:	38 c2                	cmp    %al,%dl
801051c5:	74 18                	je     801051df <memcmp+0x3c>
      return *s1 - *s2;
801051c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ca:	0f b6 00             	movzbl (%eax),%eax
801051cd:	0f b6 d0             	movzbl %al,%edx
801051d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051d3:	0f b6 00             	movzbl (%eax),%eax
801051d6:	0f b6 c0             	movzbl %al,%eax
801051d9:	29 c2                	sub    %eax,%edx
801051db:	89 d0                	mov    %edx,%eax
801051dd:	eb 1a                	jmp    801051f9 <memcmp+0x56>
    s1++, s2++;
801051df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051e3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051e7:	8b 45 10             	mov    0x10(%ebp),%eax
801051ea:	8d 50 ff             	lea    -0x1(%eax),%edx
801051ed:	89 55 10             	mov    %edx,0x10(%ebp)
801051f0:	85 c0                	test   %eax,%eax
801051f2:	75 c3                	jne    801051b7 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801051f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051f9:	c9                   	leave  
801051fa:	c3                   	ret    

801051fb <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051fb:	55                   	push   %ebp
801051fc:	89 e5                	mov    %esp,%ebp
801051fe:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105201:	8b 45 0c             	mov    0xc(%ebp),%eax
80105204:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105207:	8b 45 08             	mov    0x8(%ebp),%eax
8010520a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010520d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105210:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105213:	73 3d                	jae    80105252 <memmove+0x57>
80105215:	8b 45 10             	mov    0x10(%ebp),%eax
80105218:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010521b:	01 d0                	add    %edx,%eax
8010521d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105220:	76 30                	jbe    80105252 <memmove+0x57>
    s += n;
80105222:	8b 45 10             	mov    0x10(%ebp),%eax
80105225:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105228:	8b 45 10             	mov    0x10(%ebp),%eax
8010522b:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010522e:	eb 13                	jmp    80105243 <memmove+0x48>
      *--d = *--s;
80105230:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105234:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105238:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010523b:	0f b6 10             	movzbl (%eax),%edx
8010523e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105241:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105243:	8b 45 10             	mov    0x10(%ebp),%eax
80105246:	8d 50 ff             	lea    -0x1(%eax),%edx
80105249:	89 55 10             	mov    %edx,0x10(%ebp)
8010524c:	85 c0                	test   %eax,%eax
8010524e:	75 e0                	jne    80105230 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105250:	eb 26                	jmp    80105278 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105252:	eb 17                	jmp    8010526b <memmove+0x70>
      *d++ = *s++;
80105254:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105257:	8d 50 01             	lea    0x1(%eax),%edx
8010525a:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010525d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105260:	8d 4a 01             	lea    0x1(%edx),%ecx
80105263:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105266:	0f b6 12             	movzbl (%edx),%edx
80105269:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010526b:	8b 45 10             	mov    0x10(%ebp),%eax
8010526e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105271:	89 55 10             	mov    %edx,0x10(%ebp)
80105274:	85 c0                	test   %eax,%eax
80105276:	75 dc                	jne    80105254 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105278:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010527b:	c9                   	leave  
8010527c:	c3                   	ret    

8010527d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010527d:	55                   	push   %ebp
8010527e:	89 e5                	mov    %esp,%ebp
80105280:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105283:	8b 45 10             	mov    0x10(%ebp),%eax
80105286:	89 44 24 08          	mov    %eax,0x8(%esp)
8010528a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105291:	8b 45 08             	mov    0x8(%ebp),%eax
80105294:	89 04 24             	mov    %eax,(%esp)
80105297:	e8 5f ff ff ff       	call   801051fb <memmove>
}
8010529c:	c9                   	leave  
8010529d:	c3                   	ret    

8010529e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010529e:	55                   	push   %ebp
8010529f:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801052a1:	eb 0c                	jmp    801052af <strncmp+0x11>
    n--, p++, q++;
801052a3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801052ab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801052af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052b3:	74 1a                	je     801052cf <strncmp+0x31>
801052b5:	8b 45 08             	mov    0x8(%ebp),%eax
801052b8:	0f b6 00             	movzbl (%eax),%eax
801052bb:	84 c0                	test   %al,%al
801052bd:	74 10                	je     801052cf <strncmp+0x31>
801052bf:	8b 45 08             	mov    0x8(%ebp),%eax
801052c2:	0f b6 10             	movzbl (%eax),%edx
801052c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052c8:	0f b6 00             	movzbl (%eax),%eax
801052cb:	38 c2                	cmp    %al,%dl
801052cd:	74 d4                	je     801052a3 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801052cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052d3:	75 07                	jne    801052dc <strncmp+0x3e>
    return 0;
801052d5:	b8 00 00 00 00       	mov    $0x0,%eax
801052da:	eb 16                	jmp    801052f2 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801052dc:	8b 45 08             	mov    0x8(%ebp),%eax
801052df:	0f b6 00             	movzbl (%eax),%eax
801052e2:	0f b6 d0             	movzbl %al,%edx
801052e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e8:	0f b6 00             	movzbl (%eax),%eax
801052eb:	0f b6 c0             	movzbl %al,%eax
801052ee:	29 c2                	sub    %eax,%edx
801052f0:	89 d0                	mov    %edx,%eax
}
801052f2:	5d                   	pop    %ebp
801052f3:	c3                   	ret    

801052f4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801052fa:	8b 45 08             	mov    0x8(%ebp),%eax
801052fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105300:	90                   	nop
80105301:	8b 45 10             	mov    0x10(%ebp),%eax
80105304:	8d 50 ff             	lea    -0x1(%eax),%edx
80105307:	89 55 10             	mov    %edx,0x10(%ebp)
8010530a:	85 c0                	test   %eax,%eax
8010530c:	7e 1e                	jle    8010532c <strncpy+0x38>
8010530e:	8b 45 08             	mov    0x8(%ebp),%eax
80105311:	8d 50 01             	lea    0x1(%eax),%edx
80105314:	89 55 08             	mov    %edx,0x8(%ebp)
80105317:	8b 55 0c             	mov    0xc(%ebp),%edx
8010531a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010531d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105320:	0f b6 12             	movzbl (%edx),%edx
80105323:	88 10                	mov    %dl,(%eax)
80105325:	0f b6 00             	movzbl (%eax),%eax
80105328:	84 c0                	test   %al,%al
8010532a:	75 d5                	jne    80105301 <strncpy+0xd>
    ;
  while(n-- > 0)
8010532c:	eb 0c                	jmp    8010533a <strncpy+0x46>
    *s++ = 0;
8010532e:	8b 45 08             	mov    0x8(%ebp),%eax
80105331:	8d 50 01             	lea    0x1(%eax),%edx
80105334:	89 55 08             	mov    %edx,0x8(%ebp)
80105337:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010533a:	8b 45 10             	mov    0x10(%ebp),%eax
8010533d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105340:	89 55 10             	mov    %edx,0x10(%ebp)
80105343:	85 c0                	test   %eax,%eax
80105345:	7f e7                	jg     8010532e <strncpy+0x3a>
    *s++ = 0;
  return os;
80105347:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    

8010534c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010534c:	55                   	push   %ebp
8010534d:	89 e5                	mov    %esp,%ebp
8010534f:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105352:	8b 45 08             	mov    0x8(%ebp),%eax
80105355:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010535c:	7f 05                	jg     80105363 <safestrcpy+0x17>
    return os;
8010535e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105361:	eb 31                	jmp    80105394 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105363:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105367:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010536b:	7e 1e                	jle    8010538b <safestrcpy+0x3f>
8010536d:	8b 45 08             	mov    0x8(%ebp),%eax
80105370:	8d 50 01             	lea    0x1(%eax),%edx
80105373:	89 55 08             	mov    %edx,0x8(%ebp)
80105376:	8b 55 0c             	mov    0xc(%ebp),%edx
80105379:	8d 4a 01             	lea    0x1(%edx),%ecx
8010537c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010537f:	0f b6 12             	movzbl (%edx),%edx
80105382:	88 10                	mov    %dl,(%eax)
80105384:	0f b6 00             	movzbl (%eax),%eax
80105387:	84 c0                	test   %al,%al
80105389:	75 d8                	jne    80105363 <safestrcpy+0x17>
    ;
  *s = 0;
8010538b:	8b 45 08             	mov    0x8(%ebp),%eax
8010538e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105391:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105394:	c9                   	leave  
80105395:	c3                   	ret    

80105396 <strlen>:

int
strlen(const char *s)
{
80105396:	55                   	push   %ebp
80105397:	89 e5                	mov    %esp,%ebp
80105399:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010539c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801053a3:	eb 04                	jmp    801053a9 <strlen+0x13>
801053a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053ac:	8b 45 08             	mov    0x8(%ebp),%eax
801053af:	01 d0                	add    %edx,%eax
801053b1:	0f b6 00             	movzbl (%eax),%eax
801053b4:	84 c0                	test   %al,%al
801053b6:	75 ed                	jne    801053a5 <strlen+0xf>
    ;
  return n;
801053b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053bb:	c9                   	leave  
801053bc:	c3                   	ret    

801053bd <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801053bd:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801053c1:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801053c5:	55                   	push   %ebp
  pushl %ebx
801053c6:	53                   	push   %ebx
  pushl %esi
801053c7:	56                   	push   %esi
  pushl %edi
801053c8:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801053c9:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801053cb:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801053cd:	5f                   	pop    %edi
  popl %esi
801053ce:	5e                   	pop    %esi
  popl %ebx
801053cf:	5b                   	pop    %ebx
  popl %ebp
801053d0:	5d                   	pop    %ebp
  ret
801053d1:	c3                   	ret    

801053d2 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801053d2:	55                   	push   %ebp
801053d3:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801053d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053db:	8b 00                	mov    (%eax),%eax
801053dd:	3b 45 08             	cmp    0x8(%ebp),%eax
801053e0:	76 12                	jbe    801053f4 <fetchint+0x22>
801053e2:	8b 45 08             	mov    0x8(%ebp),%eax
801053e5:	8d 50 04             	lea    0x4(%eax),%edx
801053e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ee:	8b 00                	mov    (%eax),%eax
801053f0:	39 c2                	cmp    %eax,%edx
801053f2:	76 07                	jbe    801053fb <fetchint+0x29>
    return -1;
801053f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f9:	eb 0f                	jmp    8010540a <fetchint+0x38>
  *ip = *(int*)(addr);
801053fb:	8b 45 08             	mov    0x8(%ebp),%eax
801053fe:	8b 10                	mov    (%eax),%edx
80105400:	8b 45 0c             	mov    0xc(%ebp),%eax
80105403:	89 10                	mov    %edx,(%eax)
  return 0;
80105405:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010540a:	5d                   	pop    %ebp
8010540b:	c3                   	ret    

8010540c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010540c:	55                   	push   %ebp
8010540d:	89 e5                	mov    %esp,%ebp
8010540f:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105412:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105418:	8b 00                	mov    (%eax),%eax
8010541a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010541d:	77 07                	ja     80105426 <fetchstr+0x1a>
    return -1;
8010541f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105424:	eb 46                	jmp    8010546c <fetchstr+0x60>
  *pp = (char*)addr;
80105426:	8b 55 08             	mov    0x8(%ebp),%edx
80105429:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542c:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010542e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105434:	8b 00                	mov    (%eax),%eax
80105436:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105439:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543c:	8b 00                	mov    (%eax),%eax
8010543e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105441:	eb 1c                	jmp    8010545f <fetchstr+0x53>
    if(*s == 0)
80105443:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105446:	0f b6 00             	movzbl (%eax),%eax
80105449:	84 c0                	test   %al,%al
8010544b:	75 0e                	jne    8010545b <fetchstr+0x4f>
      return s - *pp;
8010544d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105450:	8b 45 0c             	mov    0xc(%ebp),%eax
80105453:	8b 00                	mov    (%eax),%eax
80105455:	29 c2                	sub    %eax,%edx
80105457:	89 d0                	mov    %edx,%eax
80105459:	eb 11                	jmp    8010546c <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010545b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010545f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105462:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105465:	72 dc                	jb     80105443 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546c:	c9                   	leave  
8010546d:	c3                   	ret    

8010546e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010546e:	55                   	push   %ebp
8010546f:	89 e5                	mov    %esp,%ebp
80105471:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105474:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547a:	8b 40 18             	mov    0x18(%eax),%eax
8010547d:	8b 50 44             	mov    0x44(%eax),%edx
80105480:	8b 45 08             	mov    0x8(%ebp),%eax
80105483:	c1 e0 02             	shl    $0x2,%eax
80105486:	01 d0                	add    %edx,%eax
80105488:	8d 50 04             	lea    0x4(%eax),%edx
8010548b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105492:	89 14 24             	mov    %edx,(%esp)
80105495:	e8 38 ff ff ff       	call   801053d2 <fetchint>
}
8010549a:	c9                   	leave  
8010549b:	c3                   	ret    

8010549c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010549c:	55                   	push   %ebp
8010549d:	89 e5                	mov    %esp,%ebp
8010549f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801054a2:	8d 45 fc             	lea    -0x4(%ebp),%eax
801054a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a9:	8b 45 08             	mov    0x8(%ebp),%eax
801054ac:	89 04 24             	mov    %eax,(%esp)
801054af:	e8 ba ff ff ff       	call   8010546e <argint>
801054b4:	85 c0                	test   %eax,%eax
801054b6:	79 07                	jns    801054bf <argptr+0x23>
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb 3d                	jmp    801054fc <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801054bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054c2:	89 c2                	mov    %eax,%edx
801054c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ca:	8b 00                	mov    (%eax),%eax
801054cc:	39 c2                	cmp    %eax,%edx
801054ce:	73 16                	jae    801054e6 <argptr+0x4a>
801054d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d3:	89 c2                	mov    %eax,%edx
801054d5:	8b 45 10             	mov    0x10(%ebp),%eax
801054d8:	01 c2                	add    %eax,%edx
801054da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e0:	8b 00                	mov    (%eax),%eax
801054e2:	39 c2                	cmp    %eax,%edx
801054e4:	76 07                	jbe    801054ed <argptr+0x51>
    return -1;
801054e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054eb:	eb 0f                	jmp    801054fc <argptr+0x60>
  *pp = (char*)i;
801054ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054f0:	89 c2                	mov    %eax,%edx
801054f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f5:	89 10                	mov    %edx,(%eax)
  return 0;
801054f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    

801054fe <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054fe:	55                   	push   %ebp
801054ff:	89 e5                	mov    %esp,%ebp
80105501:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105504:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105507:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550b:	8b 45 08             	mov    0x8(%ebp),%eax
8010550e:	89 04 24             	mov    %eax,(%esp)
80105511:	e8 58 ff ff ff       	call   8010546e <argint>
80105516:	85 c0                	test   %eax,%eax
80105518:	79 07                	jns    80105521 <argstr+0x23>
    return -1;
8010551a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551f:	eb 12                	jmp    80105533 <argstr+0x35>
  return fetchstr(addr, pp);
80105521:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105524:	8b 55 0c             	mov    0xc(%ebp),%edx
80105527:	89 54 24 04          	mov    %edx,0x4(%esp)
8010552b:	89 04 24             	mov    %eax,(%esp)
8010552e:	e8 d9 fe ff ff       	call   8010540c <fetchstr>
}
80105533:	c9                   	leave  
80105534:	c3                   	ret    

80105535 <syscall>:
[SYS_thread_yield] sys_thread_yield,
};

void
syscall(void)
{
80105535:	55                   	push   %ebp
80105536:	89 e5                	mov    %esp,%ebp
80105538:	53                   	push   %ebx
80105539:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010553c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105542:	8b 40 18             	mov    0x18(%eax),%eax
80105545:	8b 40 1c             	mov    0x1c(%eax),%eax
80105548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010554b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010554f:	7e 30                	jle    80105581 <syscall+0x4c>
80105551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105554:	83 f8 1a             	cmp    $0x1a,%eax
80105557:	77 28                	ja     80105581 <syscall+0x4c>
80105559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555c:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105563:	85 c0                	test   %eax,%eax
80105565:	74 1a                	je     80105581 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105567:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010556d:	8b 58 18             	mov    0x18(%eax),%ebx
80105570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105573:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010557a:	ff d0                	call   *%eax
8010557c:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010557f:	eb 3d                	jmp    801055be <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105581:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105587:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010558a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105590:	8b 40 10             	mov    0x10(%eax),%eax
80105593:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105596:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010559a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010559e:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a2:	c7 04 24 73 89 10 80 	movl   $0x80108973,(%esp)
801055a9:	e8 f2 ad ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801055ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055b4:	8b 40 18             	mov    0x18(%eax),%eax
801055b7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801055be:	83 c4 24             	add    $0x24,%esp
801055c1:	5b                   	pop    %ebx
801055c2:	5d                   	pop    %ebp
801055c3:	c3                   	ret    

801055c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801055ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801055d1:	8b 45 08             	mov    0x8(%ebp),%eax
801055d4:	89 04 24             	mov    %eax,(%esp)
801055d7:	e8 92 fe ff ff       	call   8010546e <argint>
801055dc:	85 c0                	test   %eax,%eax
801055de:	79 07                	jns    801055e7 <argfd+0x23>
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e5:	eb 50                	jmp    80105637 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801055e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ea:	85 c0                	test   %eax,%eax
801055ec:	78 21                	js     8010560f <argfd+0x4b>
801055ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f1:	83 f8 0f             	cmp    $0xf,%eax
801055f4:	7f 19                	jg     8010560f <argfd+0x4b>
801055f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055ff:	83 c2 08             	add    $0x8,%edx
80105602:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010560d:	75 07                	jne    80105616 <argfd+0x52>
    return -1;
8010560f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105614:	eb 21                	jmp    80105637 <argfd+0x73>
  if(pfd)
80105616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010561a:	74 08                	je     80105624 <argfd+0x60>
    *pfd = fd;
8010561c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010561f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105622:	89 10                	mov    %edx,(%eax)
  if(pf)
80105624:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105628:	74 08                	je     80105632 <argfd+0x6e>
    *pf = f;
8010562a:	8b 45 10             	mov    0x10(%ebp),%eax
8010562d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105630:	89 10                	mov    %edx,(%eax)
  return 0;
80105632:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105637:	c9                   	leave  
80105638:	c3                   	ret    

80105639 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105639:	55                   	push   %ebp
8010563a:	89 e5                	mov    %esp,%ebp
8010563c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010563f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105646:	eb 30                	jmp    80105678 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105648:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010564e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105651:	83 c2 08             	add    $0x8,%edx
80105654:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105658:	85 c0                	test   %eax,%eax
8010565a:	75 18                	jne    80105674 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010565c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105662:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105665:	8d 4a 08             	lea    0x8(%edx),%ecx
80105668:	8b 55 08             	mov    0x8(%ebp),%edx
8010566b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010566f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105672:	eb 0f                	jmp    80105683 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105674:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105678:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010567c:	7e ca                	jle    80105648 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010567e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105683:	c9                   	leave  
80105684:	c3                   	ret    

80105685 <sys_dup>:

int
sys_dup(void)
{
80105685:	55                   	push   %ebp
80105686:	89 e5                	mov    %esp,%ebp
80105688:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010568b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010568e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105692:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105699:	00 
8010569a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056a1:	e8 1e ff ff ff       	call   801055c4 <argfd>
801056a6:	85 c0                	test   %eax,%eax
801056a8:	79 07                	jns    801056b1 <sys_dup+0x2c>
    return -1;
801056aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056af:	eb 29                	jmp    801056da <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801056b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b4:	89 04 24             	mov    %eax,(%esp)
801056b7:	e8 7d ff ff ff       	call   80105639 <fdalloc>
801056bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056c3:	79 07                	jns    801056cc <sys_dup+0x47>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ca:	eb 0e                	jmp    801056da <sys_dup+0x55>
  filedup(f);
801056cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056cf:	89 04 24             	mov    %eax,(%esp)
801056d2:	e8 a7 b8 ff ff       	call   80100f7e <filedup>
  return fd;
801056d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    

801056dc <sys_read>:

int
sys_read(void)
{
801056dc:	55                   	push   %ebp
801056dd:	89 e5                	mov    %esp,%ebp
801056df:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801056e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056f0:	00 
801056f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056f8:	e8 c7 fe ff ff       	call   801055c4 <argfd>
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 35                	js     80105736 <sys_read+0x5a>
80105701:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105704:	89 44 24 04          	mov    %eax,0x4(%esp)
80105708:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010570f:	e8 5a fd ff ff       	call   8010546e <argint>
80105714:	85 c0                	test   %eax,%eax
80105716:	78 1e                	js     80105736 <sys_read+0x5a>
80105718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010571b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010571f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105722:	89 44 24 04          	mov    %eax,0x4(%esp)
80105726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010572d:	e8 6a fd ff ff       	call   8010549c <argptr>
80105732:	85 c0                	test   %eax,%eax
80105734:	79 07                	jns    8010573d <sys_read+0x61>
    return -1;
80105736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573b:	eb 19                	jmp    80105756 <sys_read+0x7a>
  return fileread(f, p, n);
8010573d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105740:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105746:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010574a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010574e:	89 04 24             	mov    %eax,(%esp)
80105751:	e8 95 b9 ff ff       	call   801010eb <fileread>
}
80105756:	c9                   	leave  
80105757:	c3                   	ret    

80105758 <sys_write>:

int
sys_write(void)
{
80105758:	55                   	push   %ebp
80105759:	89 e5                	mov    %esp,%ebp
8010575b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010575e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105761:	89 44 24 08          	mov    %eax,0x8(%esp)
80105765:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010576c:	00 
8010576d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105774:	e8 4b fe ff ff       	call   801055c4 <argfd>
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 35                	js     801057b2 <sys_write+0x5a>
8010577d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105780:	89 44 24 04          	mov    %eax,0x4(%esp)
80105784:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010578b:	e8 de fc ff ff       	call   8010546e <argint>
80105790:	85 c0                	test   %eax,%eax
80105792:	78 1e                	js     801057b2 <sys_write+0x5a>
80105794:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105797:	89 44 24 08          	mov    %eax,0x8(%esp)
8010579b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579e:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057a9:	e8 ee fc ff ff       	call   8010549c <argptr>
801057ae:	85 c0                	test   %eax,%eax
801057b0:	79 07                	jns    801057b9 <sys_write+0x61>
    return -1;
801057b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b7:	eb 19                	jmp    801057d2 <sys_write+0x7a>
  return filewrite(f, p, n);
801057b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801057c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801057ca:	89 04 24             	mov    %eax,(%esp)
801057cd:	e8 d5 b9 ff ff       	call   801011a7 <filewrite>
}
801057d2:	c9                   	leave  
801057d3:	c3                   	ret    

801057d4 <sys_close>:

int
sys_close(void)
{
801057d4:	55                   	push   %ebp
801057d5:	89 e5                	mov    %esp,%ebp
801057d7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801057da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057dd:	89 44 24 08          	mov    %eax,0x8(%esp)
801057e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ef:	e8 d0 fd ff ff       	call   801055c4 <argfd>
801057f4:	85 c0                	test   %eax,%eax
801057f6:	79 07                	jns    801057ff <sys_close+0x2b>
    return -1;
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb 24                	jmp    80105823 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801057ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105805:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105808:	83 c2 08             	add    $0x8,%edx
8010580b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105812:	00 
  fileclose(f);
80105813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105816:	89 04 24             	mov    %eax,(%esp)
80105819:	e8 a8 b7 ff ff       	call   80100fc6 <fileclose>
  return 0;
8010581e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105823:	c9                   	leave  
80105824:	c3                   	ret    

80105825 <sys_fstat>:

int
sys_fstat(void)
{
80105825:	55                   	push   %ebp
80105826:	89 e5                	mov    %esp,%ebp
80105828:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010582b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105839:	00 
8010583a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105841:	e8 7e fd ff ff       	call   801055c4 <argfd>
80105846:	85 c0                	test   %eax,%eax
80105848:	78 1f                	js     80105869 <sys_fstat+0x44>
8010584a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105851:	00 
80105852:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105855:	89 44 24 04          	mov    %eax,0x4(%esp)
80105859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105860:	e8 37 fc ff ff       	call   8010549c <argptr>
80105865:	85 c0                	test   %eax,%eax
80105867:	79 07                	jns    80105870 <sys_fstat+0x4b>
    return -1;
80105869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586e:	eb 12                	jmp    80105882 <sys_fstat+0x5d>
  return filestat(f, st);
80105870:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	89 54 24 04          	mov    %edx,0x4(%esp)
8010587a:	89 04 24             	mov    %eax,(%esp)
8010587d:	e8 1a b8 ff ff       	call   8010109c <filestat>
}
80105882:	c9                   	leave  
80105883:	c3                   	ret    

80105884 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010588a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010588d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105898:	e8 61 fc ff ff       	call   801054fe <argstr>
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 17                	js     801058b8 <sys_link+0x34>
801058a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058af:	e8 4a fc ff ff       	call   801054fe <argstr>
801058b4:	85 c0                	test   %eax,%eax
801058b6:	79 0a                	jns    801058c2 <sys_link+0x3e>
    return -1;
801058b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bd:	e9 3d 01 00 00       	jmp    801059ff <sys_link+0x17b>
  if((ip = namei(old)) == 0)
801058c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801058c5:	89 04 24             	mov    %eax,(%esp)
801058c8:	e8 31 cb ff ff       	call   801023fe <namei>
801058cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d4:	75 0a                	jne    801058e0 <sys_link+0x5c>
    return -1;
801058d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058db:	e9 1f 01 00 00       	jmp    801059ff <sys_link+0x17b>

  begin_trans();
801058e0:	e8 f8 d8 ff ff       	call   801031dd <begin_trans>

  ilock(ip);
801058e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e8:	89 04 24             	mov    %eax,(%esp)
801058eb:	e8 63 bf ff ff       	call   80101853 <ilock>
  if(ip->type == T_DIR){
801058f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058f7:	66 83 f8 01          	cmp    $0x1,%ax
801058fb:	75 1a                	jne    80105917 <sys_link+0x93>
    iunlockput(ip);
801058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105900:	89 04 24             	mov    %eax,(%esp)
80105903:	e8 cf c1 ff ff       	call   80101ad7 <iunlockput>
    commit_trans();
80105908:	e8 19 d9 ff ff       	call   80103226 <commit_trans>
    return -1;
8010590d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105912:	e9 e8 00 00 00       	jmp    801059ff <sys_link+0x17b>
  }

  ip->nlink++;
80105917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010591e:	8d 50 01             	lea    0x1(%eax),%edx
80105921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105924:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592b:	89 04 24             	mov    %eax,(%esp)
8010592e:	e8 64 bd ff ff       	call   80101697 <iupdate>
  iunlock(ip);
80105933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105936:	89 04 24             	mov    %eax,(%esp)
80105939:	e8 63 c0 ff ff       	call   801019a1 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010593e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105941:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105944:	89 54 24 04          	mov    %edx,0x4(%esp)
80105948:	89 04 24             	mov    %eax,(%esp)
8010594b:	e8 d0 ca ff ff       	call   80102420 <nameiparent>
80105950:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105957:	75 02                	jne    8010595b <sys_link+0xd7>
    goto bad;
80105959:	eb 68                	jmp    801059c3 <sys_link+0x13f>
  ilock(dp);
8010595b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595e:	89 04 24             	mov    %eax,(%esp)
80105961:	e8 ed be ff ff       	call   80101853 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105966:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105969:	8b 10                	mov    (%eax),%edx
8010596b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596e:	8b 00                	mov    (%eax),%eax
80105970:	39 c2                	cmp    %eax,%edx
80105972:	75 20                	jne    80105994 <sys_link+0x110>
80105974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105977:	8b 40 04             	mov    0x4(%eax),%eax
8010597a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010597e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105981:	89 44 24 04          	mov    %eax,0x4(%esp)
80105985:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105988:	89 04 24             	mov    %eax,(%esp)
8010598b:	e8 ae c7 ff ff       	call   8010213e <dirlink>
80105990:	85 c0                	test   %eax,%eax
80105992:	79 0d                	jns    801059a1 <sys_link+0x11d>
    iunlockput(dp);
80105994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105997:	89 04 24             	mov    %eax,(%esp)
8010599a:	e8 38 c1 ff ff       	call   80101ad7 <iunlockput>
    goto bad;
8010599f:	eb 22                	jmp    801059c3 <sys_link+0x13f>
  }
  iunlockput(dp);
801059a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a4:	89 04 24             	mov    %eax,(%esp)
801059a7:	e8 2b c1 ff ff       	call   80101ad7 <iunlockput>
  iput(ip);
801059ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059af:	89 04 24             	mov    %eax,(%esp)
801059b2:	e8 4f c0 ff ff       	call   80101a06 <iput>

  commit_trans();
801059b7:	e8 6a d8 ff ff       	call   80103226 <commit_trans>

  return 0;
801059bc:	b8 00 00 00 00       	mov    $0x0,%eax
801059c1:	eb 3c                	jmp    801059ff <sys_link+0x17b>

bad:
  ilock(ip);
801059c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c6:	89 04 24             	mov    %eax,(%esp)
801059c9:	e8 85 be ff ff       	call   80101853 <ilock>
  ip->nlink--;
801059ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059d5:	8d 50 ff             	lea    -0x1(%eax),%edx
801059d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059db:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e2:	89 04 24             	mov    %eax,(%esp)
801059e5:	e8 ad bc ff ff       	call   80101697 <iupdate>
  iunlockput(ip);
801059ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ed:	89 04 24             	mov    %eax,(%esp)
801059f0:	e8 e2 c0 ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
801059f5:	e8 2c d8 ff ff       	call   80103226 <commit_trans>
  return -1;
801059fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ff:	c9                   	leave  
80105a00:	c3                   	ret    

80105a01 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a01:	55                   	push   %ebp
80105a02:	89 e5                	mov    %esp,%ebp
80105a04:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a07:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a0e:	eb 4b                	jmp    80105a5b <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a13:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105a1a:	00 
80105a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a26:	8b 45 08             	mov    0x8(%ebp),%eax
80105a29:	89 04 24             	mov    %eax,(%esp)
80105a2c:	e8 2f c3 ff ff       	call   80101d60 <readi>
80105a31:	83 f8 10             	cmp    $0x10,%eax
80105a34:	74 0c                	je     80105a42 <isdirempty+0x41>
      panic("isdirempty: readi");
80105a36:	c7 04 24 8f 89 10 80 	movl   $0x8010898f,(%esp)
80105a3d:	e8 f8 aa ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105a42:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105a46:	66 85 c0             	test   %ax,%ax
80105a49:	74 07                	je     80105a52 <isdirempty+0x51>
      return 0;
80105a4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a50:	eb 1b                	jmp    80105a6d <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a55:	83 c0 10             	add    $0x10,%eax
80105a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80105a61:	8b 40 18             	mov    0x18(%eax),%eax
80105a64:	39 c2                	cmp    %eax,%edx
80105a66:	72 a8                	jb     80105a10 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105a68:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a6d:	c9                   	leave  
80105a6e:	c3                   	ret    

80105a6f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a6f:	55                   	push   %ebp
80105a70:	89 e5                	mov    %esp,%ebp
80105a72:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a75:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105a78:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a83:	e8 76 fa ff ff       	call   801054fe <argstr>
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	79 0a                	jns    80105a96 <sys_unlink+0x27>
    return -1;
80105a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a91:	e9 aa 01 00 00       	jmp    80105c40 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105a96:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a99:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105a9c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105aa0:	89 04 24             	mov    %eax,(%esp)
80105aa3:	e8 78 c9 ff ff       	call   80102420 <nameiparent>
80105aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aaf:	75 0a                	jne    80105abb <sys_unlink+0x4c>
    return -1;
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab6:	e9 85 01 00 00       	jmp    80105c40 <sys_unlink+0x1d1>

  begin_trans();
80105abb:	e8 1d d7 ff ff       	call   801031dd <begin_trans>

  ilock(dp);
80105ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac3:	89 04 24             	mov    %eax,(%esp)
80105ac6:	e8 88 bd ff ff       	call   80101853 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105acb:	c7 44 24 04 a1 89 10 	movl   $0x801089a1,0x4(%esp)
80105ad2:	80 
80105ad3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ad6:	89 04 24             	mov    %eax,(%esp)
80105ad9:	e8 75 c5 ff ff       	call   80102053 <namecmp>
80105ade:	85 c0                	test   %eax,%eax
80105ae0:	0f 84 45 01 00 00    	je     80105c2b <sys_unlink+0x1bc>
80105ae6:	c7 44 24 04 a3 89 10 	movl   $0x801089a3,0x4(%esp)
80105aed:	80 
80105aee:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105af1:	89 04 24             	mov    %eax,(%esp)
80105af4:	e8 5a c5 ff ff       	call   80102053 <namecmp>
80105af9:	85 c0                	test   %eax,%eax
80105afb:	0f 84 2a 01 00 00    	je     80105c2b <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b01:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b04:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b08:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b12:	89 04 24             	mov    %eax,(%esp)
80105b15:	e8 5b c5 ff ff       	call   80102075 <dirlookup>
80105b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b21:	75 05                	jne    80105b28 <sys_unlink+0xb9>
    goto bad;
80105b23:	e9 03 01 00 00       	jmp    80105c2b <sys_unlink+0x1bc>
  ilock(ip);
80105b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2b:	89 04 24             	mov    %eax,(%esp)
80105b2e:	e8 20 bd ff ff       	call   80101853 <ilock>

  if(ip->nlink < 1)
80105b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b36:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b3a:	66 85 c0             	test   %ax,%ax
80105b3d:	7f 0c                	jg     80105b4b <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
80105b3f:	c7 04 24 a6 89 10 80 	movl   $0x801089a6,(%esp)
80105b46:	e8 ef a9 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b52:	66 83 f8 01          	cmp    $0x1,%ax
80105b56:	75 1f                	jne    80105b77 <sys_unlink+0x108>
80105b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5b:	89 04 24             	mov    %eax,(%esp)
80105b5e:	e8 9e fe ff ff       	call   80105a01 <isdirempty>
80105b63:	85 c0                	test   %eax,%eax
80105b65:	75 10                	jne    80105b77 <sys_unlink+0x108>
    iunlockput(ip);
80105b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6a:	89 04 24             	mov    %eax,(%esp)
80105b6d:	e8 65 bf ff ff       	call   80101ad7 <iunlockput>
    goto bad;
80105b72:	e9 b4 00 00 00       	jmp    80105c2b <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105b77:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105b7e:	00 
80105b7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b86:	00 
80105b87:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b8a:	89 04 24             	mov    %eax,(%esp)
80105b8d:	e8 9a f5 ff ff       	call   8010512c <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b92:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105b95:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b9c:	00 
80105b9d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ba1:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bab:	89 04 24             	mov    %eax,(%esp)
80105bae:	e8 11 c3 ff ff       	call   80101ec4 <writei>
80105bb3:	83 f8 10             	cmp    $0x10,%eax
80105bb6:	74 0c                	je     80105bc4 <sys_unlink+0x155>
    panic("unlink: writei");
80105bb8:	c7 04 24 b8 89 10 80 	movl   $0x801089b8,(%esp)
80105bbf:	e8 76 a9 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bcb:	66 83 f8 01          	cmp    $0x1,%ax
80105bcf:	75 1c                	jne    80105bed <sys_unlink+0x17e>
    dp->nlink--;
80105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bde:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be5:	89 04 24             	mov    %eax,(%esp)
80105be8:	e8 aa ba ff ff       	call   80101697 <iupdate>
  }
  iunlockput(dp);
80105bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf0:	89 04 24             	mov    %eax,(%esp)
80105bf3:	e8 df be ff ff       	call   80101ad7 <iunlockput>

  ip->nlink--;
80105bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bff:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c05:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0c:	89 04 24             	mov    %eax,(%esp)
80105c0f:	e8 83 ba ff ff       	call   80101697 <iupdate>
  iunlockput(ip);
80105c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c17:	89 04 24             	mov    %eax,(%esp)
80105c1a:	e8 b8 be ff ff       	call   80101ad7 <iunlockput>

  commit_trans();
80105c1f:	e8 02 d6 ff ff       	call   80103226 <commit_trans>

  return 0;
80105c24:	b8 00 00 00 00       	mov    $0x0,%eax
80105c29:	eb 15                	jmp    80105c40 <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
80105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2e:	89 04 24             	mov    %eax,(%esp)
80105c31:	e8 a1 be ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80105c36:	e8 eb d5 ff ff       	call   80103226 <commit_trans>
  return -1;
80105c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c40:	c9                   	leave  
80105c41:	c3                   	ret    

80105c42 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c42:	55                   	push   %ebp
80105c43:	89 e5                	mov    %esp,%ebp
80105c45:	83 ec 48             	sub    $0x48,%esp
80105c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c4b:	8b 55 10             	mov    0x10(%ebp),%edx
80105c4e:	8b 45 14             	mov    0x14(%ebp),%eax
80105c51:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c55:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105c59:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c5d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c60:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c64:	8b 45 08             	mov    0x8(%ebp),%eax
80105c67:	89 04 24             	mov    %eax,(%esp)
80105c6a:	e8 b1 c7 ff ff       	call   80102420 <nameiparent>
80105c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c76:	75 0a                	jne    80105c82 <create+0x40>
    return 0;
80105c78:	b8 00 00 00 00       	mov    $0x0,%eax
80105c7d:	e9 7e 01 00 00       	jmp    80105e00 <create+0x1be>
  ilock(dp);
80105c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c85:	89 04 24             	mov    %eax,(%esp)
80105c88:	e8 c6 bb ff ff       	call   80101853 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105c8d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c90:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c94:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c97:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9e:	89 04 24             	mov    %eax,(%esp)
80105ca1:	e8 cf c3 ff ff       	call   80102075 <dirlookup>
80105ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ca9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cad:	74 47                	je     80105cf6 <create+0xb4>
    iunlockput(dp);
80105caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb2:	89 04 24             	mov    %eax,(%esp)
80105cb5:	e8 1d be ff ff       	call   80101ad7 <iunlockput>
    ilock(ip);
80105cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbd:	89 04 24             	mov    %eax,(%esp)
80105cc0:	e8 8e bb ff ff       	call   80101853 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105cc5:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105cca:	75 15                	jne    80105ce1 <create+0x9f>
80105ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cd3:	66 83 f8 02          	cmp    $0x2,%ax
80105cd7:	75 08                	jne    80105ce1 <create+0x9f>
      return ip;
80105cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdc:	e9 1f 01 00 00       	jmp    80105e00 <create+0x1be>
    iunlockput(ip);
80105ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce4:	89 04 24             	mov    %eax,(%esp)
80105ce7:	e8 eb bd ff ff       	call   80101ad7 <iunlockput>
    return 0;
80105cec:	b8 00 00 00 00       	mov    $0x0,%eax
80105cf1:	e9 0a 01 00 00       	jmp    80105e00 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105cf6:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	8b 00                	mov    (%eax),%eax
80105cff:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d03:	89 04 24             	mov    %eax,(%esp)
80105d06:	e8 ad b8 ff ff       	call   801015b8 <ialloc>
80105d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d12:	75 0c                	jne    80105d20 <create+0xde>
    panic("create: ialloc");
80105d14:	c7 04 24 c7 89 10 80 	movl   $0x801089c7,(%esp)
80105d1b:	e8 1a a8 ff ff       	call   8010053a <panic>

  ilock(ip);
80105d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d23:	89 04 24             	mov    %eax,(%esp)
80105d26:	e8 28 bb ff ff       	call   80101853 <ilock>
  ip->major = major;
80105d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2e:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105d32:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d39:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105d3d:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d44:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4d:	89 04 24             	mov    %eax,(%esp)
80105d50:	e8 42 b9 ff ff       	call   80101697 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105d55:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d5a:	75 6a                	jne    80105dc6 <create+0x184>
    dp->nlink++;  // for ".."
80105d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d63:	8d 50 01             	lea    0x1(%eax),%edx
80105d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d69:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d70:	89 04 24             	mov    %eax,(%esp)
80105d73:	e8 1f b9 ff ff       	call   80101697 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7b:	8b 40 04             	mov    0x4(%eax),%eax
80105d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d82:	c7 44 24 04 a1 89 10 	movl   $0x801089a1,0x4(%esp)
80105d89:	80 
80105d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8d:	89 04 24             	mov    %eax,(%esp)
80105d90:	e8 a9 c3 ff ff       	call   8010213e <dirlink>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	78 21                	js     80105dba <create+0x178>
80105d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9c:	8b 40 04             	mov    0x4(%eax),%eax
80105d9f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105da3:	c7 44 24 04 a3 89 10 	movl   $0x801089a3,0x4(%esp)
80105daa:	80 
80105dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dae:	89 04 24             	mov    %eax,(%esp)
80105db1:	e8 88 c3 ff ff       	call   8010213e <dirlink>
80105db6:	85 c0                	test   %eax,%eax
80105db8:	79 0c                	jns    80105dc6 <create+0x184>
      panic("create dots");
80105dba:	c7 04 24 d6 89 10 80 	movl   $0x801089d6,(%esp)
80105dc1:	e8 74 a7 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc9:	8b 40 04             	mov    0x4(%eax),%eax
80105dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dd0:	8d 45 de             	lea    -0x22(%ebp),%eax
80105dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dda:	89 04 24             	mov    %eax,(%esp)
80105ddd:	e8 5c c3 ff ff       	call   8010213e <dirlink>
80105de2:	85 c0                	test   %eax,%eax
80105de4:	79 0c                	jns    80105df2 <create+0x1b0>
    panic("create: dirlink");
80105de6:	c7 04 24 e2 89 10 80 	movl   $0x801089e2,(%esp)
80105ded:	e8 48 a7 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df5:	89 04 24             	mov    %eax,(%esp)
80105df8:	e8 da bc ff ff       	call   80101ad7 <iunlockput>

  return ip;
80105dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e00:	c9                   	leave  
80105e01:	c3                   	ret    

80105e02 <sys_open>:

int
sys_open(void)
{
80105e02:	55                   	push   %ebp
80105e03:	89 e5                	mov    %esp,%ebp
80105e05:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e08:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e16:	e8 e3 f6 ff ff       	call   801054fe <argstr>
80105e1b:	85 c0                	test   %eax,%eax
80105e1d:	78 17                	js     80105e36 <sys_open+0x34>
80105e1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e2d:	e8 3c f6 ff ff       	call   8010546e <argint>
80105e32:	85 c0                	test   %eax,%eax
80105e34:	79 0a                	jns    80105e40 <sys_open+0x3e>
    return -1;
80105e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3b:	e9 48 01 00 00       	jmp    80105f88 <sys_open+0x186>
  if(omode & O_CREATE){
80105e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e43:	25 00 02 00 00       	and    $0x200,%eax
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	74 40                	je     80105e8c <sys_open+0x8a>
    begin_trans();
80105e4c:	e8 8c d3 ff ff       	call   801031dd <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e54:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105e5b:	00 
80105e5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105e63:	00 
80105e64:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105e6b:	00 
80105e6c:	89 04 24             	mov    %eax,(%esp)
80105e6f:	e8 ce fd ff ff       	call   80105c42 <create>
80105e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105e77:	e8 aa d3 ff ff       	call   80103226 <commit_trans>
    if(ip == 0)
80105e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e80:	75 5c                	jne    80105ede <sys_open+0xdc>
      return -1;
80105e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e87:	e9 fc 00 00 00       	jmp    80105f88 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
80105e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e8f:	89 04 24             	mov    %eax,(%esp)
80105e92:	e8 67 c5 ff ff       	call   801023fe <namei>
80105e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e9e:	75 0a                	jne    80105eaa <sys_open+0xa8>
      return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea5:	e9 de 00 00 00       	jmp    80105f88 <sys_open+0x186>
    ilock(ip);
80105eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ead:	89 04 24             	mov    %eax,(%esp)
80105eb0:	e8 9e b9 ff ff       	call   80101853 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ebc:	66 83 f8 01          	cmp    $0x1,%ax
80105ec0:	75 1c                	jne    80105ede <sys_open+0xdc>
80105ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	74 15                	je     80105ede <sys_open+0xdc>
      iunlockput(ip);
80105ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecc:	89 04 24             	mov    %eax,(%esp)
80105ecf:	e8 03 bc ff ff       	call   80101ad7 <iunlockput>
      return -1;
80105ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed9:	e9 aa 00 00 00       	jmp    80105f88 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ede:	e8 3b b0 ff ff       	call   80100f1e <filealloc>
80105ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ee6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105eea:	74 14                	je     80105f00 <sys_open+0xfe>
80105eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eef:	89 04 24             	mov    %eax,(%esp)
80105ef2:	e8 42 f7 ff ff       	call   80105639 <fdalloc>
80105ef7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105efa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105efe:	79 23                	jns    80105f23 <sys_open+0x121>
    if(f)
80105f00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f04:	74 0b                	je     80105f11 <sys_open+0x10f>
      fileclose(f);
80105f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f09:	89 04 24             	mov    %eax,(%esp)
80105f0c:	e8 b5 b0 ff ff       	call   80100fc6 <fileclose>
    iunlockput(ip);
80105f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f14:	89 04 24             	mov    %eax,(%esp)
80105f17:	e8 bb bb ff ff       	call   80101ad7 <iunlockput>
    return -1;
80105f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f21:	eb 65                	jmp    80105f88 <sys_open+0x186>
  }
  iunlock(ip);
80105f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f26:	89 04 24             	mov    %eax,(%esp)
80105f29:	e8 73 ba ff ff       	call   801019a1 <iunlock>

  f->type = FD_INODE;
80105f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f31:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f3d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f43:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105f4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f4d:	83 e0 01             	and    $0x1,%eax
80105f50:	85 c0                	test   %eax,%eax
80105f52:	0f 94 c0             	sete   %al
80105f55:	89 c2                	mov    %eax,%edx
80105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f60:	83 e0 01             	and    $0x1,%eax
80105f63:	85 c0                	test   %eax,%eax
80105f65:	75 0a                	jne    80105f71 <sys_open+0x16f>
80105f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f6a:	83 e0 02             	and    $0x2,%eax
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	74 07                	je     80105f78 <sys_open+0x176>
80105f71:	b8 01 00 00 00       	mov    $0x1,%eax
80105f76:	eb 05                	jmp    80105f7d <sys_open+0x17b>
80105f78:	b8 00 00 00 00       	mov    $0x0,%eax
80105f7d:	89 c2                	mov    %eax,%edx
80105f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f82:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f88:	c9                   	leave  
80105f89:	c3                   	ret    

80105f8a <sys_mkdir>:

int
sys_mkdir(void)
{
80105f8a:	55                   	push   %ebp
80105f8b:	89 e5                	mov    %esp,%ebp
80105f8d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105f90:	e8 48 d2 ff ff       	call   801031dd <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f95:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f98:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fa3:	e8 56 f5 ff ff       	call   801054fe <argstr>
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	78 2c                	js     80105fd8 <sys_mkdir+0x4e>
80105fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105faf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105fb6:	00 
80105fb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105fbe:	00 
80105fbf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105fc6:	00 
80105fc7:	89 04 24             	mov    %eax,(%esp)
80105fca:	e8 73 fc ff ff       	call   80105c42 <create>
80105fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fd6:	75 0c                	jne    80105fe4 <sys_mkdir+0x5a>
    commit_trans();
80105fd8:	e8 49 d2 ff ff       	call   80103226 <commit_trans>
    return -1;
80105fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe2:	eb 15                	jmp    80105ff9 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe7:	89 04 24             	mov    %eax,(%esp)
80105fea:	e8 e8 ba ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80105fef:	e8 32 d2 ff ff       	call   80103226 <commit_trans>
  return 0;
80105ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ff9:	c9                   	leave  
80105ffa:	c3                   	ret    

80105ffb <sys_mknod>:

int
sys_mknod(void)
{
80105ffb:	55                   	push   %ebp
80105ffc:	89 e5                	mov    %esp,%ebp
80105ffe:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106001:	e8 d7 d1 ff ff       	call   801031dd <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106006:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010600d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106014:	e8 e5 f4 ff ff       	call   801054fe <argstr>
80106019:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010601c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106020:	78 5e                	js     80106080 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106022:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106025:	89 44 24 04          	mov    %eax,0x4(%esp)
80106029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106030:	e8 39 f4 ff ff       	call   8010546e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106035:	85 c0                	test   %eax,%eax
80106037:	78 47                	js     80106080 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106039:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010603c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106040:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106047:	e8 22 f4 ff ff       	call   8010546e <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010604c:	85 c0                	test   %eax,%eax
8010604e:	78 30                	js     80106080 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106053:	0f bf c8             	movswl %ax,%ecx
80106056:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106059:	0f bf d0             	movswl %ax,%edx
8010605c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010605f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106063:	89 54 24 08          	mov    %edx,0x8(%esp)
80106067:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010606e:	00 
8010606f:	89 04 24             	mov    %eax,(%esp)
80106072:	e8 cb fb ff ff       	call   80105c42 <create>
80106077:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010607a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010607e:	75 0c                	jne    8010608c <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106080:	e8 a1 d1 ff ff       	call   80103226 <commit_trans>
    return -1;
80106085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608a:	eb 15                	jmp    801060a1 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010608c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608f:	89 04 24             	mov    %eax,(%esp)
80106092:	e8 40 ba ff ff       	call   80101ad7 <iunlockput>
  commit_trans();
80106097:	e8 8a d1 ff ff       	call   80103226 <commit_trans>
  return 0;
8010609c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060a1:	c9                   	leave  
801060a2:	c3                   	ret    

801060a3 <sys_chdir>:

int
sys_chdir(void)
{
801060a3:	55                   	push   %ebp
801060a4:	89 e5                	mov    %esp,%ebp
801060a6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801060a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801060b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b7:	e8 42 f4 ff ff       	call   801054fe <argstr>
801060bc:	85 c0                	test   %eax,%eax
801060be:	78 14                	js     801060d4 <sys_chdir+0x31>
801060c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c3:	89 04 24             	mov    %eax,(%esp)
801060c6:	e8 33 c3 ff ff       	call   801023fe <namei>
801060cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d2:	75 07                	jne    801060db <sys_chdir+0x38>
    return -1;
801060d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d9:	eb 57                	jmp    80106132 <sys_chdir+0x8f>
  ilock(ip);
801060db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060de:	89 04 24             	mov    %eax,(%esp)
801060e1:	e8 6d b7 ff ff       	call   80101853 <ilock>
  if(ip->type != T_DIR){
801060e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060ed:	66 83 f8 01          	cmp    $0x1,%ax
801060f1:	74 12                	je     80106105 <sys_chdir+0x62>
    iunlockput(ip);
801060f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f6:	89 04 24             	mov    %eax,(%esp)
801060f9:	e8 d9 b9 ff ff       	call   80101ad7 <iunlockput>
    return -1;
801060fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106103:	eb 2d                	jmp    80106132 <sys_chdir+0x8f>
  }
  iunlock(ip);
80106105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106108:	89 04 24             	mov    %eax,(%esp)
8010610b:	e8 91 b8 ff ff       	call   801019a1 <iunlock>
  iput(proc->cwd);
80106110:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106116:	8b 40 68             	mov    0x68(%eax),%eax
80106119:	89 04 24             	mov    %eax,(%esp)
8010611c:	e8 e5 b8 ff ff       	call   80101a06 <iput>
  proc->cwd = ip;
80106121:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106127:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010612a:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010612d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106132:	c9                   	leave  
80106133:	c3                   	ret    

80106134 <sys_exec>:

int
sys_exec(void)
{
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010613d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106140:	89 44 24 04          	mov    %eax,0x4(%esp)
80106144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010614b:	e8 ae f3 ff ff       	call   801054fe <argstr>
80106150:	85 c0                	test   %eax,%eax
80106152:	78 1a                	js     8010616e <sys_exec+0x3a>
80106154:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010615a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010615e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106165:	e8 04 f3 ff ff       	call   8010546e <argint>
8010616a:	85 c0                	test   %eax,%eax
8010616c:	79 0a                	jns    80106178 <sys_exec+0x44>
    return -1;
8010616e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106173:	e9 c8 00 00 00       	jmp    80106240 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106178:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010617f:	00 
80106180:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106187:	00 
80106188:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010618e:	89 04 24             	mov    %eax,(%esp)
80106191:	e8 96 ef ff ff       	call   8010512c <memset>
  for(i=0;; i++){
80106196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010619d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a0:	83 f8 1f             	cmp    $0x1f,%eax
801061a3:	76 0a                	jbe    801061af <sys_exec+0x7b>
      return -1;
801061a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061aa:	e9 91 00 00 00       	jmp    80106240 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801061af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b2:	c1 e0 02             	shl    $0x2,%eax
801061b5:	89 c2                	mov    %eax,%edx
801061b7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801061bd:	01 c2                	add    %eax,%edx
801061bf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c9:	89 14 24             	mov    %edx,(%esp)
801061cc:	e8 01 f2 ff ff       	call   801053d2 <fetchint>
801061d1:	85 c0                	test   %eax,%eax
801061d3:	79 07                	jns    801061dc <sys_exec+0xa8>
      return -1;
801061d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061da:	eb 64                	jmp    80106240 <sys_exec+0x10c>
    if(uarg == 0){
801061dc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061e2:	85 c0                	test   %eax,%eax
801061e4:	75 26                	jne    8010620c <sys_exec+0xd8>
      argv[i] = 0;
801061e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e9:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801061f0:	00 00 00 00 
      break;
801061f4:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f8:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80106202:	89 04 24             	mov    %eax,(%esp)
80106205:	e8 e5 a8 ff ff       	call   80100aef <exec>
8010620a:	eb 34                	jmp    80106240 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010620c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106212:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106215:	c1 e2 02             	shl    $0x2,%edx
80106218:	01 c2                	add    %eax,%edx
8010621a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106220:	89 54 24 04          	mov    %edx,0x4(%esp)
80106224:	89 04 24             	mov    %eax,(%esp)
80106227:	e8 e0 f1 ff ff       	call   8010540c <fetchstr>
8010622c:	85 c0                	test   %eax,%eax
8010622e:	79 07                	jns    80106237 <sys_exec+0x103>
      return -1;
80106230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106235:	eb 09                	jmp    80106240 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106237:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
8010623b:	e9 5d ff ff ff       	jmp    8010619d <sys_exec+0x69>
  return exec(path, argv);
}
80106240:	c9                   	leave  
80106241:	c3                   	ret    

80106242 <sys_pipe>:

int
sys_pipe(void)
{
80106242:	55                   	push   %ebp
80106243:	89 e5                	mov    %esp,%ebp
80106245:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106248:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010624f:	00 
80106250:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106253:	89 44 24 04          	mov    %eax,0x4(%esp)
80106257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010625e:	e8 39 f2 ff ff       	call   8010549c <argptr>
80106263:	85 c0                	test   %eax,%eax
80106265:	79 0a                	jns    80106271 <sys_pipe+0x2f>
    return -1;
80106267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626c:	e9 9b 00 00 00       	jmp    8010630c <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106271:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106274:	89 44 24 04          	mov    %eax,0x4(%esp)
80106278:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010627b:	89 04 24             	mov    %eax,(%esp)
8010627e:	e8 44 d9 ff ff       	call   80103bc7 <pipealloc>
80106283:	85 c0                	test   %eax,%eax
80106285:	79 07                	jns    8010628e <sys_pipe+0x4c>
    return -1;
80106287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010628c:	eb 7e                	jmp    8010630c <sys_pipe+0xca>
  fd0 = -1;
8010628e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106295:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106298:	89 04 24             	mov    %eax,(%esp)
8010629b:	e8 99 f3 ff ff       	call   80105639 <fdalloc>
801062a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062a7:	78 14                	js     801062bd <sys_pipe+0x7b>
801062a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062ac:	89 04 24             	mov    %eax,(%esp)
801062af:	e8 85 f3 ff ff       	call   80105639 <fdalloc>
801062b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062bb:	79 37                	jns    801062f4 <sys_pipe+0xb2>
    if(fd0 >= 0)
801062bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062c1:	78 14                	js     801062d7 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801062c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062cc:	83 c2 08             	add    $0x8,%edx
801062cf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801062d6:	00 
    fileclose(rf);
801062d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062da:	89 04 24             	mov    %eax,(%esp)
801062dd:	e8 e4 ac ff ff       	call   80100fc6 <fileclose>
    fileclose(wf);
801062e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062e5:	89 04 24             	mov    %eax,(%esp)
801062e8:	e8 d9 ac ff ff       	call   80100fc6 <fileclose>
    return -1;
801062ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f2:	eb 18                	jmp    8010630c <sys_pipe+0xca>
  }
  fd[0] = fd0;
801062f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062fa:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801062fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062ff:	8d 50 04             	lea    0x4(%eax),%edx
80106302:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106305:	89 02                	mov    %eax,(%edx)
  return 0;
80106307:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010630c:	c9                   	leave  
8010630d:	c3                   	ret    

8010630e <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010630e:	55                   	push   %ebp
8010630f:	89 e5                	mov    %esp,%ebp
80106311:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106314:	e8 de df ff ff       	call   801042f7 <fork>
}
80106319:	c9                   	leave  
8010631a:	c3                   	ret    

8010631b <sys_clone>:

int
sys_clone(){
8010631b:	55                   	push   %ebp
8010631c:	89 e5                	mov    %esp,%ebp
8010631e:	53                   	push   %ebx
8010631f:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106322:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106325:	89 44 24 04          	mov    %eax,0x4(%esp)
80106329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106330:	e8 39 f1 ff ff       	call   8010546e <argint>
80106335:	85 c0                	test   %eax,%eax
80106337:	78 4c                	js     80106385 <sys_clone+0x6a>
80106339:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010633c:	85 c0                	test   %eax,%eax
8010633e:	7e 45                	jle    80106385 <sys_clone+0x6a>
80106340:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106343:	89 44 24 04          	mov    %eax,0x4(%esp)
80106347:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010634e:	e8 1b f1 ff ff       	call   8010546e <argint>
80106353:	85 c0                	test   %eax,%eax
80106355:	78 2e                	js     80106385 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106357:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010635a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010635e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106365:	e8 04 f1 ff ff       	call   8010546e <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
8010636a:	85 c0                	test   %eax,%eax
8010636c:	78 17                	js     80106385 <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
8010636e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106371:	89 44 24 04          	mov    %eax,0x4(%esp)
80106375:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
8010637c:	e8 ed f0 ff ff       	call   8010546e <argint>
80106381:	85 c0                	test   %eax,%eax
80106383:	79 07                	jns    8010638c <sys_clone+0x71>
        return -1;
80106385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638a:	eb 20                	jmp    801063ac <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
8010638c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
8010638f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106392:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106398:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010639c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801063a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801063a4:	89 04 24             	mov    %eax,(%esp)
801063a7:	e8 bb e0 ff ff       	call   80104467 <clone>
}
801063ac:	83 c4 24             	add    $0x24,%esp
801063af:	5b                   	pop    %ebx
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    

801063b2 <sys_exit>:

int
sys_exit(void)
{
801063b2:	55                   	push   %ebp
801063b3:	89 e5                	mov    %esp,%ebp
801063b5:	83 ec 08             	sub    $0x8,%esp
  exit();
801063b8:	e8 cd e2 ff ff       	call   8010468a <exit>
  return 0;  // not reached
801063bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063c2:	c9                   	leave  
801063c3:	c3                   	ret    

801063c4 <sys_texit>:

int
sys_texit(void)
{
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 08             	sub    $0x8,%esp
    texit();
801063ca:	e8 d6 e3 ff ff       	call   801047a5 <texit>
    return 0;
801063cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063d4:	c9                   	leave  
801063d5:	c3                   	ret    

801063d6 <sys_wait>:

int
sys_wait(void)
{
801063d6:	55                   	push   %ebp
801063d7:	89 e5                	mov    %esp,%ebp
801063d9:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063dc:	e8 92 e4 ff ff       	call   80104873 <wait>
}
801063e1:	c9                   	leave  
801063e2:	c3                   	ret    

801063e3 <sys_kill>:

int
sys_kill(void)
{
801063e3:	55                   	push   %ebp
801063e4:	89 e5                	mov    %esp,%ebp
801063e6:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801063f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063f7:	e8 72 f0 ff ff       	call   8010546e <argint>
801063fc:	85 c0                	test   %eax,%eax
801063fe:	79 07                	jns    80106407 <sys_kill+0x24>
    return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106405:	eb 0b                	jmp    80106412 <sys_kill+0x2f>
  return kill(pid);
80106407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640a:	89 04 24             	mov    %eax,(%esp)
8010640d:	e8 c4 e8 ff ff       	call   80104cd6 <kill>
}
80106412:	c9                   	leave  
80106413:	c3                   	ret    

80106414 <sys_getpid>:

int
sys_getpid(void)
{
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106417:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010641d:	8b 40 10             	mov    0x10(%eax),%eax
}
80106420:	5d                   	pop    %ebp
80106421:	c3                   	ret    

80106422 <sys_sbrk>:

int
sys_sbrk(void)
{
80106422:	55                   	push   %ebp
80106423:	89 e5                	mov    %esp,%ebp
80106425:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106428:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010642b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010642f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106436:	e8 33 f0 ff ff       	call   8010546e <argint>
8010643b:	85 c0                	test   %eax,%eax
8010643d:	79 07                	jns    80106446 <sys_sbrk+0x24>
    return -1;
8010643f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106444:	eb 24                	jmp    8010646a <sys_sbrk+0x48>
  addr = proc->sz;
80106446:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010644c:	8b 00                	mov    (%eax),%eax
8010644e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106454:	89 04 24             	mov    %eax,(%esp)
80106457:	e8 f6 dd ff ff       	call   80104252 <growproc>
8010645c:	85 c0                	test   %eax,%eax
8010645e:	79 07                	jns    80106467 <sys_sbrk+0x45>
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106465:	eb 03                	jmp    8010646a <sys_sbrk+0x48>
  return addr;
80106467:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010646a:	c9                   	leave  
8010646b:	c3                   	ret    

8010646c <sys_sleep>:

int
sys_sleep(void)
{
8010646c:	55                   	push   %ebp
8010646d:	89 e5                	mov    %esp,%ebp
8010646f:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106472:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106475:	89 44 24 04          	mov    %eax,0x4(%esp)
80106479:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106480:	e8 e9 ef ff ff       	call   8010546e <argint>
80106485:	85 c0                	test   %eax,%eax
80106487:	79 07                	jns    80106490 <sys_sleep+0x24>
    return -1;
80106489:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648e:	eb 6c                	jmp    801064fc <sys_sleep+0x90>
  acquire(&tickslock);
80106490:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80106497:	e8 3c ea ff ff       	call   80104ed8 <acquire>
  ticks0 = ticks;
8010649c:	a1 c0 28 11 80       	mov    0x801128c0,%eax
801064a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064a4:	eb 34                	jmp    801064da <sys_sleep+0x6e>
    if(proc->killed){
801064a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ac:	8b 40 24             	mov    0x24(%eax),%eax
801064af:	85 c0                	test   %eax,%eax
801064b1:	74 13                	je     801064c6 <sys_sleep+0x5a>
      release(&tickslock);
801064b3:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801064ba:	e8 7b ea ff ff       	call   80104f3a <release>
      return -1;
801064bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c4:	eb 36                	jmp    801064fc <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801064c6:	c7 44 24 04 80 20 11 	movl   $0x80112080,0x4(%esp)
801064cd:	80 
801064ce:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
801064d5:	e8 8d e6 ff ff       	call   80104b67 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064da:	a1 c0 28 11 80       	mov    0x801128c0,%eax
801064df:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064e2:	89 c2                	mov    %eax,%edx
801064e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064e7:	39 c2                	cmp    %eax,%edx
801064e9:	72 bb                	jb     801064a6 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064eb:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801064f2:	e8 43 ea ff ff       	call   80104f3a <release>
  return 0;
801064f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064fc:	c9                   	leave  
801064fd:	c3                   	ret    

801064fe <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064fe:	55                   	push   %ebp
801064ff:	89 e5                	mov    %esp,%ebp
80106501:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106504:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010650b:	e8 c8 e9 ff ff       	call   80104ed8 <acquire>
  xticks = ticks;
80106510:	a1 c0 28 11 80       	mov    0x801128c0,%eax
80106515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106518:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010651f:	e8 16 ea ff ff       	call   80104f3a <release>
  return xticks;
80106524:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106527:	c9                   	leave  
80106528:	c3                   	ret    

80106529 <sys_tsleep>:

int
sys_tsleep(void)
{
80106529:	55                   	push   %ebp
8010652a:	89 e5                	mov    %esp,%ebp
8010652c:	83 ec 08             	sub    $0x8,%esp
    tsleep();
8010652f:	e8 17 e9 ff ff       	call   80104e4b <tsleep>
    return 0;
80106534:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106539:	c9                   	leave  
8010653a:	c3                   	ret    

8010653b <sys_twakeup>:

int 
sys_twakeup(void)
{
8010653b:	55                   	push   %ebp
8010653c:	89 e5                	mov    %esp,%ebp
8010653e:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
80106541:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106544:	89 44 24 04          	mov    %eax,0x4(%esp)
80106548:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010654f:	e8 1a ef ff ff       	call   8010546e <argint>
80106554:	85 c0                	test   %eax,%eax
80106556:	79 07                	jns    8010655f <sys_twakeup+0x24>
        return -1;
80106558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655d:	eb 10                	jmp    8010656f <sys_twakeup+0x34>
    }
        twakeup(tid);
8010655f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106562:	89 04 24             	mov    %eax,(%esp)
80106565:	e8 d9 e6 ff ff       	call   80104c43 <twakeup>
        return 0;
8010656a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656f:	c9                   	leave  
80106570:	c3                   	ret    

80106571 <sys_thread_yield>:

/////////////////////////////////////////
int
sys_thread_yield(void)
{
80106571:	55                   	push   %ebp
80106572:	89 e5                	mov    %esp,%ebp
80106574:	83 ec 08             	sub    $0x8,%esp
  yield();
80106577:	e8 8d e5 ff ff       	call   80104b09 <yield>
  return 0;
8010657c:	b8 00 00 00 00       	mov    $0x0,%eax
80106581:	c9                   	leave  
80106582:	c3                   	ret    

80106583 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106583:	55                   	push   %ebp
80106584:	89 e5                	mov    %esp,%ebp
80106586:	83 ec 08             	sub    $0x8,%esp
80106589:	8b 55 08             	mov    0x8(%ebp),%edx
8010658c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010658f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106593:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106596:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010659a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010659e:	ee                   	out    %al,(%dx)
}
8010659f:	c9                   	leave  
801065a0:	c3                   	ret    

801065a1 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801065a1:	55                   	push   %ebp
801065a2:	89 e5                	mov    %esp,%ebp
801065a4:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801065a7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801065ae:	00 
801065af:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801065b6:	e8 c8 ff ff ff       	call   80106583 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801065bb:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801065c2:	00 
801065c3:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065ca:	e8 b4 ff ff ff       	call   80106583 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065cf:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801065d6:	00 
801065d7:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065de:	e8 a0 ff ff ff       	call   80106583 <outb>
  picenable(IRQ_TIMER);
801065e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065ea:	e8 6b d4 ff ff       	call   80103a5a <picenable>
}
801065ef:	c9                   	leave  
801065f0:	c3                   	ret    

801065f1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065f1:	1e                   	push   %ds
  pushl %es
801065f2:	06                   	push   %es
  pushl %fs
801065f3:	0f a0                	push   %fs
  pushl %gs
801065f5:	0f a8                	push   %gs
  pushal
801065f7:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801065f8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065fc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065fe:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106600:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106604:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106606:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106608:	54                   	push   %esp
  call trap
80106609:	e8 d8 01 00 00       	call   801067e6 <trap>
  addl $4, %esp
8010660e:	83 c4 04             	add    $0x4,%esp

80106611 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106611:	61                   	popa   
  popl %gs
80106612:	0f a9                	pop    %gs
  popl %fs
80106614:	0f a1                	pop    %fs
  popl %es
80106616:	07                   	pop    %es
  popl %ds
80106617:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106618:	83 c4 08             	add    $0x8,%esp
  iret
8010661b:	cf                   	iret   

8010661c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010661c:	55                   	push   %ebp
8010661d:	89 e5                	mov    %esp,%ebp
8010661f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106622:	8b 45 0c             	mov    0xc(%ebp),%eax
80106625:	83 e8 01             	sub    $0x1,%eax
80106628:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010662c:	8b 45 08             	mov    0x8(%ebp),%eax
8010662f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106633:	8b 45 08             	mov    0x8(%ebp),%eax
80106636:	c1 e8 10             	shr    $0x10,%eax
80106639:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010663d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106640:	0f 01 18             	lidtl  (%eax)
}
80106643:	c9                   	leave  
80106644:	c3                   	ret    

80106645 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106645:	55                   	push   %ebp
80106646:	89 e5                	mov    %esp,%ebp
80106648:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010664b:	0f 20 d0             	mov    %cr2,%eax
8010664e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106651:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106654:	c9                   	leave  
80106655:	c3                   	ret    

80106656 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106656:	55                   	push   %ebp
80106657:	89 e5                	mov    %esp,%ebp
80106659:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010665c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106663:	e9 c3 00 00 00       	jmp    8010672b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666b:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
80106672:	89 c2                	mov    %eax,%edx
80106674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106677:	66 89 14 c5 c0 20 11 	mov    %dx,-0x7feedf40(,%eax,8)
8010667e:	80 
8010667f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106682:	66 c7 04 c5 c2 20 11 	movw   $0x8,-0x7feedf3e(,%eax,8)
80106689:	80 08 00 
8010668c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668f:	0f b6 14 c5 c4 20 11 	movzbl -0x7feedf3c(,%eax,8),%edx
80106696:	80 
80106697:	83 e2 e0             	and    $0xffffffe0,%edx
8010669a:	88 14 c5 c4 20 11 80 	mov    %dl,-0x7feedf3c(,%eax,8)
801066a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a4:	0f b6 14 c5 c4 20 11 	movzbl -0x7feedf3c(,%eax,8),%edx
801066ab:	80 
801066ac:	83 e2 1f             	and    $0x1f,%edx
801066af:	88 14 c5 c4 20 11 80 	mov    %dl,-0x7feedf3c(,%eax,8)
801066b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b9:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
801066c0:	80 
801066c1:	83 e2 f0             	and    $0xfffffff0,%edx
801066c4:	83 ca 0e             	or     $0xe,%edx
801066c7:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
801066ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d1:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
801066d8:	80 
801066d9:	83 e2 ef             	and    $0xffffffef,%edx
801066dc:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
801066e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e6:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
801066ed:	80 
801066ee:	83 e2 9f             	and    $0xffffff9f,%edx
801066f1:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
801066f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fb:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
80106702:	80 
80106703:	83 ca 80             	or     $0xffffff80,%edx
80106706:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
8010670d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106710:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
80106717:	c1 e8 10             	shr    $0x10,%eax
8010671a:	89 c2                	mov    %eax,%edx
8010671c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671f:	66 89 14 c5 c6 20 11 	mov    %dx,-0x7feedf3a(,%eax,8)
80106726:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106727:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010672b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106732:	0f 8e 30 ff ff ff    	jle    80106668 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106738:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
8010673d:	66 a3 c0 22 11 80    	mov    %ax,0x801122c0
80106743:	66 c7 05 c2 22 11 80 	movw   $0x8,0x801122c2
8010674a:	08 00 
8010674c:	0f b6 05 c4 22 11 80 	movzbl 0x801122c4,%eax
80106753:	83 e0 e0             	and    $0xffffffe0,%eax
80106756:	a2 c4 22 11 80       	mov    %al,0x801122c4
8010675b:	0f b6 05 c4 22 11 80 	movzbl 0x801122c4,%eax
80106762:	83 e0 1f             	and    $0x1f,%eax
80106765:	a2 c4 22 11 80       	mov    %al,0x801122c4
8010676a:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
80106771:	83 c8 0f             	or     $0xf,%eax
80106774:	a2 c5 22 11 80       	mov    %al,0x801122c5
80106779:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
80106780:	83 e0 ef             	and    $0xffffffef,%eax
80106783:	a2 c5 22 11 80       	mov    %al,0x801122c5
80106788:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
8010678f:	83 c8 60             	or     $0x60,%eax
80106792:	a2 c5 22 11 80       	mov    %al,0x801122c5
80106797:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
8010679e:	83 c8 80             	or     $0xffffff80,%eax
801067a1:	a2 c5 22 11 80       	mov    %al,0x801122c5
801067a6:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
801067ab:	c1 e8 10             	shr    $0x10,%eax
801067ae:	66 a3 c6 22 11 80    	mov    %ax,0x801122c6
  
  initlock(&tickslock, "time");
801067b4:	c7 44 24 04 f4 89 10 	movl   $0x801089f4,0x4(%esp)
801067bb:	80 
801067bc:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801067c3:	e8 ef e6 ff ff       	call   80104eb7 <initlock>
}
801067c8:	c9                   	leave  
801067c9:	c3                   	ret    

801067ca <idtinit>:

void
idtinit(void)
{
801067ca:	55                   	push   %ebp
801067cb:	89 e5                	mov    %esp,%ebp
801067cd:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801067d0:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801067d7:	00 
801067d8:	c7 04 24 c0 20 11 80 	movl   $0x801120c0,(%esp)
801067df:	e8 38 fe ff ff       	call   8010661c <lidt>
}
801067e4:	c9                   	leave  
801067e5:	c3                   	ret    

801067e6 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801067e6:	55                   	push   %ebp
801067e7:	89 e5                	mov    %esp,%ebp
801067e9:	57                   	push   %edi
801067ea:	56                   	push   %esi
801067eb:	53                   	push   %ebx
801067ec:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801067ef:	8b 45 08             	mov    0x8(%ebp),%eax
801067f2:	8b 40 30             	mov    0x30(%eax),%eax
801067f5:	83 f8 40             	cmp    $0x40,%eax
801067f8:	75 3f                	jne    80106839 <trap+0x53>
    if(proc->killed)
801067fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106800:	8b 40 24             	mov    0x24(%eax),%eax
80106803:	85 c0                	test   %eax,%eax
80106805:	74 05                	je     8010680c <trap+0x26>
      exit();
80106807:	e8 7e de ff ff       	call   8010468a <exit>
    proc->tf = tf;
8010680c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106812:	8b 55 08             	mov    0x8(%ebp),%edx
80106815:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106818:	e8 18 ed ff ff       	call   80105535 <syscall>
    if(proc->killed)
8010681d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106823:	8b 40 24             	mov    0x24(%eax),%eax
80106826:	85 c0                	test   %eax,%eax
80106828:	74 0a                	je     80106834 <trap+0x4e>
      exit();
8010682a:	e8 5b de ff ff       	call   8010468a <exit>
    return;
8010682f:	e9 2d 02 00 00       	jmp    80106a61 <trap+0x27b>
80106834:	e9 28 02 00 00       	jmp    80106a61 <trap+0x27b>
  }

  switch(tf->trapno){
80106839:	8b 45 08             	mov    0x8(%ebp),%eax
8010683c:	8b 40 30             	mov    0x30(%eax),%eax
8010683f:	83 e8 20             	sub    $0x20,%eax
80106842:	83 f8 1f             	cmp    $0x1f,%eax
80106845:	0f 87 bc 00 00 00    	ja     80106907 <trap+0x121>
8010684b:	8b 04 85 9c 8a 10 80 	mov    -0x7fef7564(,%eax,4),%eax
80106852:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106854:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010685a:	0f b6 00             	movzbl (%eax),%eax
8010685d:	84 c0                	test   %al,%al
8010685f:	75 31                	jne    80106892 <trap+0xac>
      acquire(&tickslock);
80106861:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80106868:	e8 6b e6 ff ff       	call   80104ed8 <acquire>
      ticks++;
8010686d:	a1 c0 28 11 80       	mov    0x801128c0,%eax
80106872:	83 c0 01             	add    $0x1,%eax
80106875:	a3 c0 28 11 80       	mov    %eax,0x801128c0
      wakeup(&ticks);
8010687a:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
80106881:	e8 25 e4 ff ff       	call   80104cab <wakeup>
      release(&tickslock);
80106886:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010688d:	e8 a8 e6 ff ff       	call   80104f3a <release>
    }
    lapiceoi();
80106892:	e8 14 c6 ff ff       	call   80102eab <lapiceoi>
    break;
80106897:	e9 41 01 00 00       	jmp    801069dd <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010689c:	e8 35 be ff ff       	call   801026d6 <ideintr>
    lapiceoi();
801068a1:	e8 05 c6 ff ff       	call   80102eab <lapiceoi>
    break;
801068a6:	e9 32 01 00 00       	jmp    801069dd <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801068ab:	e8 e7 c3 ff ff       	call   80102c97 <kbdintr>
    lapiceoi();
801068b0:	e8 f6 c5 ff ff       	call   80102eab <lapiceoi>
    break;
801068b5:	e9 23 01 00 00       	jmp    801069dd <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801068ba:	e8 97 03 00 00       	call   80106c56 <uartintr>
    lapiceoi();
801068bf:	e8 e7 c5 ff ff       	call   80102eab <lapiceoi>
    break;
801068c4:	e9 14 01 00 00       	jmp    801069dd <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068c9:	8b 45 08             	mov    0x8(%ebp),%eax
801068cc:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801068cf:	8b 45 08             	mov    0x8(%ebp),%eax
801068d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068d6:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801068d9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068df:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068e2:	0f b6 c0             	movzbl %al,%eax
801068e5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801068e9:	89 54 24 08          	mov    %edx,0x8(%esp)
801068ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801068f1:	c7 04 24 fc 89 10 80 	movl   $0x801089fc,(%esp)
801068f8:	e8 a3 9a ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801068fd:	e8 a9 c5 ff ff       	call   80102eab <lapiceoi>
    break;
80106902:	e9 d6 00 00 00       	jmp    801069dd <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106907:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010690d:	85 c0                	test   %eax,%eax
8010690f:	74 11                	je     80106922 <trap+0x13c>
80106911:	8b 45 08             	mov    0x8(%ebp),%eax
80106914:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106918:	0f b7 c0             	movzwl %ax,%eax
8010691b:	83 e0 03             	and    $0x3,%eax
8010691e:	85 c0                	test   %eax,%eax
80106920:	75 46                	jne    80106968 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106922:	e8 1e fd ff ff       	call   80106645 <rcr2>
80106927:	8b 55 08             	mov    0x8(%ebp),%edx
8010692a:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010692d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106934:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106937:	0f b6 ca             	movzbl %dl,%ecx
8010693a:	8b 55 08             	mov    0x8(%ebp),%edx
8010693d:	8b 52 30             	mov    0x30(%edx),%edx
80106940:	89 44 24 10          	mov    %eax,0x10(%esp)
80106944:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106948:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010694c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106950:	c7 04 24 20 8a 10 80 	movl   $0x80108a20,(%esp)
80106957:	e8 44 9a ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010695c:	c7 04 24 52 8a 10 80 	movl   $0x80108a52,(%esp)
80106963:	e8 d2 9b ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106968:	e8 d8 fc ff ff       	call   80106645 <rcr2>
8010696d:	89 c2                	mov    %eax,%edx
8010696f:	8b 45 08             	mov    0x8(%ebp),%eax
80106972:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106975:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010697b:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010697e:	0f b6 f0             	movzbl %al,%esi
80106981:	8b 45 08             	mov    0x8(%ebp),%eax
80106984:	8b 58 34             	mov    0x34(%eax),%ebx
80106987:	8b 45 08             	mov    0x8(%ebp),%eax
8010698a:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010698d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106993:	83 c0 6c             	add    $0x6c,%eax
80106996:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106999:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010699f:	8b 40 10             	mov    0x10(%eax),%eax
801069a2:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801069a6:	89 7c 24 18          	mov    %edi,0x18(%esp)
801069aa:	89 74 24 14          	mov    %esi,0x14(%esp)
801069ae:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801069b2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801069b6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801069b9:	89 74 24 08          	mov    %esi,0x8(%esp)
801069bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801069c1:	c7 04 24 58 8a 10 80 	movl   $0x80108a58,(%esp)
801069c8:	e8 d3 99 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801069cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801069da:	eb 01                	jmp    801069dd <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801069dc:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e3:	85 c0                	test   %eax,%eax
801069e5:	74 24                	je     80106a0b <trap+0x225>
801069e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ed:	8b 40 24             	mov    0x24(%eax),%eax
801069f0:	85 c0                	test   %eax,%eax
801069f2:	74 17                	je     80106a0b <trap+0x225>
801069f4:	8b 45 08             	mov    0x8(%ebp),%eax
801069f7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069fb:	0f b7 c0             	movzwl %ax,%eax
801069fe:	83 e0 03             	and    $0x3,%eax
80106a01:	83 f8 03             	cmp    $0x3,%eax
80106a04:	75 05                	jne    80106a0b <trap+0x225>
    exit();
80106a06:	e8 7f dc ff ff       	call   8010468a <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a11:	85 c0                	test   %eax,%eax
80106a13:	74 1e                	je     80106a33 <trap+0x24d>
80106a15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a1b:	8b 40 0c             	mov    0xc(%eax),%eax
80106a1e:	83 f8 04             	cmp    $0x4,%eax
80106a21:	75 10                	jne    80106a33 <trap+0x24d>
80106a23:	8b 45 08             	mov    0x8(%ebp),%eax
80106a26:	8b 40 30             	mov    0x30(%eax),%eax
80106a29:	83 f8 20             	cmp    $0x20,%eax
80106a2c:	75 05                	jne    80106a33 <trap+0x24d>
    yield();
80106a2e:	e8 d6 e0 ff ff       	call   80104b09 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a39:	85 c0                	test   %eax,%eax
80106a3b:	74 24                	je     80106a61 <trap+0x27b>
80106a3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a43:	8b 40 24             	mov    0x24(%eax),%eax
80106a46:	85 c0                	test   %eax,%eax
80106a48:	74 17                	je     80106a61 <trap+0x27b>
80106a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a51:	0f b7 c0             	movzwl %ax,%eax
80106a54:	83 e0 03             	and    $0x3,%eax
80106a57:	83 f8 03             	cmp    $0x3,%eax
80106a5a:	75 05                	jne    80106a61 <trap+0x27b>
    exit();
80106a5c:	e8 29 dc ff ff       	call   8010468a <exit>
}
80106a61:	83 c4 3c             	add    $0x3c,%esp
80106a64:	5b                   	pop    %ebx
80106a65:	5e                   	pop    %esi
80106a66:	5f                   	pop    %edi
80106a67:	5d                   	pop    %ebp
80106a68:	c3                   	ret    

80106a69 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106a69:	55                   	push   %ebp
80106a6a:	89 e5                	mov    %esp,%ebp
80106a6c:	83 ec 14             	sub    $0x14,%esp
80106a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a72:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a76:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106a7a:	89 c2                	mov    %eax,%edx
80106a7c:	ec                   	in     (%dx),%al
80106a7d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106a80:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106a84:	c9                   	leave  
80106a85:	c3                   	ret    

80106a86 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a86:	55                   	push   %ebp
80106a87:	89 e5                	mov    %esp,%ebp
80106a89:	83 ec 08             	sub    $0x8,%esp
80106a8c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a92:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a96:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a99:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a9d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106aa1:	ee                   	out    %al,(%dx)
}
80106aa2:	c9                   	leave  
80106aa3:	c3                   	ret    

80106aa4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106aa4:	55                   	push   %ebp
80106aa5:	89 e5                	mov    %esp,%ebp
80106aa7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106aaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ab1:	00 
80106ab2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ab9:	e8 c8 ff ff ff       	call   80106a86 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106abe:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106ac5:	00 
80106ac6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106acd:	e8 b4 ff ff ff       	call   80106a86 <outb>
  outb(COM1+0, 115200/9600);
80106ad2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106ad9:	00 
80106ada:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ae1:	e8 a0 ff ff ff       	call   80106a86 <outb>
  outb(COM1+1, 0);
80106ae6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106aed:	00 
80106aee:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106af5:	e8 8c ff ff ff       	call   80106a86 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106afa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b01:	00 
80106b02:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b09:	e8 78 ff ff ff       	call   80106a86 <outb>
  outb(COM1+4, 0);
80106b0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b15:	00 
80106b16:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106b1d:	e8 64 ff ff ff       	call   80106a86 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b22:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106b29:	00 
80106b2a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b31:	e8 50 ff ff ff       	call   80106a86 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b36:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b3d:	e8 27 ff ff ff       	call   80106a69 <inb>
80106b42:	3c ff                	cmp    $0xff,%al
80106b44:	75 02                	jne    80106b48 <uartinit+0xa4>
    return;
80106b46:	eb 6a                	jmp    80106bb2 <uartinit+0x10e>
  uart = 1;
80106b48:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106b4f:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b52:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b59:	e8 0b ff ff ff       	call   80106a69 <inb>
  inb(COM1+0);
80106b5e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b65:	e8 ff fe ff ff       	call   80106a69 <inb>
  picenable(IRQ_COM1);
80106b6a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106b71:	e8 e4 ce ff ff       	call   80103a5a <picenable>
  ioapicenable(IRQ_COM1, 0);
80106b76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b7d:	00 
80106b7e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106b85:	e8 cb bd ff ff       	call   80102955 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b8a:	c7 45 f4 1c 8b 10 80 	movl   $0x80108b1c,-0xc(%ebp)
80106b91:	eb 15                	jmp    80106ba8 <uartinit+0x104>
    uartputc(*p);
80106b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b96:	0f b6 00             	movzbl (%eax),%eax
80106b99:	0f be c0             	movsbl %al,%eax
80106b9c:	89 04 24             	mov    %eax,(%esp)
80106b9f:	e8 10 00 00 00       	call   80106bb4 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bab:	0f b6 00             	movzbl (%eax),%eax
80106bae:	84 c0                	test   %al,%al
80106bb0:	75 e1                	jne    80106b93 <uartinit+0xef>
    uartputc(*p);
}
80106bb2:	c9                   	leave  
80106bb3:	c3                   	ret    

80106bb4 <uartputc>:

void
uartputc(int c)
{
80106bb4:	55                   	push   %ebp
80106bb5:	89 e5                	mov    %esp,%ebp
80106bb7:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106bba:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106bbf:	85 c0                	test   %eax,%eax
80106bc1:	75 02                	jne    80106bc5 <uartputc+0x11>
    return;
80106bc3:	eb 4b                	jmp    80106c10 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106bcc:	eb 10                	jmp    80106bde <uartputc+0x2a>
    microdelay(10);
80106bce:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106bd5:	e8 f6 c2 ff ff       	call   80102ed0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bde:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106be2:	7f 16                	jg     80106bfa <uartputc+0x46>
80106be4:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106beb:	e8 79 fe ff ff       	call   80106a69 <inb>
80106bf0:	0f b6 c0             	movzbl %al,%eax
80106bf3:	83 e0 20             	and    $0x20,%eax
80106bf6:	85 c0                	test   %eax,%eax
80106bf8:	74 d4                	je     80106bce <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfd:	0f b6 c0             	movzbl %al,%eax
80106c00:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c04:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c0b:	e8 76 fe ff ff       	call   80106a86 <outb>
}
80106c10:	c9                   	leave  
80106c11:	c3                   	ret    

80106c12 <uartgetc>:

static int
uartgetc(void)
{
80106c12:	55                   	push   %ebp
80106c13:	89 e5                	mov    %esp,%ebp
80106c15:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106c18:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106c1d:	85 c0                	test   %eax,%eax
80106c1f:	75 07                	jne    80106c28 <uartgetc+0x16>
    return -1;
80106c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c26:	eb 2c                	jmp    80106c54 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106c28:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c2f:	e8 35 fe ff ff       	call   80106a69 <inb>
80106c34:	0f b6 c0             	movzbl %al,%eax
80106c37:	83 e0 01             	and    $0x1,%eax
80106c3a:	85 c0                	test   %eax,%eax
80106c3c:	75 07                	jne    80106c45 <uartgetc+0x33>
    return -1;
80106c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c43:	eb 0f                	jmp    80106c54 <uartgetc+0x42>
  return inb(COM1+0);
80106c45:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c4c:	e8 18 fe ff ff       	call   80106a69 <inb>
80106c51:	0f b6 c0             	movzbl %al,%eax
}
80106c54:	c9                   	leave  
80106c55:	c3                   	ret    

80106c56 <uartintr>:

void
uartintr(void)
{
80106c56:	55                   	push   %ebp
80106c57:	89 e5                	mov    %esp,%ebp
80106c59:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106c5c:	c7 04 24 12 6c 10 80 	movl   $0x80106c12,(%esp)
80106c63:	e8 45 9b ff ff       	call   801007ad <consoleintr>
}
80106c68:	c9                   	leave  
80106c69:	c3                   	ret    

80106c6a <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $0
80106c6c:	6a 00                	push   $0x0
  jmp alltraps
80106c6e:	e9 7e f9 ff ff       	jmp    801065f1 <alltraps>

80106c73 <vector1>:
.globl vector1
vector1:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $1
80106c75:	6a 01                	push   $0x1
  jmp alltraps
80106c77:	e9 75 f9 ff ff       	jmp    801065f1 <alltraps>

80106c7c <vector2>:
.globl vector2
vector2:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $2
80106c7e:	6a 02                	push   $0x2
  jmp alltraps
80106c80:	e9 6c f9 ff ff       	jmp    801065f1 <alltraps>

80106c85 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $3
80106c87:	6a 03                	push   $0x3
  jmp alltraps
80106c89:	e9 63 f9 ff ff       	jmp    801065f1 <alltraps>

80106c8e <vector4>:
.globl vector4
vector4:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $4
80106c90:	6a 04                	push   $0x4
  jmp alltraps
80106c92:	e9 5a f9 ff ff       	jmp    801065f1 <alltraps>

80106c97 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $5
80106c99:	6a 05                	push   $0x5
  jmp alltraps
80106c9b:	e9 51 f9 ff ff       	jmp    801065f1 <alltraps>

80106ca0 <vector6>:
.globl vector6
vector6:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $6
80106ca2:	6a 06                	push   $0x6
  jmp alltraps
80106ca4:	e9 48 f9 ff ff       	jmp    801065f1 <alltraps>

80106ca9 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $7
80106cab:	6a 07                	push   $0x7
  jmp alltraps
80106cad:	e9 3f f9 ff ff       	jmp    801065f1 <alltraps>

80106cb2 <vector8>:
.globl vector8
vector8:
  pushl $8
80106cb2:	6a 08                	push   $0x8
  jmp alltraps
80106cb4:	e9 38 f9 ff ff       	jmp    801065f1 <alltraps>

80106cb9 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $9
80106cbb:	6a 09                	push   $0x9
  jmp alltraps
80106cbd:	e9 2f f9 ff ff       	jmp    801065f1 <alltraps>

80106cc2 <vector10>:
.globl vector10
vector10:
  pushl $10
80106cc2:	6a 0a                	push   $0xa
  jmp alltraps
80106cc4:	e9 28 f9 ff ff       	jmp    801065f1 <alltraps>

80106cc9 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cc9:	6a 0b                	push   $0xb
  jmp alltraps
80106ccb:	e9 21 f9 ff ff       	jmp    801065f1 <alltraps>

80106cd0 <vector12>:
.globl vector12
vector12:
  pushl $12
80106cd0:	6a 0c                	push   $0xc
  jmp alltraps
80106cd2:	e9 1a f9 ff ff       	jmp    801065f1 <alltraps>

80106cd7 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cd7:	6a 0d                	push   $0xd
  jmp alltraps
80106cd9:	e9 13 f9 ff ff       	jmp    801065f1 <alltraps>

80106cde <vector14>:
.globl vector14
vector14:
  pushl $14
80106cde:	6a 0e                	push   $0xe
  jmp alltraps
80106ce0:	e9 0c f9 ff ff       	jmp    801065f1 <alltraps>

80106ce5 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $15
80106ce7:	6a 0f                	push   $0xf
  jmp alltraps
80106ce9:	e9 03 f9 ff ff       	jmp    801065f1 <alltraps>

80106cee <vector16>:
.globl vector16
vector16:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $16
80106cf0:	6a 10                	push   $0x10
  jmp alltraps
80106cf2:	e9 fa f8 ff ff       	jmp    801065f1 <alltraps>

80106cf7 <vector17>:
.globl vector17
vector17:
  pushl $17
80106cf7:	6a 11                	push   $0x11
  jmp alltraps
80106cf9:	e9 f3 f8 ff ff       	jmp    801065f1 <alltraps>

80106cfe <vector18>:
.globl vector18
vector18:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $18
80106d00:	6a 12                	push   $0x12
  jmp alltraps
80106d02:	e9 ea f8 ff ff       	jmp    801065f1 <alltraps>

80106d07 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $19
80106d09:	6a 13                	push   $0x13
  jmp alltraps
80106d0b:	e9 e1 f8 ff ff       	jmp    801065f1 <alltraps>

80106d10 <vector20>:
.globl vector20
vector20:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $20
80106d12:	6a 14                	push   $0x14
  jmp alltraps
80106d14:	e9 d8 f8 ff ff       	jmp    801065f1 <alltraps>

80106d19 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $21
80106d1b:	6a 15                	push   $0x15
  jmp alltraps
80106d1d:	e9 cf f8 ff ff       	jmp    801065f1 <alltraps>

80106d22 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $22
80106d24:	6a 16                	push   $0x16
  jmp alltraps
80106d26:	e9 c6 f8 ff ff       	jmp    801065f1 <alltraps>

80106d2b <vector23>:
.globl vector23
vector23:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $23
80106d2d:	6a 17                	push   $0x17
  jmp alltraps
80106d2f:	e9 bd f8 ff ff       	jmp    801065f1 <alltraps>

80106d34 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $24
80106d36:	6a 18                	push   $0x18
  jmp alltraps
80106d38:	e9 b4 f8 ff ff       	jmp    801065f1 <alltraps>

80106d3d <vector25>:
.globl vector25
vector25:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $25
80106d3f:	6a 19                	push   $0x19
  jmp alltraps
80106d41:	e9 ab f8 ff ff       	jmp    801065f1 <alltraps>

80106d46 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $26
80106d48:	6a 1a                	push   $0x1a
  jmp alltraps
80106d4a:	e9 a2 f8 ff ff       	jmp    801065f1 <alltraps>

80106d4f <vector27>:
.globl vector27
vector27:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $27
80106d51:	6a 1b                	push   $0x1b
  jmp alltraps
80106d53:	e9 99 f8 ff ff       	jmp    801065f1 <alltraps>

80106d58 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $28
80106d5a:	6a 1c                	push   $0x1c
  jmp alltraps
80106d5c:	e9 90 f8 ff ff       	jmp    801065f1 <alltraps>

80106d61 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $29
80106d63:	6a 1d                	push   $0x1d
  jmp alltraps
80106d65:	e9 87 f8 ff ff       	jmp    801065f1 <alltraps>

80106d6a <vector30>:
.globl vector30
vector30:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $30
80106d6c:	6a 1e                	push   $0x1e
  jmp alltraps
80106d6e:	e9 7e f8 ff ff       	jmp    801065f1 <alltraps>

80106d73 <vector31>:
.globl vector31
vector31:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $31
80106d75:	6a 1f                	push   $0x1f
  jmp alltraps
80106d77:	e9 75 f8 ff ff       	jmp    801065f1 <alltraps>

80106d7c <vector32>:
.globl vector32
vector32:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $32
80106d7e:	6a 20                	push   $0x20
  jmp alltraps
80106d80:	e9 6c f8 ff ff       	jmp    801065f1 <alltraps>

80106d85 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $33
80106d87:	6a 21                	push   $0x21
  jmp alltraps
80106d89:	e9 63 f8 ff ff       	jmp    801065f1 <alltraps>

80106d8e <vector34>:
.globl vector34
vector34:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $34
80106d90:	6a 22                	push   $0x22
  jmp alltraps
80106d92:	e9 5a f8 ff ff       	jmp    801065f1 <alltraps>

80106d97 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $35
80106d99:	6a 23                	push   $0x23
  jmp alltraps
80106d9b:	e9 51 f8 ff ff       	jmp    801065f1 <alltraps>

80106da0 <vector36>:
.globl vector36
vector36:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $36
80106da2:	6a 24                	push   $0x24
  jmp alltraps
80106da4:	e9 48 f8 ff ff       	jmp    801065f1 <alltraps>

80106da9 <vector37>:
.globl vector37
vector37:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $37
80106dab:	6a 25                	push   $0x25
  jmp alltraps
80106dad:	e9 3f f8 ff ff       	jmp    801065f1 <alltraps>

80106db2 <vector38>:
.globl vector38
vector38:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $38
80106db4:	6a 26                	push   $0x26
  jmp alltraps
80106db6:	e9 36 f8 ff ff       	jmp    801065f1 <alltraps>

80106dbb <vector39>:
.globl vector39
vector39:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $39
80106dbd:	6a 27                	push   $0x27
  jmp alltraps
80106dbf:	e9 2d f8 ff ff       	jmp    801065f1 <alltraps>

80106dc4 <vector40>:
.globl vector40
vector40:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $40
80106dc6:	6a 28                	push   $0x28
  jmp alltraps
80106dc8:	e9 24 f8 ff ff       	jmp    801065f1 <alltraps>

80106dcd <vector41>:
.globl vector41
vector41:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $41
80106dcf:	6a 29                	push   $0x29
  jmp alltraps
80106dd1:	e9 1b f8 ff ff       	jmp    801065f1 <alltraps>

80106dd6 <vector42>:
.globl vector42
vector42:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $42
80106dd8:	6a 2a                	push   $0x2a
  jmp alltraps
80106dda:	e9 12 f8 ff ff       	jmp    801065f1 <alltraps>

80106ddf <vector43>:
.globl vector43
vector43:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $43
80106de1:	6a 2b                	push   $0x2b
  jmp alltraps
80106de3:	e9 09 f8 ff ff       	jmp    801065f1 <alltraps>

80106de8 <vector44>:
.globl vector44
vector44:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $44
80106dea:	6a 2c                	push   $0x2c
  jmp alltraps
80106dec:	e9 00 f8 ff ff       	jmp    801065f1 <alltraps>

80106df1 <vector45>:
.globl vector45
vector45:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $45
80106df3:	6a 2d                	push   $0x2d
  jmp alltraps
80106df5:	e9 f7 f7 ff ff       	jmp    801065f1 <alltraps>

80106dfa <vector46>:
.globl vector46
vector46:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $46
80106dfc:	6a 2e                	push   $0x2e
  jmp alltraps
80106dfe:	e9 ee f7 ff ff       	jmp    801065f1 <alltraps>

80106e03 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $47
80106e05:	6a 2f                	push   $0x2f
  jmp alltraps
80106e07:	e9 e5 f7 ff ff       	jmp    801065f1 <alltraps>

80106e0c <vector48>:
.globl vector48
vector48:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $48
80106e0e:	6a 30                	push   $0x30
  jmp alltraps
80106e10:	e9 dc f7 ff ff       	jmp    801065f1 <alltraps>

80106e15 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $49
80106e17:	6a 31                	push   $0x31
  jmp alltraps
80106e19:	e9 d3 f7 ff ff       	jmp    801065f1 <alltraps>

80106e1e <vector50>:
.globl vector50
vector50:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $50
80106e20:	6a 32                	push   $0x32
  jmp alltraps
80106e22:	e9 ca f7 ff ff       	jmp    801065f1 <alltraps>

80106e27 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $51
80106e29:	6a 33                	push   $0x33
  jmp alltraps
80106e2b:	e9 c1 f7 ff ff       	jmp    801065f1 <alltraps>

80106e30 <vector52>:
.globl vector52
vector52:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $52
80106e32:	6a 34                	push   $0x34
  jmp alltraps
80106e34:	e9 b8 f7 ff ff       	jmp    801065f1 <alltraps>

80106e39 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $53
80106e3b:	6a 35                	push   $0x35
  jmp alltraps
80106e3d:	e9 af f7 ff ff       	jmp    801065f1 <alltraps>

80106e42 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $54
80106e44:	6a 36                	push   $0x36
  jmp alltraps
80106e46:	e9 a6 f7 ff ff       	jmp    801065f1 <alltraps>

80106e4b <vector55>:
.globl vector55
vector55:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $55
80106e4d:	6a 37                	push   $0x37
  jmp alltraps
80106e4f:	e9 9d f7 ff ff       	jmp    801065f1 <alltraps>

80106e54 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $56
80106e56:	6a 38                	push   $0x38
  jmp alltraps
80106e58:	e9 94 f7 ff ff       	jmp    801065f1 <alltraps>

80106e5d <vector57>:
.globl vector57
vector57:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $57
80106e5f:	6a 39                	push   $0x39
  jmp alltraps
80106e61:	e9 8b f7 ff ff       	jmp    801065f1 <alltraps>

80106e66 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $58
80106e68:	6a 3a                	push   $0x3a
  jmp alltraps
80106e6a:	e9 82 f7 ff ff       	jmp    801065f1 <alltraps>

80106e6f <vector59>:
.globl vector59
vector59:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $59
80106e71:	6a 3b                	push   $0x3b
  jmp alltraps
80106e73:	e9 79 f7 ff ff       	jmp    801065f1 <alltraps>

80106e78 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $60
80106e7a:	6a 3c                	push   $0x3c
  jmp alltraps
80106e7c:	e9 70 f7 ff ff       	jmp    801065f1 <alltraps>

80106e81 <vector61>:
.globl vector61
vector61:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $61
80106e83:	6a 3d                	push   $0x3d
  jmp alltraps
80106e85:	e9 67 f7 ff ff       	jmp    801065f1 <alltraps>

80106e8a <vector62>:
.globl vector62
vector62:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $62
80106e8c:	6a 3e                	push   $0x3e
  jmp alltraps
80106e8e:	e9 5e f7 ff ff       	jmp    801065f1 <alltraps>

80106e93 <vector63>:
.globl vector63
vector63:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $63
80106e95:	6a 3f                	push   $0x3f
  jmp alltraps
80106e97:	e9 55 f7 ff ff       	jmp    801065f1 <alltraps>

80106e9c <vector64>:
.globl vector64
vector64:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $64
80106e9e:	6a 40                	push   $0x40
  jmp alltraps
80106ea0:	e9 4c f7 ff ff       	jmp    801065f1 <alltraps>

80106ea5 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $65
80106ea7:	6a 41                	push   $0x41
  jmp alltraps
80106ea9:	e9 43 f7 ff ff       	jmp    801065f1 <alltraps>

80106eae <vector66>:
.globl vector66
vector66:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $66
80106eb0:	6a 42                	push   $0x42
  jmp alltraps
80106eb2:	e9 3a f7 ff ff       	jmp    801065f1 <alltraps>

80106eb7 <vector67>:
.globl vector67
vector67:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $67
80106eb9:	6a 43                	push   $0x43
  jmp alltraps
80106ebb:	e9 31 f7 ff ff       	jmp    801065f1 <alltraps>

80106ec0 <vector68>:
.globl vector68
vector68:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $68
80106ec2:	6a 44                	push   $0x44
  jmp alltraps
80106ec4:	e9 28 f7 ff ff       	jmp    801065f1 <alltraps>

80106ec9 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $69
80106ecb:	6a 45                	push   $0x45
  jmp alltraps
80106ecd:	e9 1f f7 ff ff       	jmp    801065f1 <alltraps>

80106ed2 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $70
80106ed4:	6a 46                	push   $0x46
  jmp alltraps
80106ed6:	e9 16 f7 ff ff       	jmp    801065f1 <alltraps>

80106edb <vector71>:
.globl vector71
vector71:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $71
80106edd:	6a 47                	push   $0x47
  jmp alltraps
80106edf:	e9 0d f7 ff ff       	jmp    801065f1 <alltraps>

80106ee4 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $72
80106ee6:	6a 48                	push   $0x48
  jmp alltraps
80106ee8:	e9 04 f7 ff ff       	jmp    801065f1 <alltraps>

80106eed <vector73>:
.globl vector73
vector73:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $73
80106eef:	6a 49                	push   $0x49
  jmp alltraps
80106ef1:	e9 fb f6 ff ff       	jmp    801065f1 <alltraps>

80106ef6 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $74
80106ef8:	6a 4a                	push   $0x4a
  jmp alltraps
80106efa:	e9 f2 f6 ff ff       	jmp    801065f1 <alltraps>

80106eff <vector75>:
.globl vector75
vector75:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $75
80106f01:	6a 4b                	push   $0x4b
  jmp alltraps
80106f03:	e9 e9 f6 ff ff       	jmp    801065f1 <alltraps>

80106f08 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $76
80106f0a:	6a 4c                	push   $0x4c
  jmp alltraps
80106f0c:	e9 e0 f6 ff ff       	jmp    801065f1 <alltraps>

80106f11 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $77
80106f13:	6a 4d                	push   $0x4d
  jmp alltraps
80106f15:	e9 d7 f6 ff ff       	jmp    801065f1 <alltraps>

80106f1a <vector78>:
.globl vector78
vector78:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $78
80106f1c:	6a 4e                	push   $0x4e
  jmp alltraps
80106f1e:	e9 ce f6 ff ff       	jmp    801065f1 <alltraps>

80106f23 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $79
80106f25:	6a 4f                	push   $0x4f
  jmp alltraps
80106f27:	e9 c5 f6 ff ff       	jmp    801065f1 <alltraps>

80106f2c <vector80>:
.globl vector80
vector80:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $80
80106f2e:	6a 50                	push   $0x50
  jmp alltraps
80106f30:	e9 bc f6 ff ff       	jmp    801065f1 <alltraps>

80106f35 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $81
80106f37:	6a 51                	push   $0x51
  jmp alltraps
80106f39:	e9 b3 f6 ff ff       	jmp    801065f1 <alltraps>

80106f3e <vector82>:
.globl vector82
vector82:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $82
80106f40:	6a 52                	push   $0x52
  jmp alltraps
80106f42:	e9 aa f6 ff ff       	jmp    801065f1 <alltraps>

80106f47 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $83
80106f49:	6a 53                	push   $0x53
  jmp alltraps
80106f4b:	e9 a1 f6 ff ff       	jmp    801065f1 <alltraps>

80106f50 <vector84>:
.globl vector84
vector84:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $84
80106f52:	6a 54                	push   $0x54
  jmp alltraps
80106f54:	e9 98 f6 ff ff       	jmp    801065f1 <alltraps>

80106f59 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $85
80106f5b:	6a 55                	push   $0x55
  jmp alltraps
80106f5d:	e9 8f f6 ff ff       	jmp    801065f1 <alltraps>

80106f62 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $86
80106f64:	6a 56                	push   $0x56
  jmp alltraps
80106f66:	e9 86 f6 ff ff       	jmp    801065f1 <alltraps>

80106f6b <vector87>:
.globl vector87
vector87:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $87
80106f6d:	6a 57                	push   $0x57
  jmp alltraps
80106f6f:	e9 7d f6 ff ff       	jmp    801065f1 <alltraps>

80106f74 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $88
80106f76:	6a 58                	push   $0x58
  jmp alltraps
80106f78:	e9 74 f6 ff ff       	jmp    801065f1 <alltraps>

80106f7d <vector89>:
.globl vector89
vector89:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $89
80106f7f:	6a 59                	push   $0x59
  jmp alltraps
80106f81:	e9 6b f6 ff ff       	jmp    801065f1 <alltraps>

80106f86 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $90
80106f88:	6a 5a                	push   $0x5a
  jmp alltraps
80106f8a:	e9 62 f6 ff ff       	jmp    801065f1 <alltraps>

80106f8f <vector91>:
.globl vector91
vector91:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $91
80106f91:	6a 5b                	push   $0x5b
  jmp alltraps
80106f93:	e9 59 f6 ff ff       	jmp    801065f1 <alltraps>

80106f98 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $92
80106f9a:	6a 5c                	push   $0x5c
  jmp alltraps
80106f9c:	e9 50 f6 ff ff       	jmp    801065f1 <alltraps>

80106fa1 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $93
80106fa3:	6a 5d                	push   $0x5d
  jmp alltraps
80106fa5:	e9 47 f6 ff ff       	jmp    801065f1 <alltraps>

80106faa <vector94>:
.globl vector94
vector94:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $94
80106fac:	6a 5e                	push   $0x5e
  jmp alltraps
80106fae:	e9 3e f6 ff ff       	jmp    801065f1 <alltraps>

80106fb3 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $95
80106fb5:	6a 5f                	push   $0x5f
  jmp alltraps
80106fb7:	e9 35 f6 ff ff       	jmp    801065f1 <alltraps>

80106fbc <vector96>:
.globl vector96
vector96:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $96
80106fbe:	6a 60                	push   $0x60
  jmp alltraps
80106fc0:	e9 2c f6 ff ff       	jmp    801065f1 <alltraps>

80106fc5 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $97
80106fc7:	6a 61                	push   $0x61
  jmp alltraps
80106fc9:	e9 23 f6 ff ff       	jmp    801065f1 <alltraps>

80106fce <vector98>:
.globl vector98
vector98:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $98
80106fd0:	6a 62                	push   $0x62
  jmp alltraps
80106fd2:	e9 1a f6 ff ff       	jmp    801065f1 <alltraps>

80106fd7 <vector99>:
.globl vector99
vector99:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $99
80106fd9:	6a 63                	push   $0x63
  jmp alltraps
80106fdb:	e9 11 f6 ff ff       	jmp    801065f1 <alltraps>

80106fe0 <vector100>:
.globl vector100
vector100:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $100
80106fe2:	6a 64                	push   $0x64
  jmp alltraps
80106fe4:	e9 08 f6 ff ff       	jmp    801065f1 <alltraps>

80106fe9 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $101
80106feb:	6a 65                	push   $0x65
  jmp alltraps
80106fed:	e9 ff f5 ff ff       	jmp    801065f1 <alltraps>

80106ff2 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $102
80106ff4:	6a 66                	push   $0x66
  jmp alltraps
80106ff6:	e9 f6 f5 ff ff       	jmp    801065f1 <alltraps>

80106ffb <vector103>:
.globl vector103
vector103:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $103
80106ffd:	6a 67                	push   $0x67
  jmp alltraps
80106fff:	e9 ed f5 ff ff       	jmp    801065f1 <alltraps>

80107004 <vector104>:
.globl vector104
vector104:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $104
80107006:	6a 68                	push   $0x68
  jmp alltraps
80107008:	e9 e4 f5 ff ff       	jmp    801065f1 <alltraps>

8010700d <vector105>:
.globl vector105
vector105:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $105
8010700f:	6a 69                	push   $0x69
  jmp alltraps
80107011:	e9 db f5 ff ff       	jmp    801065f1 <alltraps>

80107016 <vector106>:
.globl vector106
vector106:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $106
80107018:	6a 6a                	push   $0x6a
  jmp alltraps
8010701a:	e9 d2 f5 ff ff       	jmp    801065f1 <alltraps>

8010701f <vector107>:
.globl vector107
vector107:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $107
80107021:	6a 6b                	push   $0x6b
  jmp alltraps
80107023:	e9 c9 f5 ff ff       	jmp    801065f1 <alltraps>

80107028 <vector108>:
.globl vector108
vector108:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $108
8010702a:	6a 6c                	push   $0x6c
  jmp alltraps
8010702c:	e9 c0 f5 ff ff       	jmp    801065f1 <alltraps>

80107031 <vector109>:
.globl vector109
vector109:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $109
80107033:	6a 6d                	push   $0x6d
  jmp alltraps
80107035:	e9 b7 f5 ff ff       	jmp    801065f1 <alltraps>

8010703a <vector110>:
.globl vector110
vector110:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $110
8010703c:	6a 6e                	push   $0x6e
  jmp alltraps
8010703e:	e9 ae f5 ff ff       	jmp    801065f1 <alltraps>

80107043 <vector111>:
.globl vector111
vector111:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $111
80107045:	6a 6f                	push   $0x6f
  jmp alltraps
80107047:	e9 a5 f5 ff ff       	jmp    801065f1 <alltraps>

8010704c <vector112>:
.globl vector112
vector112:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $112
8010704e:	6a 70                	push   $0x70
  jmp alltraps
80107050:	e9 9c f5 ff ff       	jmp    801065f1 <alltraps>

80107055 <vector113>:
.globl vector113
vector113:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $113
80107057:	6a 71                	push   $0x71
  jmp alltraps
80107059:	e9 93 f5 ff ff       	jmp    801065f1 <alltraps>

8010705e <vector114>:
.globl vector114
vector114:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $114
80107060:	6a 72                	push   $0x72
  jmp alltraps
80107062:	e9 8a f5 ff ff       	jmp    801065f1 <alltraps>

80107067 <vector115>:
.globl vector115
vector115:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $115
80107069:	6a 73                	push   $0x73
  jmp alltraps
8010706b:	e9 81 f5 ff ff       	jmp    801065f1 <alltraps>

80107070 <vector116>:
.globl vector116
vector116:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $116
80107072:	6a 74                	push   $0x74
  jmp alltraps
80107074:	e9 78 f5 ff ff       	jmp    801065f1 <alltraps>

80107079 <vector117>:
.globl vector117
vector117:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $117
8010707b:	6a 75                	push   $0x75
  jmp alltraps
8010707d:	e9 6f f5 ff ff       	jmp    801065f1 <alltraps>

80107082 <vector118>:
.globl vector118
vector118:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $118
80107084:	6a 76                	push   $0x76
  jmp alltraps
80107086:	e9 66 f5 ff ff       	jmp    801065f1 <alltraps>

8010708b <vector119>:
.globl vector119
vector119:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $119
8010708d:	6a 77                	push   $0x77
  jmp alltraps
8010708f:	e9 5d f5 ff ff       	jmp    801065f1 <alltraps>

80107094 <vector120>:
.globl vector120
vector120:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $120
80107096:	6a 78                	push   $0x78
  jmp alltraps
80107098:	e9 54 f5 ff ff       	jmp    801065f1 <alltraps>

8010709d <vector121>:
.globl vector121
vector121:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $121
8010709f:	6a 79                	push   $0x79
  jmp alltraps
801070a1:	e9 4b f5 ff ff       	jmp    801065f1 <alltraps>

801070a6 <vector122>:
.globl vector122
vector122:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $122
801070a8:	6a 7a                	push   $0x7a
  jmp alltraps
801070aa:	e9 42 f5 ff ff       	jmp    801065f1 <alltraps>

801070af <vector123>:
.globl vector123
vector123:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $123
801070b1:	6a 7b                	push   $0x7b
  jmp alltraps
801070b3:	e9 39 f5 ff ff       	jmp    801065f1 <alltraps>

801070b8 <vector124>:
.globl vector124
vector124:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $124
801070ba:	6a 7c                	push   $0x7c
  jmp alltraps
801070bc:	e9 30 f5 ff ff       	jmp    801065f1 <alltraps>

801070c1 <vector125>:
.globl vector125
vector125:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $125
801070c3:	6a 7d                	push   $0x7d
  jmp alltraps
801070c5:	e9 27 f5 ff ff       	jmp    801065f1 <alltraps>

801070ca <vector126>:
.globl vector126
vector126:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $126
801070cc:	6a 7e                	push   $0x7e
  jmp alltraps
801070ce:	e9 1e f5 ff ff       	jmp    801065f1 <alltraps>

801070d3 <vector127>:
.globl vector127
vector127:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $127
801070d5:	6a 7f                	push   $0x7f
  jmp alltraps
801070d7:	e9 15 f5 ff ff       	jmp    801065f1 <alltraps>

801070dc <vector128>:
.globl vector128
vector128:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $128
801070de:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070e3:	e9 09 f5 ff ff       	jmp    801065f1 <alltraps>

801070e8 <vector129>:
.globl vector129
vector129:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $129
801070ea:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070ef:	e9 fd f4 ff ff       	jmp    801065f1 <alltraps>

801070f4 <vector130>:
.globl vector130
vector130:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $130
801070f6:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070fb:	e9 f1 f4 ff ff       	jmp    801065f1 <alltraps>

80107100 <vector131>:
.globl vector131
vector131:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $131
80107102:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107107:	e9 e5 f4 ff ff       	jmp    801065f1 <alltraps>

8010710c <vector132>:
.globl vector132
vector132:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $132
8010710e:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107113:	e9 d9 f4 ff ff       	jmp    801065f1 <alltraps>

80107118 <vector133>:
.globl vector133
vector133:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $133
8010711a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010711f:	e9 cd f4 ff ff       	jmp    801065f1 <alltraps>

80107124 <vector134>:
.globl vector134
vector134:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $134
80107126:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010712b:	e9 c1 f4 ff ff       	jmp    801065f1 <alltraps>

80107130 <vector135>:
.globl vector135
vector135:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $135
80107132:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107137:	e9 b5 f4 ff ff       	jmp    801065f1 <alltraps>

8010713c <vector136>:
.globl vector136
vector136:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $136
8010713e:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107143:	e9 a9 f4 ff ff       	jmp    801065f1 <alltraps>

80107148 <vector137>:
.globl vector137
vector137:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $137
8010714a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010714f:	e9 9d f4 ff ff       	jmp    801065f1 <alltraps>

80107154 <vector138>:
.globl vector138
vector138:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $138
80107156:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010715b:	e9 91 f4 ff ff       	jmp    801065f1 <alltraps>

80107160 <vector139>:
.globl vector139
vector139:
  pushl $0
80107160:	6a 00                	push   $0x0
  pushl $139
80107162:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107167:	e9 85 f4 ff ff       	jmp    801065f1 <alltraps>

8010716c <vector140>:
.globl vector140
vector140:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $140
8010716e:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107173:	e9 79 f4 ff ff       	jmp    801065f1 <alltraps>

80107178 <vector141>:
.globl vector141
vector141:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $141
8010717a:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010717f:	e9 6d f4 ff ff       	jmp    801065f1 <alltraps>

80107184 <vector142>:
.globl vector142
vector142:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $142
80107186:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010718b:	e9 61 f4 ff ff       	jmp    801065f1 <alltraps>

80107190 <vector143>:
.globl vector143
vector143:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $143
80107192:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107197:	e9 55 f4 ff ff       	jmp    801065f1 <alltraps>

8010719c <vector144>:
.globl vector144
vector144:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $144
8010719e:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071a3:	e9 49 f4 ff ff       	jmp    801065f1 <alltraps>

801071a8 <vector145>:
.globl vector145
vector145:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $145
801071aa:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071af:	e9 3d f4 ff ff       	jmp    801065f1 <alltraps>

801071b4 <vector146>:
.globl vector146
vector146:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $146
801071b6:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071bb:	e9 31 f4 ff ff       	jmp    801065f1 <alltraps>

801071c0 <vector147>:
.globl vector147
vector147:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $147
801071c2:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071c7:	e9 25 f4 ff ff       	jmp    801065f1 <alltraps>

801071cc <vector148>:
.globl vector148
vector148:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $148
801071ce:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071d3:	e9 19 f4 ff ff       	jmp    801065f1 <alltraps>

801071d8 <vector149>:
.globl vector149
vector149:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $149
801071da:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071df:	e9 0d f4 ff ff       	jmp    801065f1 <alltraps>

801071e4 <vector150>:
.globl vector150
vector150:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $150
801071e6:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071eb:	e9 01 f4 ff ff       	jmp    801065f1 <alltraps>

801071f0 <vector151>:
.globl vector151
vector151:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $151
801071f2:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071f7:	e9 f5 f3 ff ff       	jmp    801065f1 <alltraps>

801071fc <vector152>:
.globl vector152
vector152:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $152
801071fe:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107203:	e9 e9 f3 ff ff       	jmp    801065f1 <alltraps>

80107208 <vector153>:
.globl vector153
vector153:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $153
8010720a:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010720f:	e9 dd f3 ff ff       	jmp    801065f1 <alltraps>

80107214 <vector154>:
.globl vector154
vector154:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $154
80107216:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010721b:	e9 d1 f3 ff ff       	jmp    801065f1 <alltraps>

80107220 <vector155>:
.globl vector155
vector155:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $155
80107222:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107227:	e9 c5 f3 ff ff       	jmp    801065f1 <alltraps>

8010722c <vector156>:
.globl vector156
vector156:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $156
8010722e:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107233:	e9 b9 f3 ff ff       	jmp    801065f1 <alltraps>

80107238 <vector157>:
.globl vector157
vector157:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $157
8010723a:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010723f:	e9 ad f3 ff ff       	jmp    801065f1 <alltraps>

80107244 <vector158>:
.globl vector158
vector158:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $158
80107246:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010724b:	e9 a1 f3 ff ff       	jmp    801065f1 <alltraps>

80107250 <vector159>:
.globl vector159
vector159:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $159
80107252:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107257:	e9 95 f3 ff ff       	jmp    801065f1 <alltraps>

8010725c <vector160>:
.globl vector160
vector160:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $160
8010725e:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107263:	e9 89 f3 ff ff       	jmp    801065f1 <alltraps>

80107268 <vector161>:
.globl vector161
vector161:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $161
8010726a:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010726f:	e9 7d f3 ff ff       	jmp    801065f1 <alltraps>

80107274 <vector162>:
.globl vector162
vector162:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $162
80107276:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010727b:	e9 71 f3 ff ff       	jmp    801065f1 <alltraps>

80107280 <vector163>:
.globl vector163
vector163:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $163
80107282:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107287:	e9 65 f3 ff ff       	jmp    801065f1 <alltraps>

8010728c <vector164>:
.globl vector164
vector164:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $164
8010728e:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107293:	e9 59 f3 ff ff       	jmp    801065f1 <alltraps>

80107298 <vector165>:
.globl vector165
vector165:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $165
8010729a:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010729f:	e9 4d f3 ff ff       	jmp    801065f1 <alltraps>

801072a4 <vector166>:
.globl vector166
vector166:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $166
801072a6:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072ab:	e9 41 f3 ff ff       	jmp    801065f1 <alltraps>

801072b0 <vector167>:
.globl vector167
vector167:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $167
801072b2:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072b7:	e9 35 f3 ff ff       	jmp    801065f1 <alltraps>

801072bc <vector168>:
.globl vector168
vector168:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $168
801072be:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072c3:	e9 29 f3 ff ff       	jmp    801065f1 <alltraps>

801072c8 <vector169>:
.globl vector169
vector169:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $169
801072ca:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072cf:	e9 1d f3 ff ff       	jmp    801065f1 <alltraps>

801072d4 <vector170>:
.globl vector170
vector170:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $170
801072d6:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072db:	e9 11 f3 ff ff       	jmp    801065f1 <alltraps>

801072e0 <vector171>:
.globl vector171
vector171:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $171
801072e2:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072e7:	e9 05 f3 ff ff       	jmp    801065f1 <alltraps>

801072ec <vector172>:
.globl vector172
vector172:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $172
801072ee:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072f3:	e9 f9 f2 ff ff       	jmp    801065f1 <alltraps>

801072f8 <vector173>:
.globl vector173
vector173:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $173
801072fa:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072ff:	e9 ed f2 ff ff       	jmp    801065f1 <alltraps>

80107304 <vector174>:
.globl vector174
vector174:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $174
80107306:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010730b:	e9 e1 f2 ff ff       	jmp    801065f1 <alltraps>

80107310 <vector175>:
.globl vector175
vector175:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $175
80107312:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107317:	e9 d5 f2 ff ff       	jmp    801065f1 <alltraps>

8010731c <vector176>:
.globl vector176
vector176:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $176
8010731e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107323:	e9 c9 f2 ff ff       	jmp    801065f1 <alltraps>

80107328 <vector177>:
.globl vector177
vector177:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $177
8010732a:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010732f:	e9 bd f2 ff ff       	jmp    801065f1 <alltraps>

80107334 <vector178>:
.globl vector178
vector178:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $178
80107336:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010733b:	e9 b1 f2 ff ff       	jmp    801065f1 <alltraps>

80107340 <vector179>:
.globl vector179
vector179:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $179
80107342:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107347:	e9 a5 f2 ff ff       	jmp    801065f1 <alltraps>

8010734c <vector180>:
.globl vector180
vector180:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $180
8010734e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107353:	e9 99 f2 ff ff       	jmp    801065f1 <alltraps>

80107358 <vector181>:
.globl vector181
vector181:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $181
8010735a:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010735f:	e9 8d f2 ff ff       	jmp    801065f1 <alltraps>

80107364 <vector182>:
.globl vector182
vector182:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $182
80107366:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010736b:	e9 81 f2 ff ff       	jmp    801065f1 <alltraps>

80107370 <vector183>:
.globl vector183
vector183:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $183
80107372:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107377:	e9 75 f2 ff ff       	jmp    801065f1 <alltraps>

8010737c <vector184>:
.globl vector184
vector184:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $184
8010737e:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107383:	e9 69 f2 ff ff       	jmp    801065f1 <alltraps>

80107388 <vector185>:
.globl vector185
vector185:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $185
8010738a:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010738f:	e9 5d f2 ff ff       	jmp    801065f1 <alltraps>

80107394 <vector186>:
.globl vector186
vector186:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $186
80107396:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010739b:	e9 51 f2 ff ff       	jmp    801065f1 <alltraps>

801073a0 <vector187>:
.globl vector187
vector187:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $187
801073a2:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073a7:	e9 45 f2 ff ff       	jmp    801065f1 <alltraps>

801073ac <vector188>:
.globl vector188
vector188:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $188
801073ae:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073b3:	e9 39 f2 ff ff       	jmp    801065f1 <alltraps>

801073b8 <vector189>:
.globl vector189
vector189:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $189
801073ba:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073bf:	e9 2d f2 ff ff       	jmp    801065f1 <alltraps>

801073c4 <vector190>:
.globl vector190
vector190:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $190
801073c6:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073cb:	e9 21 f2 ff ff       	jmp    801065f1 <alltraps>

801073d0 <vector191>:
.globl vector191
vector191:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $191
801073d2:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073d7:	e9 15 f2 ff ff       	jmp    801065f1 <alltraps>

801073dc <vector192>:
.globl vector192
vector192:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $192
801073de:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073e3:	e9 09 f2 ff ff       	jmp    801065f1 <alltraps>

801073e8 <vector193>:
.globl vector193
vector193:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $193
801073ea:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073ef:	e9 fd f1 ff ff       	jmp    801065f1 <alltraps>

801073f4 <vector194>:
.globl vector194
vector194:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $194
801073f6:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073fb:	e9 f1 f1 ff ff       	jmp    801065f1 <alltraps>

80107400 <vector195>:
.globl vector195
vector195:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $195
80107402:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107407:	e9 e5 f1 ff ff       	jmp    801065f1 <alltraps>

8010740c <vector196>:
.globl vector196
vector196:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $196
8010740e:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107413:	e9 d9 f1 ff ff       	jmp    801065f1 <alltraps>

80107418 <vector197>:
.globl vector197
vector197:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $197
8010741a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010741f:	e9 cd f1 ff ff       	jmp    801065f1 <alltraps>

80107424 <vector198>:
.globl vector198
vector198:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $198
80107426:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010742b:	e9 c1 f1 ff ff       	jmp    801065f1 <alltraps>

80107430 <vector199>:
.globl vector199
vector199:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $199
80107432:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107437:	e9 b5 f1 ff ff       	jmp    801065f1 <alltraps>

8010743c <vector200>:
.globl vector200
vector200:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $200
8010743e:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107443:	e9 a9 f1 ff ff       	jmp    801065f1 <alltraps>

80107448 <vector201>:
.globl vector201
vector201:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $201
8010744a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010744f:	e9 9d f1 ff ff       	jmp    801065f1 <alltraps>

80107454 <vector202>:
.globl vector202
vector202:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $202
80107456:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010745b:	e9 91 f1 ff ff       	jmp    801065f1 <alltraps>

80107460 <vector203>:
.globl vector203
vector203:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $203
80107462:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107467:	e9 85 f1 ff ff       	jmp    801065f1 <alltraps>

8010746c <vector204>:
.globl vector204
vector204:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $204
8010746e:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107473:	e9 79 f1 ff ff       	jmp    801065f1 <alltraps>

80107478 <vector205>:
.globl vector205
vector205:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $205
8010747a:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010747f:	e9 6d f1 ff ff       	jmp    801065f1 <alltraps>

80107484 <vector206>:
.globl vector206
vector206:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $206
80107486:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010748b:	e9 61 f1 ff ff       	jmp    801065f1 <alltraps>

80107490 <vector207>:
.globl vector207
vector207:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $207
80107492:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107497:	e9 55 f1 ff ff       	jmp    801065f1 <alltraps>

8010749c <vector208>:
.globl vector208
vector208:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $208
8010749e:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074a3:	e9 49 f1 ff ff       	jmp    801065f1 <alltraps>

801074a8 <vector209>:
.globl vector209
vector209:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $209
801074aa:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074af:	e9 3d f1 ff ff       	jmp    801065f1 <alltraps>

801074b4 <vector210>:
.globl vector210
vector210:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $210
801074b6:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074bb:	e9 31 f1 ff ff       	jmp    801065f1 <alltraps>

801074c0 <vector211>:
.globl vector211
vector211:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $211
801074c2:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074c7:	e9 25 f1 ff ff       	jmp    801065f1 <alltraps>

801074cc <vector212>:
.globl vector212
vector212:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $212
801074ce:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074d3:	e9 19 f1 ff ff       	jmp    801065f1 <alltraps>

801074d8 <vector213>:
.globl vector213
vector213:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $213
801074da:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074df:	e9 0d f1 ff ff       	jmp    801065f1 <alltraps>

801074e4 <vector214>:
.globl vector214
vector214:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $214
801074e6:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074eb:	e9 01 f1 ff ff       	jmp    801065f1 <alltraps>

801074f0 <vector215>:
.globl vector215
vector215:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $215
801074f2:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074f7:	e9 f5 f0 ff ff       	jmp    801065f1 <alltraps>

801074fc <vector216>:
.globl vector216
vector216:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $216
801074fe:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107503:	e9 e9 f0 ff ff       	jmp    801065f1 <alltraps>

80107508 <vector217>:
.globl vector217
vector217:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $217
8010750a:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010750f:	e9 dd f0 ff ff       	jmp    801065f1 <alltraps>

80107514 <vector218>:
.globl vector218
vector218:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $218
80107516:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010751b:	e9 d1 f0 ff ff       	jmp    801065f1 <alltraps>

80107520 <vector219>:
.globl vector219
vector219:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $219
80107522:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107527:	e9 c5 f0 ff ff       	jmp    801065f1 <alltraps>

8010752c <vector220>:
.globl vector220
vector220:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $220
8010752e:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107533:	e9 b9 f0 ff ff       	jmp    801065f1 <alltraps>

80107538 <vector221>:
.globl vector221
vector221:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $221
8010753a:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010753f:	e9 ad f0 ff ff       	jmp    801065f1 <alltraps>

80107544 <vector222>:
.globl vector222
vector222:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $222
80107546:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010754b:	e9 a1 f0 ff ff       	jmp    801065f1 <alltraps>

80107550 <vector223>:
.globl vector223
vector223:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $223
80107552:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107557:	e9 95 f0 ff ff       	jmp    801065f1 <alltraps>

8010755c <vector224>:
.globl vector224
vector224:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $224
8010755e:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107563:	e9 89 f0 ff ff       	jmp    801065f1 <alltraps>

80107568 <vector225>:
.globl vector225
vector225:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $225
8010756a:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010756f:	e9 7d f0 ff ff       	jmp    801065f1 <alltraps>

80107574 <vector226>:
.globl vector226
vector226:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $226
80107576:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010757b:	e9 71 f0 ff ff       	jmp    801065f1 <alltraps>

80107580 <vector227>:
.globl vector227
vector227:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $227
80107582:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107587:	e9 65 f0 ff ff       	jmp    801065f1 <alltraps>

8010758c <vector228>:
.globl vector228
vector228:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $228
8010758e:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107593:	e9 59 f0 ff ff       	jmp    801065f1 <alltraps>

80107598 <vector229>:
.globl vector229
vector229:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $229
8010759a:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010759f:	e9 4d f0 ff ff       	jmp    801065f1 <alltraps>

801075a4 <vector230>:
.globl vector230
vector230:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $230
801075a6:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075ab:	e9 41 f0 ff ff       	jmp    801065f1 <alltraps>

801075b0 <vector231>:
.globl vector231
vector231:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $231
801075b2:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075b7:	e9 35 f0 ff ff       	jmp    801065f1 <alltraps>

801075bc <vector232>:
.globl vector232
vector232:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $232
801075be:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075c3:	e9 29 f0 ff ff       	jmp    801065f1 <alltraps>

801075c8 <vector233>:
.globl vector233
vector233:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $233
801075ca:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075cf:	e9 1d f0 ff ff       	jmp    801065f1 <alltraps>

801075d4 <vector234>:
.globl vector234
vector234:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $234
801075d6:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075db:	e9 11 f0 ff ff       	jmp    801065f1 <alltraps>

801075e0 <vector235>:
.globl vector235
vector235:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $235
801075e2:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075e7:	e9 05 f0 ff ff       	jmp    801065f1 <alltraps>

801075ec <vector236>:
.globl vector236
vector236:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $236
801075ee:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075f3:	e9 f9 ef ff ff       	jmp    801065f1 <alltraps>

801075f8 <vector237>:
.globl vector237
vector237:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $237
801075fa:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075ff:	e9 ed ef ff ff       	jmp    801065f1 <alltraps>

80107604 <vector238>:
.globl vector238
vector238:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $238
80107606:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010760b:	e9 e1 ef ff ff       	jmp    801065f1 <alltraps>

80107610 <vector239>:
.globl vector239
vector239:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $239
80107612:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107617:	e9 d5 ef ff ff       	jmp    801065f1 <alltraps>

8010761c <vector240>:
.globl vector240
vector240:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $240
8010761e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107623:	e9 c9 ef ff ff       	jmp    801065f1 <alltraps>

80107628 <vector241>:
.globl vector241
vector241:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $241
8010762a:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010762f:	e9 bd ef ff ff       	jmp    801065f1 <alltraps>

80107634 <vector242>:
.globl vector242
vector242:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $242
80107636:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010763b:	e9 b1 ef ff ff       	jmp    801065f1 <alltraps>

80107640 <vector243>:
.globl vector243
vector243:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $243
80107642:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107647:	e9 a5 ef ff ff       	jmp    801065f1 <alltraps>

8010764c <vector244>:
.globl vector244
vector244:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $244
8010764e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107653:	e9 99 ef ff ff       	jmp    801065f1 <alltraps>

80107658 <vector245>:
.globl vector245
vector245:
  pushl $0
80107658:	6a 00                	push   $0x0
  pushl $245
8010765a:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010765f:	e9 8d ef ff ff       	jmp    801065f1 <alltraps>

80107664 <vector246>:
.globl vector246
vector246:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $246
80107666:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010766b:	e9 81 ef ff ff       	jmp    801065f1 <alltraps>

80107670 <vector247>:
.globl vector247
vector247:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $247
80107672:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107677:	e9 75 ef ff ff       	jmp    801065f1 <alltraps>

8010767c <vector248>:
.globl vector248
vector248:
  pushl $0
8010767c:	6a 00                	push   $0x0
  pushl $248
8010767e:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107683:	e9 69 ef ff ff       	jmp    801065f1 <alltraps>

80107688 <vector249>:
.globl vector249
vector249:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $249
8010768a:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010768f:	e9 5d ef ff ff       	jmp    801065f1 <alltraps>

80107694 <vector250>:
.globl vector250
vector250:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $250
80107696:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010769b:	e9 51 ef ff ff       	jmp    801065f1 <alltraps>

801076a0 <vector251>:
.globl vector251
vector251:
  pushl $0
801076a0:	6a 00                	push   $0x0
  pushl $251
801076a2:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076a7:	e9 45 ef ff ff       	jmp    801065f1 <alltraps>

801076ac <vector252>:
.globl vector252
vector252:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $252
801076ae:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076b3:	e9 39 ef ff ff       	jmp    801065f1 <alltraps>

801076b8 <vector253>:
.globl vector253
vector253:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $253
801076ba:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076bf:	e9 2d ef ff ff       	jmp    801065f1 <alltraps>

801076c4 <vector254>:
.globl vector254
vector254:
  pushl $0
801076c4:	6a 00                	push   $0x0
  pushl $254
801076c6:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076cb:	e9 21 ef ff ff       	jmp    801065f1 <alltraps>

801076d0 <vector255>:
.globl vector255
vector255:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $255
801076d2:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076d7:	e9 15 ef ff ff       	jmp    801065f1 <alltraps>

801076dc <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801076dc:	55                   	push   %ebp
801076dd:	89 e5                	mov    %esp,%ebp
801076df:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801076e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801076e5:	83 e8 01             	sub    $0x1,%eax
801076e8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076ec:	8b 45 08             	mov    0x8(%ebp),%eax
801076ef:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076f3:	8b 45 08             	mov    0x8(%ebp),%eax
801076f6:	c1 e8 10             	shr    $0x10,%eax
801076f9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801076fd:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107700:	0f 01 10             	lgdtl  (%eax)
}
80107703:	c9                   	leave  
80107704:	c3                   	ret    

80107705 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107705:	55                   	push   %ebp
80107706:	89 e5                	mov    %esp,%ebp
80107708:	83 ec 04             	sub    $0x4,%esp
8010770b:	8b 45 08             	mov    0x8(%ebp),%eax
8010770e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107712:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107716:	0f 00 d8             	ltr    %ax
}
80107719:	c9                   	leave  
8010771a:	c3                   	ret    

8010771b <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010771b:	55                   	push   %ebp
8010771c:	89 e5                	mov    %esp,%ebp
8010771e:	83 ec 04             	sub    $0x4,%esp
80107721:	8b 45 08             	mov    0x8(%ebp),%eax
80107724:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107728:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010772c:	8e e8                	mov    %eax,%gs
}
8010772e:	c9                   	leave  
8010772f:	c3                   	ret    

80107730 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107733:	8b 45 08             	mov    0x8(%ebp),%eax
80107736:	0f 22 d8             	mov    %eax,%cr3
}
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    

8010773b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010773b:	55                   	push   %ebp
8010773c:	89 e5                	mov    %esp,%ebp
8010773e:	8b 45 08             	mov    0x8(%ebp),%eax
80107741:	05 00 00 00 80       	add    $0x80000000,%eax
80107746:	5d                   	pop    %ebp
80107747:	c3                   	ret    

80107748 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107748:	55                   	push   %ebp
80107749:	89 e5                	mov    %esp,%ebp
8010774b:	8b 45 08             	mov    0x8(%ebp),%eax
8010774e:	05 00 00 00 80       	add    $0x80000000,%eax
80107753:	5d                   	pop    %ebp
80107754:	c3                   	ret    

80107755 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107755:	55                   	push   %ebp
80107756:	89 e5                	mov    %esp,%ebp
80107758:	53                   	push   %ebx
80107759:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010775c:	e8 f2 b6 ff ff       	call   80102e53 <cpunum>
80107761:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107767:	05 40 f9 10 80       	add    $0x8010f940,%eax
8010776c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010776f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107772:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777b:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107784:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010778f:	83 e2 f0             	and    $0xfffffff0,%edx
80107792:	83 ca 0a             	or     $0xa,%edx
80107795:	88 50 7d             	mov    %dl,0x7d(%eax)
80107798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010779f:	83 ca 10             	or     $0x10,%edx
801077a2:	88 50 7d             	mov    %dl,0x7d(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077ac:	83 e2 9f             	and    $0xffffff9f,%edx
801077af:	88 50 7d             	mov    %dl,0x7d(%eax)
801077b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077b9:	83 ca 80             	or     $0xffffff80,%edx
801077bc:	88 50 7d             	mov    %dl,0x7d(%eax)
801077bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077c6:	83 ca 0f             	or     $0xf,%edx
801077c9:	88 50 7e             	mov    %dl,0x7e(%eax)
801077cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077d3:	83 e2 ef             	and    $0xffffffef,%edx
801077d6:	88 50 7e             	mov    %dl,0x7e(%eax)
801077d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077e0:	83 e2 df             	and    $0xffffffdf,%edx
801077e3:	88 50 7e             	mov    %dl,0x7e(%eax)
801077e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077ed:	83 ca 40             	or     $0x40,%edx
801077f0:	88 50 7e             	mov    %dl,0x7e(%eax)
801077f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077fa:	83 ca 80             	or     $0xffffff80,%edx
801077fd:	88 50 7e             	mov    %dl,0x7e(%eax)
80107800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107803:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107811:	ff ff 
80107813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107816:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010781d:	00 00 
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107833:	83 e2 f0             	and    $0xfffffff0,%edx
80107836:	83 ca 02             	or     $0x2,%edx
80107839:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010783f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107842:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107849:	83 ca 10             	or     $0x10,%edx
8010784c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107855:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010785c:	83 e2 9f             	and    $0xffffff9f,%edx
8010785f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107868:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010786f:	83 ca 80             	or     $0xffffff80,%edx
80107872:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107882:	83 ca 0f             	or     $0xf,%edx
80107885:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010788b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107895:	83 e2 ef             	and    $0xffffffef,%edx
80107898:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078a8:	83 e2 df             	and    $0xffffffdf,%edx
801078ab:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078bb:	83 ca 40             	or     $0x40,%edx
801078be:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078ce:	83 ca 80             	or     $0xffffff80,%edx
801078d1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078da:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e4:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801078eb:	ff ff 
801078ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f0:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801078f7:	00 00 
801078f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fc:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107906:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010790d:	83 e2 f0             	and    $0xfffffff0,%edx
80107910:	83 ca 0a             	or     $0xa,%edx
80107913:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107923:	83 ca 10             	or     $0x10,%edx
80107926:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010792c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107936:	83 ca 60             	or     $0x60,%edx
80107939:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010793f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107942:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107949:	83 ca 80             	or     $0xffffff80,%edx
8010794c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107955:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010795c:	83 ca 0f             	or     $0xf,%edx
8010795f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107968:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010796f:	83 e2 ef             	and    $0xffffffef,%edx
80107972:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107982:	83 e2 df             	and    $0xffffffdf,%edx
80107985:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010798b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107995:	83 ca 40             	or     $0x40,%edx
80107998:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010799e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079a8:	83 ca 80             	or     $0xffffff80,%edx
801079ab:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079be:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801079c5:	ff ff 
801079c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ca:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801079d1:	00 00 
801079d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d6:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801079dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801079e7:	83 e2 f0             	and    $0xfffffff0,%edx
801079ea:	83 ca 02             	or     $0x2,%edx
801079ed:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801079f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f6:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801079fd:	83 ca 10             	or     $0x10,%edx
80107a00:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a09:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a10:	83 ca 60             	or     $0x60,%edx
80107a13:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a23:	83 ca 80             	or     $0xffffff80,%edx
80107a26:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a36:	83 ca 0f             	or     $0xf,%edx
80107a39:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a42:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a49:	83 e2 ef             	and    $0xffffffef,%edx
80107a4c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a55:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a5c:	83 e2 df             	and    $0xffffffdf,%edx
80107a5f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a68:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a6f:	83 ca 40             	or     $0x40,%edx
80107a72:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a82:	83 ca 80             	or     $0xffffff80,%edx
80107a85:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a98:	05 b4 00 00 00       	add    $0xb4,%eax
80107a9d:	89 c3                	mov    %eax,%ebx
80107a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa2:	05 b4 00 00 00       	add    $0xb4,%eax
80107aa7:	c1 e8 10             	shr    $0x10,%eax
80107aaa:	89 c1                	mov    %eax,%ecx
80107aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aaf:	05 b4 00 00 00       	add    $0xb4,%eax
80107ab4:	c1 e8 18             	shr    $0x18,%eax
80107ab7:	89 c2                	mov    %eax,%edx
80107ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abc:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107ac3:	00 00 
80107ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac8:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adb:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107ae2:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ae5:	83 c9 02             	or     $0x2,%ecx
80107ae8:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107af8:	83 c9 10             	or     $0x10,%ecx
80107afb:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b04:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b0b:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b0e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b17:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b1e:	83 c9 80             	or     $0xffffff80,%ecx
80107b21:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b31:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b34:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3d:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b44:	83 e1 ef             	and    $0xffffffef,%ecx
80107b47:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b50:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b57:	83 e1 df             	and    $0xffffffdf,%ecx
80107b5a:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b63:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b6a:	83 c9 40             	or     $0x40,%ecx
80107b6d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b7d:	83 c9 80             	or     $0xffffff80,%ecx
80107b80:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b89:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	83 c0 70             	add    $0x70,%eax
80107b95:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107b9c:	00 
80107b9d:	89 04 24             	mov    %eax,(%esp)
80107ba0:	e8 37 fb ff ff       	call   801076dc <lgdt>
  loadgs(SEG_KCPU << 3);
80107ba5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107bac:	e8 6a fb ff ff       	call   8010771b <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb4:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107bba:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107bc1:	00 00 00 00 
}
80107bc5:	83 c4 24             	add    $0x24,%esp
80107bc8:	5b                   	pop    %ebx
80107bc9:	5d                   	pop    %ebp
80107bca:	c3                   	ret    

80107bcb <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107bcb:	55                   	push   %ebp
80107bcc:	89 e5                	mov    %esp,%ebp
80107bce:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd4:	c1 e8 16             	shr    $0x16,%eax
80107bd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bde:	8b 45 08             	mov    0x8(%ebp),%eax
80107be1:	01 d0                	add    %edx,%eax
80107be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be9:	8b 00                	mov    (%eax),%eax
80107beb:	83 e0 01             	and    $0x1,%eax
80107bee:	85 c0                	test   %eax,%eax
80107bf0:	74 17                	je     80107c09 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bf5:	8b 00                	mov    (%eax),%eax
80107bf7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bfc:	89 04 24             	mov    %eax,(%esp)
80107bff:	e8 44 fb ff ff       	call   80107748 <p2v>
80107c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c07:	eb 4b                	jmp    80107c54 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c0d:	74 0e                	je     80107c1d <walkpgdir+0x52>
80107c0f:	e8 c6 ae ff ff       	call   80102ada <kalloc>
80107c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c1b:	75 07                	jne    80107c24 <walkpgdir+0x59>
      return 0;
80107c1d:	b8 00 00 00 00       	mov    $0x0,%eax
80107c22:	eb 47                	jmp    80107c6b <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c2b:	00 
80107c2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c33:	00 
80107c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c37:	89 04 24             	mov    %eax,(%esp)
80107c3a:	e8 ed d4 ff ff       	call   8010512c <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c42:	89 04 24             	mov    %eax,(%esp)
80107c45:	e8 f1 fa ff ff       	call   8010773b <v2p>
80107c4a:	83 c8 07             	or     $0x7,%eax
80107c4d:	89 c2                	mov    %eax,%edx
80107c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c52:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c57:	c1 e8 0c             	shr    $0xc,%eax
80107c5a:	25 ff 03 00 00       	and    $0x3ff,%eax
80107c5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c69:	01 d0                	add    %edx,%eax
}
80107c6b:	c9                   	leave  
80107c6c:	c3                   	ret    

80107c6d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c6d:	55                   	push   %ebp
80107c6e:	89 e5                	mov    %esp,%ebp
80107c70:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107c73:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c81:	8b 45 10             	mov    0x10(%ebp),%eax
80107c84:	01 d0                	add    %edx,%eax
80107c86:	83 e8 01             	sub    $0x1,%eax
80107c89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c91:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107c98:	00 
80107c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca3:	89 04 24             	mov    %eax,(%esp)
80107ca6:	e8 20 ff ff ff       	call   80107bcb <walkpgdir>
80107cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cb2:	75 07                	jne    80107cbb <mappages+0x4e>
      return -1;
80107cb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cb9:	eb 48                	jmp    80107d03 <mappages+0x96>
    if(*pte & PTE_P)
80107cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cbe:	8b 00                	mov    (%eax),%eax
80107cc0:	83 e0 01             	and    $0x1,%eax
80107cc3:	85 c0                	test   %eax,%eax
80107cc5:	74 0c                	je     80107cd3 <mappages+0x66>
      panic("remap");
80107cc7:	c7 04 24 24 8b 10 80 	movl   $0x80108b24,(%esp)
80107cce:	e8 67 88 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107cd3:	8b 45 18             	mov    0x18(%ebp),%eax
80107cd6:	0b 45 14             	or     0x14(%ebp),%eax
80107cd9:	83 c8 01             	or     $0x1,%eax
80107cdc:	89 c2                	mov    %eax,%edx
80107cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ce1:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107ce9:	75 08                	jne    80107cf3 <mappages+0x86>
      break;
80107ceb:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107cec:	b8 00 00 00 00       	mov    $0x0,%eax
80107cf1:	eb 10                	jmp    80107d03 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107cf3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107cfa:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d01:	eb 8e                	jmp    80107c91 <mappages+0x24>
  return 0;
}
80107d03:	c9                   	leave  
80107d04:	c3                   	ret    

80107d05 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107d05:	55                   	push   %ebp
80107d06:	89 e5                	mov    %esp,%ebp
80107d08:	53                   	push   %ebx
80107d09:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d0c:	e8 c9 ad ff ff       	call   80102ada <kalloc>
80107d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d18:	75 0a                	jne    80107d24 <setupkvm+0x1f>
    return 0;
80107d1a:	b8 00 00 00 00       	mov    $0x0,%eax
80107d1f:	e9 98 00 00 00       	jmp    80107dbc <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107d24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d2b:	00 
80107d2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d33:	00 
80107d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d37:	89 04 24             	mov    %eax,(%esp)
80107d3a:	e8 ed d3 ff ff       	call   8010512c <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107d3f:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107d46:	e8 fd f9 ff ff       	call   80107748 <p2v>
80107d4b:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107d50:	76 0c                	jbe    80107d5e <setupkvm+0x59>
    panic("PHYSTOP too high");
80107d52:	c7 04 24 2a 8b 10 80 	movl   $0x80108b2a,(%esp)
80107d59:	e8 dc 87 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d5e:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107d65:	eb 49                	jmp    80107db0 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6a:	8b 48 0c             	mov    0xc(%eax),%ecx
80107d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d70:	8b 50 04             	mov    0x4(%eax),%edx
80107d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d76:	8b 58 08             	mov    0x8(%eax),%ebx
80107d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7c:	8b 40 04             	mov    0x4(%eax),%eax
80107d7f:	29 c3                	sub    %eax,%ebx
80107d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d84:	8b 00                	mov    (%eax),%eax
80107d86:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107d8a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d92:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d99:	89 04 24             	mov    %eax,(%esp)
80107d9c:	e8 cc fe ff ff       	call   80107c6d <mappages>
80107da1:	85 c0                	test   %eax,%eax
80107da3:	79 07                	jns    80107dac <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107da5:	b8 00 00 00 00       	mov    $0x0,%eax
80107daa:	eb 10                	jmp    80107dbc <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dac:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107db0:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107db7:	72 ae                	jb     80107d67 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107dbc:	83 c4 34             	add    $0x34,%esp
80107dbf:	5b                   	pop    %ebx
80107dc0:	5d                   	pop    %ebp
80107dc1:	c3                   	ret    

80107dc2 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107dc2:	55                   	push   %ebp
80107dc3:	89 e5                	mov    %esp,%ebp
80107dc5:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dc8:	e8 38 ff ff ff       	call   80107d05 <setupkvm>
80107dcd:	a3 18 29 11 80       	mov    %eax,0x80112918
  switchkvm();
80107dd2:	e8 02 00 00 00       	call   80107dd9 <switchkvm>
}
80107dd7:	c9                   	leave  
80107dd8:	c3                   	ret    

80107dd9 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107dd9:	55                   	push   %ebp
80107dda:	89 e5                	mov    %esp,%ebp
80107ddc:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107ddf:	a1 18 29 11 80       	mov    0x80112918,%eax
80107de4:	89 04 24             	mov    %eax,(%esp)
80107de7:	e8 4f f9 ff ff       	call   8010773b <v2p>
80107dec:	89 04 24             	mov    %eax,(%esp)
80107def:	e8 3c f9 ff ff       	call   80107730 <lcr3>
}
80107df4:	c9                   	leave  
80107df5:	c3                   	ret    

80107df6 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107df6:	55                   	push   %ebp
80107df7:	89 e5                	mov    %esp,%ebp
80107df9:	53                   	push   %ebx
80107dfa:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107dfd:	e8 2a d2 ff ff       	call   8010502c <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e02:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e08:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e0f:	83 c2 08             	add    $0x8,%edx
80107e12:	89 d3                	mov    %edx,%ebx
80107e14:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e1b:	83 c2 08             	add    $0x8,%edx
80107e1e:	c1 ea 10             	shr    $0x10,%edx
80107e21:	89 d1                	mov    %edx,%ecx
80107e23:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e2a:	83 c2 08             	add    $0x8,%edx
80107e2d:	c1 ea 18             	shr    $0x18,%edx
80107e30:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107e37:	67 00 
80107e39:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107e40:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107e46:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e4d:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e50:	83 c9 09             	or     $0x9,%ecx
80107e53:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e59:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e60:	83 c9 10             	or     $0x10,%ecx
80107e63:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e69:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e70:	83 e1 9f             	and    $0xffffff9f,%ecx
80107e73:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e79:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e80:	83 c9 80             	or     $0xffffff80,%ecx
80107e83:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e89:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107e90:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e93:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e99:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ea0:	83 e1 ef             	and    $0xffffffef,%ecx
80107ea3:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ea9:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107eb0:	83 e1 df             	and    $0xffffffdf,%ecx
80107eb3:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107eb9:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ec0:	83 c9 40             	or     $0x40,%ecx
80107ec3:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ec9:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ed0:	83 e1 7f             	and    $0x7f,%ecx
80107ed3:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ed9:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107edf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ee5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107eec:	83 e2 ef             	and    $0xffffffef,%edx
80107eef:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107ef5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107efb:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107f0e:	8b 52 08             	mov    0x8(%edx),%edx
80107f11:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f17:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f1a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107f21:	e8 df f7 ff ff       	call   80107705 <ltr>
  if(p->pgdir == 0)
80107f26:	8b 45 08             	mov    0x8(%ebp),%eax
80107f29:	8b 40 04             	mov    0x4(%eax),%eax
80107f2c:	85 c0                	test   %eax,%eax
80107f2e:	75 0c                	jne    80107f3c <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107f30:	c7 04 24 3b 8b 10 80 	movl   $0x80108b3b,(%esp)
80107f37:	e8 fe 85 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3f:	8b 40 04             	mov    0x4(%eax),%eax
80107f42:	89 04 24             	mov    %eax,(%esp)
80107f45:	e8 f1 f7 ff ff       	call   8010773b <v2p>
80107f4a:	89 04 24             	mov    %eax,(%esp)
80107f4d:	e8 de f7 ff ff       	call   80107730 <lcr3>
  popcli();
80107f52:	e8 19 d1 ff ff       	call   80105070 <popcli>
}
80107f57:	83 c4 14             	add    $0x14,%esp
80107f5a:	5b                   	pop    %ebx
80107f5b:	5d                   	pop    %ebp
80107f5c:	c3                   	ret    

80107f5d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107f5d:	55                   	push   %ebp
80107f5e:	89 e5                	mov    %esp,%ebp
80107f60:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107f63:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107f6a:	76 0c                	jbe    80107f78 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107f6c:	c7 04 24 4f 8b 10 80 	movl   $0x80108b4f,(%esp)
80107f73:	e8 c2 85 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107f78:	e8 5d ab ff ff       	call   80102ada <kalloc>
80107f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107f80:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f87:	00 
80107f88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f8f:	00 
80107f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f93:	89 04 24             	mov    %eax,(%esp)
80107f96:	e8 91 d1 ff ff       	call   8010512c <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9e:	89 04 24             	mov    %eax,(%esp)
80107fa1:	e8 95 f7 ff ff       	call   8010773b <v2p>
80107fa6:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107fad:	00 
80107fae:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107fb2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fb9:	00 
80107fba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fc1:	00 
80107fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc5:	89 04 24             	mov    %eax,(%esp)
80107fc8:	e8 a0 fc ff ff       	call   80107c6d <mappages>
  memmove(mem, init, sz);
80107fcd:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
80107fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fde:	89 04 24             	mov    %eax,(%esp)
80107fe1:	e8 15 d2 ff ff       	call   801051fb <memmove>
}
80107fe6:	c9                   	leave  
80107fe7:	c3                   	ret    

80107fe8 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107fe8:	55                   	push   %ebp
80107fe9:	89 e5                	mov    %esp,%ebp
80107feb:	53                   	push   %ebx
80107fec:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107fef:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ff2:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ff7:	85 c0                	test   %eax,%eax
80107ff9:	74 0c                	je     80108007 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107ffb:	c7 04 24 6c 8b 10 80 	movl   $0x80108b6c,(%esp)
80108002:	e8 33 85 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010800e:	e9 a9 00 00 00       	jmp    801080bc <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108016:	8b 55 0c             	mov    0xc(%ebp),%edx
80108019:	01 d0                	add    %edx,%eax
8010801b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108022:	00 
80108023:	89 44 24 04          	mov    %eax,0x4(%esp)
80108027:	8b 45 08             	mov    0x8(%ebp),%eax
8010802a:	89 04 24             	mov    %eax,(%esp)
8010802d:	e8 99 fb ff ff       	call   80107bcb <walkpgdir>
80108032:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108035:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108039:	75 0c                	jne    80108047 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010803b:	c7 04 24 8f 8b 10 80 	movl   $0x80108b8f,(%esp)
80108042:	e8 f3 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108047:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010804a:	8b 00                	mov    (%eax),%eax
8010804c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108051:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	8b 55 18             	mov    0x18(%ebp),%edx
8010805a:	29 c2                	sub    %eax,%edx
8010805c:	89 d0                	mov    %edx,%eax
8010805e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108063:	77 0f                	ja     80108074 <loaduvm+0x8c>
      n = sz - i;
80108065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108068:	8b 55 18             	mov    0x18(%ebp),%edx
8010806b:	29 c2                	sub    %eax,%edx
8010806d:	89 d0                	mov    %edx,%eax
8010806f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108072:	eb 07                	jmp    8010807b <loaduvm+0x93>
    else
      n = PGSIZE;
80108074:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010807b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807e:	8b 55 14             	mov    0x14(%ebp),%edx
80108081:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108084:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108087:	89 04 24             	mov    %eax,(%esp)
8010808a:	e8 b9 f6 ff ff       	call   80107748 <p2v>
8010808f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108092:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108096:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010809a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010809e:	8b 45 10             	mov    0x10(%ebp),%eax
801080a1:	89 04 24             	mov    %eax,(%esp)
801080a4:	e8 b7 9c ff ff       	call   80101d60 <readi>
801080a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801080ac:	74 07                	je     801080b5 <loaduvm+0xcd>
      return -1;
801080ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080b3:	eb 18                	jmp    801080cd <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801080b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bf:	3b 45 18             	cmp    0x18(%ebp),%eax
801080c2:	0f 82 4b ff ff ff    	jb     80108013 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801080c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080cd:	83 c4 24             	add    $0x24,%esp
801080d0:	5b                   	pop    %ebx
801080d1:	5d                   	pop    %ebp
801080d2:	c3                   	ret    

801080d3 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080d3:	55                   	push   %ebp
801080d4:	89 e5                	mov    %esp,%ebp
801080d6:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801080d9:	8b 45 10             	mov    0x10(%ebp),%eax
801080dc:	85 c0                	test   %eax,%eax
801080de:	79 0a                	jns    801080ea <allocuvm+0x17>
    return 0;
801080e0:	b8 00 00 00 00       	mov    $0x0,%eax
801080e5:	e9 c1 00 00 00       	jmp    801081ab <allocuvm+0xd8>
  if(newsz < oldsz)
801080ea:	8b 45 10             	mov    0x10(%ebp),%eax
801080ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080f0:	73 08                	jae    801080fa <allocuvm+0x27>
    return oldsz;
801080f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f5:	e9 b1 00 00 00       	jmp    801081ab <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801080fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801080fd:	05 ff 0f 00 00       	add    $0xfff,%eax
80108102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108107:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010810a:	e9 8d 00 00 00       	jmp    8010819c <allocuvm+0xc9>
    mem = kalloc();
8010810f:	e8 c6 a9 ff ff       	call   80102ada <kalloc>
80108114:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108117:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010811b:	75 2c                	jne    80108149 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
8010811d:	c7 04 24 ad 8b 10 80 	movl   $0x80108bad,(%esp)
80108124:	e8 77 82 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010812c:	89 44 24 08          	mov    %eax,0x8(%esp)
80108130:	8b 45 10             	mov    0x10(%ebp),%eax
80108133:	89 44 24 04          	mov    %eax,0x4(%esp)
80108137:	8b 45 08             	mov    0x8(%ebp),%eax
8010813a:	89 04 24             	mov    %eax,(%esp)
8010813d:	e8 6b 00 00 00       	call   801081ad <deallocuvm>
      return 0;
80108142:	b8 00 00 00 00       	mov    $0x0,%eax
80108147:	eb 62                	jmp    801081ab <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108149:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108150:	00 
80108151:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108158:	00 
80108159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815c:	89 04 24             	mov    %eax,(%esp)
8010815f:	e8 c8 cf ff ff       	call   8010512c <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108167:	89 04 24             	mov    %eax,(%esp)
8010816a:	e8 cc f5 ff ff       	call   8010773b <v2p>
8010816f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108172:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108179:	00 
8010817a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010817e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108185:	00 
80108186:	89 54 24 04          	mov    %edx,0x4(%esp)
8010818a:	8b 45 08             	mov    0x8(%ebp),%eax
8010818d:	89 04 24             	mov    %eax,(%esp)
80108190:	e8 d8 fa ff ff       	call   80107c6d <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108195:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010819c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819f:	3b 45 10             	cmp    0x10(%ebp),%eax
801081a2:	0f 82 67 ff ff ff    	jb     8010810f <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801081a8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081ab:	c9                   	leave  
801081ac:	c3                   	ret    

801081ad <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081ad:	55                   	push   %ebp
801081ae:	89 e5                	mov    %esp,%ebp
801081b0:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801081b3:	8b 45 10             	mov    0x10(%ebp),%eax
801081b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081b9:	72 08                	jb     801081c3 <deallocuvm+0x16>
    return oldsz;
801081bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801081be:	e9 a4 00 00 00       	jmp    80108267 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801081c3:	8b 45 10             	mov    0x10(%ebp),%eax
801081c6:	05 ff 0f 00 00       	add    $0xfff,%eax
801081cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801081d3:	e9 80 00 00 00       	jmp    80108258 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801081d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081e2:	00 
801081e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801081e7:	8b 45 08             	mov    0x8(%ebp),%eax
801081ea:	89 04 24             	mov    %eax,(%esp)
801081ed:	e8 d9 f9 ff ff       	call   80107bcb <walkpgdir>
801081f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801081f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081f9:	75 09                	jne    80108204 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801081fb:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108202:	eb 4d                	jmp    80108251 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108204:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108207:	8b 00                	mov    (%eax),%eax
80108209:	83 e0 01             	and    $0x1,%eax
8010820c:	85 c0                	test   %eax,%eax
8010820e:	74 41                	je     80108251 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108213:	8b 00                	mov    (%eax),%eax
80108215:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010821a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010821d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108221:	75 0c                	jne    8010822f <deallocuvm+0x82>
        panic("kfree");
80108223:	c7 04 24 c5 8b 10 80 	movl   $0x80108bc5,(%esp)
8010822a:	e8 0b 83 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
8010822f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108232:	89 04 24             	mov    %eax,(%esp)
80108235:	e8 0e f5 ff ff       	call   80107748 <p2v>
8010823a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010823d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108240:	89 04 24             	mov    %eax,(%esp)
80108243:	e8 f9 a7 ff ff       	call   80102a41 <kfree>
      *pte = 0;
80108248:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010824b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108251:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010825e:	0f 82 74 ff ff ff    	jb     801081d8 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108264:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108267:	c9                   	leave  
80108268:	c3                   	ret    

80108269 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108269:	55                   	push   %ebp
8010826a:	89 e5                	mov    %esp,%ebp
8010826c:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010826f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108273:	75 0c                	jne    80108281 <freevm+0x18>
    panic("freevm: no pgdir");
80108275:	c7 04 24 cb 8b 10 80 	movl   $0x80108bcb,(%esp)
8010827c:	e8 b9 82 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108281:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108288:	00 
80108289:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108290:	80 
80108291:	8b 45 08             	mov    0x8(%ebp),%eax
80108294:	89 04 24             	mov    %eax,(%esp)
80108297:	e8 11 ff ff ff       	call   801081ad <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010829c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082a3:	eb 48                	jmp    801082ed <freevm+0x84>
    if(pgdir[i] & PTE_P){
801082a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082af:	8b 45 08             	mov    0x8(%ebp),%eax
801082b2:	01 d0                	add    %edx,%eax
801082b4:	8b 00                	mov    (%eax),%eax
801082b6:	83 e0 01             	and    $0x1,%eax
801082b9:	85 c0                	test   %eax,%eax
801082bb:	74 2c                	je     801082e9 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801082bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082c7:	8b 45 08             	mov    0x8(%ebp),%eax
801082ca:	01 d0                	add    %edx,%eax
801082cc:	8b 00                	mov    (%eax),%eax
801082ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082d3:	89 04 24             	mov    %eax,(%esp)
801082d6:	e8 6d f4 ff ff       	call   80107748 <p2v>
801082db:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801082de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082e1:	89 04 24             	mov    %eax,(%esp)
801082e4:	e8 58 a7 ff ff       	call   80102a41 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801082e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ed:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801082f4:	76 af                	jbe    801082a5 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801082f6:	8b 45 08             	mov    0x8(%ebp),%eax
801082f9:	89 04 24             	mov    %eax,(%esp)
801082fc:	e8 40 a7 ff ff       	call   80102a41 <kfree>
}
80108301:	c9                   	leave  
80108302:	c3                   	ret    

80108303 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108303:	55                   	push   %ebp
80108304:	89 e5                	mov    %esp,%ebp
80108306:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108309:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108310:	00 
80108311:	8b 45 0c             	mov    0xc(%ebp),%eax
80108314:	89 44 24 04          	mov    %eax,0x4(%esp)
80108318:	8b 45 08             	mov    0x8(%ebp),%eax
8010831b:	89 04 24             	mov    %eax,(%esp)
8010831e:	e8 a8 f8 ff ff       	call   80107bcb <walkpgdir>
80108323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010832a:	75 0c                	jne    80108338 <clearpteu+0x35>
    panic("clearpteu");
8010832c:	c7 04 24 dc 8b 10 80 	movl   $0x80108bdc,(%esp)
80108333:	e8 02 82 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833b:	8b 00                	mov    (%eax),%eax
8010833d:	83 e0 fb             	and    $0xfffffffb,%eax
80108340:	89 c2                	mov    %eax,%edx
80108342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108345:	89 10                	mov    %edx,(%eax)
}
80108347:	c9                   	leave  
80108348:	c3                   	ret    

80108349 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108349:	55                   	push   %ebp
8010834a:	89 e5                	mov    %esp,%ebp
8010834c:	53                   	push   %ebx
8010834d:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108350:	e8 b0 f9 ff ff       	call   80107d05 <setupkvm>
80108355:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010835c:	75 0a                	jne    80108368 <copyuvm+0x1f>
    return 0;
8010835e:	b8 00 00 00 00       	mov    $0x0,%eax
80108363:	e9 fd 00 00 00       	jmp    80108465 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010836f:	e9 d0 00 00 00       	jmp    80108444 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108377:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010837e:	00 
8010837f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108383:	8b 45 08             	mov    0x8(%ebp),%eax
80108386:	89 04 24             	mov    %eax,(%esp)
80108389:	e8 3d f8 ff ff       	call   80107bcb <walkpgdir>
8010838e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108391:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108395:	75 0c                	jne    801083a3 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108397:	c7 04 24 e6 8b 10 80 	movl   $0x80108be6,(%esp)
8010839e:	e8 97 81 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801083a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083a6:	8b 00                	mov    (%eax),%eax
801083a8:	83 e0 01             	and    $0x1,%eax
801083ab:	85 c0                	test   %eax,%eax
801083ad:	75 0c                	jne    801083bb <copyuvm+0x72>
      panic("copyuvm: page not present");
801083af:	c7 04 24 00 8c 10 80 	movl   $0x80108c00,(%esp)
801083b6:	e8 7f 81 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801083bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083be:	8b 00                	mov    (%eax),%eax
801083c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801083c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083cb:	8b 00                	mov    (%eax),%eax
801083cd:	25 ff 0f 00 00       	and    $0xfff,%eax
801083d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801083d5:	e8 00 a7 ff ff       	call   80102ada <kalloc>
801083da:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801083e1:	75 02                	jne    801083e5 <copyuvm+0x9c>
      goto bad;
801083e3:	eb 70                	jmp    80108455 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
801083e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083e8:	89 04 24             	mov    %eax,(%esp)
801083eb:	e8 58 f3 ff ff       	call   80107748 <p2v>
801083f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083f7:	00 
801083f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801083fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083ff:	89 04 24             	mov    %eax,(%esp)
80108402:	e8 f4 cd ff ff       	call   801051fb <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108407:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010840a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010840d:	89 04 24             	mov    %eax,(%esp)
80108410:	e8 26 f3 ff ff       	call   8010773b <v2p>
80108415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108418:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010841c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108420:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108427:	00 
80108428:	89 54 24 04          	mov    %edx,0x4(%esp)
8010842c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010842f:	89 04 24             	mov    %eax,(%esp)
80108432:	e8 36 f8 ff ff       	call   80107c6d <mappages>
80108437:	85 c0                	test   %eax,%eax
80108439:	79 02                	jns    8010843d <copyuvm+0xf4>
      goto bad;
8010843b:	eb 18                	jmp    80108455 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010843d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108447:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010844a:	0f 82 24 ff ff ff    	jb     80108374 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108453:	eb 10                	jmp    80108465 <copyuvm+0x11c>

bad:
  freevm(d);
80108455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108458:	89 04 24             	mov    %eax,(%esp)
8010845b:	e8 09 fe ff ff       	call   80108269 <freevm>
  return 0;
80108460:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108465:	83 c4 44             	add    $0x44,%esp
80108468:	5b                   	pop    %ebx
80108469:	5d                   	pop    %ebp
8010846a:	c3                   	ret    

8010846b <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010846b:	55                   	push   %ebp
8010846c:	89 e5                	mov    %esp,%ebp
8010846e:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108471:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108478:	00 
80108479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108480:	8b 45 08             	mov    0x8(%ebp),%eax
80108483:	89 04 24             	mov    %eax,(%esp)
80108486:	e8 40 f7 ff ff       	call   80107bcb <walkpgdir>
8010848b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010848e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108491:	8b 00                	mov    (%eax),%eax
80108493:	83 e0 01             	and    $0x1,%eax
80108496:	85 c0                	test   %eax,%eax
80108498:	75 07                	jne    801084a1 <uva2ka+0x36>
    return 0;
8010849a:	b8 00 00 00 00       	mov    $0x0,%eax
8010849f:	eb 25                	jmp    801084c6 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801084a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a4:	8b 00                	mov    (%eax),%eax
801084a6:	83 e0 04             	and    $0x4,%eax
801084a9:	85 c0                	test   %eax,%eax
801084ab:	75 07                	jne    801084b4 <uva2ka+0x49>
    return 0;
801084ad:	b8 00 00 00 00       	mov    $0x0,%eax
801084b2:	eb 12                	jmp    801084c6 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801084b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b7:	8b 00                	mov    (%eax),%eax
801084b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084be:	89 04 24             	mov    %eax,(%esp)
801084c1:	e8 82 f2 ff ff       	call   80107748 <p2v>
}
801084c6:	c9                   	leave  
801084c7:	c3                   	ret    

801084c8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084c8:	55                   	push   %ebp
801084c9:	89 e5                	mov    %esp,%ebp
801084cb:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801084ce:	8b 45 10             	mov    0x10(%ebp),%eax
801084d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801084d4:	e9 87 00 00 00       	jmp    80108560 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801084d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801084eb:	8b 45 08             	mov    0x8(%ebp),%eax
801084ee:	89 04 24             	mov    %eax,(%esp)
801084f1:	e8 75 ff ff ff       	call   8010846b <uva2ka>
801084f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801084f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801084fd:	75 07                	jne    80108506 <copyout+0x3e>
      return -1;
801084ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108504:	eb 69                	jmp    8010856f <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108506:	8b 45 0c             	mov    0xc(%ebp),%eax
80108509:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010850c:	29 c2                	sub    %eax,%edx
8010850e:	89 d0                	mov    %edx,%eax
80108510:	05 00 10 00 00       	add    $0x1000,%eax
80108515:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010851b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010851e:	76 06                	jbe    80108526 <copyout+0x5e>
      n = len;
80108520:	8b 45 14             	mov    0x14(%ebp),%eax
80108523:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108526:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108529:	8b 55 0c             	mov    0xc(%ebp),%edx
8010852c:	29 c2                	sub    %eax,%edx
8010852e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108531:	01 c2                	add    %eax,%edx
80108533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108536:	89 44 24 08          	mov    %eax,0x8(%esp)
8010853a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108541:	89 14 24             	mov    %edx,(%esp)
80108544:	e8 b2 cc ff ff       	call   801051fb <memmove>
    len -= n;
80108549:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010854c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010854f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108552:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108558:	05 00 10 00 00       	add    $0x1000,%eax
8010855d:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108560:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108564:	0f 85 6f ff ff ff    	jne    801084d9 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010856a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010856f:	c9                   	leave  
80108570:	c3                   	ret    
