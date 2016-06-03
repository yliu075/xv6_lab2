#include "types.h"
#include "stat.h"
#include "user.h"
/*
int main(int argc, char *argv[]){
   int *point = 0;
   *point = 5;
   //if(*point == 1)
   printf(1,"NULL Deref");
   return 0;
}
*/


int main()
{
    int *ptr = 0;
    printf(1, "Read byte at address 0: %p\n", *ptr);
    exit();
}
