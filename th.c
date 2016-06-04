#include "types.h"
#include "user.h"
#include "semaphore.c"

struct semaphore *h;
//struct semaphore *h2;
struct semaphore *o;

int water_molecules = 0;

void hReady(void *water);
void oReady(void *water);

int main(int argc, char *argv[]){

    printf(1,"Water Count: %d\n", water_molecules);
    sema_init(h);
    //sema_init(h2);
    sema_init(o);
    h->count = 1;
    o->count = 1;
    thread_create(hReady, (void *)&water_molecules);
    thread_create(hReady, (void *)&water_molecules);
    thread_create(oReady, (void *)&water_molecules);
    while(wait() >= 0){}
    //wait();
    //printf(1,"Waited 1\n");
    //thread_yield_last();
    //wait();
    //printf(1,"Waited 2\n");
    //thread_yield_last();
    //wait();
    //printf(1,"Waited 3\n");
    printf(1,"Water Count: %d\n", water_molecules);
    exit();
}


void ping(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    // while(1) {
        printf(1,"Ping %d \n",i);
        thread_yield2();
        //printf(1,"Pinged\n");
    }
    //printf(1,"Pinged ALL\n");
    texit();
}
void pong(void *arg_ptr){
    int i = 0;
    for (; i < 15 ; i++) {
    // while(1) {
        printf(1,"Pong %d \n",i);
        thread_yield2();
        //printf(1,"Ponged\n");
    }
    //printf(1,"Ponged ALL\n");
    texit();
}

void hReady(void *water) {
    //printf(1, "Added H\n");
    sema_signal(h);
    sema_acquire(o);
    //printf(1, "Exit H\n");
    texit();
}

void oReady(void *water) {
    //printf(1, "Added O\n");
    sema_acquire(h);
    //printf(1, "After H1\n");
    sema_acquire(h);
    //printf(1, "After H2\n");
    sema_signal(o);
    sema_signal(o);
    water_molecules++;
    printf(1, "H2O\n");
    //printf(1, "Exit O\n");
    texit();
}