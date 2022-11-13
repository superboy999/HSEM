#ifndef _HSEM_H_
#define _HSEM_H_

#include <pulpino.h>

#define sem_0       ( HSEM_BASE_ADDR + 0x0  )
#define sem_1       ( HSEM_BASE_ADDR + 0x4  )
#define sem_2       ( HSEM_BASE_ADDR + 0x8  )
#define sem_3       ( HSEM_BASE_ADDR + 0xc  )
#define sem_4       ( HSEM_BASE_ADDR + 0x10 )
#define sem_5       ( HSEM_BASE_ADDR + 0x14 )
#define sem_6       ( HSEM_BASE_ADDR + 0x18 )
#define sem_7       ( HSEM_BASE_ADDR + 0x1c )
#define intr_0      ( HSEM_BASE_ADDR + 0x20 )
#define intr_clr_0  ( HSEM_BASE_ADDR + 0x24 )
#define error_0     ( HSEM_BASE_ADDR + 0x28 )
#define err_clr_0   ( HSEM_BASE_ADDR + 0x2c )
#define sem_stat_0  ( HSEM_BASE_ADDR + 0x30 )
#define intr_1      ( HSEM_BASE_ADDR + 0x34 )
#define intr_clr_1  ( HSEM_BASE_ADDR + 0x38 )
#define error_1     ( HSEM_BASE_ADDR + 0x3c )
#define err_clr_1   ( HSEM_BASE_ADDR + 0x40 )
#define sem_stat_1  ( HSEM_BASE_ADDR + 0x44 )
#define task        ( HSEM_BASE_ADDR + 0x48 )

#define CORE_0_ID 0xaa
#define CORE_1_ID 0xbb

#define SW_SET 0b1
#define ERROR 0b10
#define TASK 0b11

    unsigned int hsem_stat( unsigned int core_id);
    unsigned int hsem_check_lck(unsigned int sem_id, unsigned int sem_stat);
    unsigned int hsem_check_rls(unsigned int sem_id, unsigned int sem_stat);
    unsigned int hsem_try_lock(unsigned int sem_id, unsigned int core_id);
    unsigned int hsem_try_rls(unsigned int sem_id, unsigned int core_id);
    void hsem_intr_trig(unsigned int core_id);
    unsigned int hsem_intr_stat(unsigned int core_id);
    void hsem_intr_clear(unsigned int core_id);
    unsigned int hsem_err_stat(unsigned int core_id);
    void hsem_err_clear(unsigned int core_id);
    void hsem_send_task(unsigned int task_code, unsigned int core_id);

#endif // _HSEM_H_