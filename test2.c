#include "types.h"
#include "user.h"

int n = 1;

void test_func(void *arg_ptr);

int main(int argc, char *argv[]){


   int pid = fork();
    if(pid == 0){
        void *tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        while(wait()>=0);
        printf(1,"I am child, [6] n = %d\n",n);
    }else if(pid > 0){
        void *tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        tid = thread_create(test_func,(void *)0);
         if(tid == 0){
            printf(1,"thread_create fails\n");
            exit();
        }
        while(wait()>=0);
        printf(1,"I am parent, [5] n = %d\n",n);
    }

   exit();
}

void test_func(void *arg_ptr){
//    printf(1,"\n n = %d\n",n);
    n++;
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
}


