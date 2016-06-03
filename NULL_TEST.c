#include "stdio.h"

int main(int argc, char *argv[]){
   int *point = NULL;
   *point = 5;
   //if(*point == 1)
   printf("NULL Deref");
   return 0;
}