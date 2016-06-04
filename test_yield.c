#include "types.h"
#include "user.h"

void ping(void *arg_ptr);
void pong(void *arg_ptr);

int main(int argc, char *argv[]){

    int arg = 10;
    
    //thread_create(ping, (void *)&arg);
    //thread_create(pong, (void *)&arg);
    
    void *tid = thread_create(ping, (void *)&arg);
    //printf(1,"Thread Created 1\n");
    if(tid <= 0){
        printf(1,"wrong happen\n");
        exit();
    } 
    tid = thread_create(pong, (void *)&arg);
    //printf(1,"Thread Created 2\n");
    if(tid <= 0){
        printf(1,"wrong happen\n");
        exit();
    } 
    
    
    //printf(1,"Going to Wait\n");
    wait();
    //printf(1,"Waited 1st Thread\n");
    thread_yield_last();
    wait();
    //printf(1,"Waited 2nd Thread\n");
    
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
