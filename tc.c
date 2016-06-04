#include "types.h"
#include "user.h"
#include "semaphore.c"

struct semaphore *miss;
struct semaphore *cann;
struct semaphore *boat;

int missionary = 0;
int cannibal = 0;

void MissionaryArrives(void* m);
void CannibalArrives(void* c);
void RowBoat(void* b);

int main(int argc, char *argv[]) {
    
    sema_init(boat);
    boat->count = 1;
    sema_init(miss);
    sema_init(cann);
    thread_create(MissionaryArrives,(void*)1);
    thread_create(CannibalArrives,(void*)1);
    thread_create(MissionaryArrives,(void*)1);
    thread_create(MissionaryArrives,(void*)1);
    
    thread_create(RowBoat,(void*)1);
    while(wait() >= 0);
    exit();

}

void MissionaryArrives(void* m) {
    sema_signal(miss);
    missionary++;
    texit();
}

void CannibalArrives(void* c) {
    sema_signal(cann);
    cannibal++;
    texit();
}

void RowBoat(void* b) {
    sema_signal(boat);
    while (1) {
        if (missionary >= 3) {
            sema_acquire(miss);
            sema_acquire(miss);
            sema_acquire(miss);
            missionary -= 3;
            printf(1, "Boat sent with 3 missionaries\n");
            sema_acquire(boat);
        }
        else if ((missionary == 2) && (cannibal >= 1)) {
            sema_acquire(miss);
            sema_acquire(miss);
            sema_acquire(cann);
            missionary -= 2;
            cannibal--;
            printf(1, "Boat sent with 2 missionaries and 1 cannibal\n");
            sema_acquire(boat);
        }
        else if (cannibal >= 3) {
            sema_acquire(cann);
            sema_acquire(cann);
            sema_acquire(cann);
            cannibal -= 3;
            printf(1, "Boat sent with 3 cannibals\n");
            sema_acquire(boat);
        }
        else if (missionary == 2) {
            sema_acquire(miss);
            sema_acquire(miss);
            missionary -= 2;
            printf(1, "Boat sent with 2 missionaries\n");
            sema_acquire(boat);
        }
        else if (cannibal == 2) {
            sema_acquire(cann);
            sema_acquire(cann);
            cannibal -= 2;
            printf(1, "Boat sent with 2 cannibals\n");
            sema_acquire(boat);
        }
        else if (missionary == 1) {
            sema_acquire(miss);
            missionary--;
            printf(1, "Boat sent with 1 missionary\n");
            sema_acquire(boat);
        }
        else if (cannibal == 1) {
            sema_acquire(cann);
            cannibal--;
            printf(1, "Boat sent with 1 cannibal\n");
            sema_acquire(boat);
        }
        else texit();
    }
}
