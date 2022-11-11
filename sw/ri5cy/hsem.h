#ifndef _HSEM_H_
#define _HSEM_H_

#include <pulpino.h>

#define sem_0 REG(HSEM_BASE_ADDR + 0x0)
#define sem_1 REG(HSEM_BASE_ADDR + 0x4)
#define sem_2 REG(HSEM_BASE_ADDR + 0x8)
#define sem_3 REG(HSEM_BASE_ADDR + 0xc)
#define sem_4 REG(HSEM_BASE_ADDR + 0x10)
#define sem_5 REG(HSEM_BASE_ADDR + 0x14)
#define sem_6 REG(HSEM_BASE_ADDR + 0x18)
#define sem_7 REG(HSEM_BASE_ADDR + 0x1c)
#define intr_0 REG(HSEM_BASE_ADDR + 0x20)
#define intr_clr_0 REG(HSEM_BASE_ADDR + 0x24)
#define error_0 REG(HSEM_BASE_ADDR + 0x28)
#define err_clr_0 REG(HSEM_BASE_ADDR + 0x30)
#define sem_stat_0 REG(HSEM_BASE_ADDR + 0x34)
#define intr_1 REG(HSEM_BASE_ADDR + 0x38)
#define intr_clr_1 REG(HSEM_BASE_ADDR + 0x3c)
#define error_1 REG(HSEM_BASE_ADDR + 0x40)
#define err_clr_1 REG(HSEM_BASE_ADDR + 0x44)
#define sem_stat_1 REG(HSEM_BASE_ADDR + 0x48)
#define task REG(HSEM_BASE_ADDR + 0x4c)

#define CORE_0_ID 0xaa
#define CORE_1_ID 0xbb

#define SW_SET 0b1
#define ERROR 0b10
#define TASK 0b11

int hsem_stat(int core_id);
int hsem_check_lck(int sem_id, int sem_stat);
int hsem_check_rls(int sem_id, int sem_stat);
int hsem_try_lock(int sem_id, int core_id);
int hsem_try_rls(int sem_id, int core_id);
void hsem_intr_trig(int core_id);
int hsem_intr_stat(int core_id);
void hsem_intr_clear(int core_id);
int hsem_err_stat(int core_id);
void hsem_err_clear(int core_id);
void hsem_send_task(int task_code, int core_id);

#endif // _HSEM_H_