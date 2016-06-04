#include "types.h"
#include "user.h"
#include "semaphore.c"

struct semaphore *tree;
int dominantMonkey = 0;

void Monkey(void* m);
void domMonkey(void* m);

void part_a() {
    int i = 0;
    for(; i < 10; i++) {
        thread_create(Monkey,(void*)i);
    }
    while(wait() >= 0);
}

void part_c() {
    int i = 0;
    for(; i < 5; i++) {
        thread_create(Monkey,(void*)i);
    }
    thread_create(domMonkey,(void*)1);
    for(; i < 10; i++) {
        thread_create(Monkey,(void*)i);
    }
    while(wait() >= 0);
}   

int main(int argc, char *argv[]){
    
    sema_init(tree);
    tree->count = 3;
    printf(1,"\n*****Part a*****\n\n");
    part_a();
    printf(1,"\n*****Part c*****\n\n");
    part_c();
    printf(1,"\n");
    exit();

}


void Monkey(void* m) {
    int num = (int)m;
    while(dominantMonkey != 0){}
    sema_acquire(tree);
    //printf(1,"Monkey acq Count: %d\n", tree->count);
    printf(1,"Monkey #%d UP\n", num);
    int i = 0;
    int coconutTimer = random(99999) + 500000;
    for(;i < coconutTimer; i++){}
    printf(1,"Monkey $%d DOWN\n",num);
    sema_signal(tree);
    //printf(1,"Monkey sig Count: %d\n", tree->count);
    
    texit();
}

void domMonkey(void* m) {
    dominantMonkey++;
    sema_acquire(tree);
    //printf(1,"Monkey acq Count: %d\n", tree->count);
    printf(1,"Dominant Monkey UP\n");
    int i = 0;
    int coconutTimer = random(99999) + 500000;
    for(;i < coconutTimer; i++){}
    printf(1,"Dominant Monkey DOWN\n");
    sema_signal(tree);
    dominantMonkey--;
    //printf(1,"Monkey sig Count: %d\n", tree->count);
    texit();
}
