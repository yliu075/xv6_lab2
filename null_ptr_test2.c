#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   int *ptr = 0;
   *ptr = 10;
   printf(1,"Change val at NULL addr\n");
   return 0;
}

