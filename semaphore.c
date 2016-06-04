//#include "types.h"
//#include "defs.h"
//#include "param.h"
//#include "x86.h"
//#include "memlayout.h"
//#include "mmu.h"
//#include "proc.h"

//#include "user.h"
#include "semaphore.h"

//void sem_init(struct semaphore *s, uint newVal) {
void sema_init(struct semaphore *s) {
  /*s->val = newVal;
  s->locked = 0;*/
  lock_init(&s->lock);
  s->count = 0;
  init_q(&s->q);
}
void sema_acquire(struct semaphore *s) {
  /*while(1) {
    while(xchg(&s->locked, 1) != 0);
    if (s->val > 0) {
          s->val--;
        break;
    }
    xchg(&s->locked, 0);
  }*/
  lock_acquire(&(s->lock));
  if(s->count <= 0){
      add_q(&(s->q),getpid());
      lock_release(&s->lock);
      tsleep();
  }else{
      s->count--;
      lock_release(&s->lock);
  }
}
void sema_signal(struct semaphore *s) {
  /*while(xchg(&s->locked, 1) ! = 0);
  s->val++;

  xchg(&s->locked, 0);*/
  lock_acquire(&s->lock);
  if(empty_q(&s->q)){
      s->count++;
  }else{
      int tid = pop_q(&s->q);
      twakeup(tid);
  }
  lock_release(&s->lock);
}
