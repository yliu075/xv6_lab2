#include "types.h"
#include "user.h"

int n = 1;

void test_func(void *arg_ptr);
void ping(void *arg_ptr);
void pong(void *arg_ptr);

int main(int argc, char *argv[]){
   int arg = 10;
   void *tid = thread_create(ping, (void *)&arg);
   if(tid <= 0){
       printf(1,"wrong happen");
       exit();
   } 
   tid = thread_create(pong, (void *)&arg);
   if(tid <= 0){
       printf(1,"wrong happen");
       exit();
   } 
   exit();
}

void test_func(void *arg_ptr){
//    printf(1,"\n n = %d\n",n);
    n++;
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
}

void ping(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
    // while(1) {
        printf(1,"Ping %d %d \n",*num, i);
        thread_yield();
        printf(1,"Pinged\n");
    }
}
void pong(void *arg_ptr){
    int * num = (int *)arg_ptr;
    n = *num; 
    int i = 0;
    for (; i < 10 ; i++) {
    // while(1) {
        printf(1,"Pong %d %d \n",*num, i);
        thread_yield();
        printf(1,"Ponged\n");
    }
}