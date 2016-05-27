//#include "types.h"
#include "queue.h"
//#include "thread.c"
//#include "user.h"
struct semaphore {
  /*uint val = 0;
  uint locked = 0;*/
  lock_t lock;
  int count;
  struct queue q;
};
