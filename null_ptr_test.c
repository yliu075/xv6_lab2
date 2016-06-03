#include "types.h"
#include "stat.h"
#include "user.h"

int main()
{
    int *ptr = 0;
    printf(1, "DeRef addr %p = %p\n", ptr,(*ptr));
    return 0;
}
