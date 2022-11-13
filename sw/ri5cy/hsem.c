#include <hsem.h>

unsigned int hsem_stat( unsigned int core_id)
{
    unsigned int core_sem_stat; // core sem status
    // unsigned int sem_stat; // specific sem status
    if (core_id == CORE_0_ID)
    {
        core_sem_stat = *(volatile unsigned int*) (sem_stat_0);
    }
    else if (core_id == CORE_1_ID)
    {
        core_sem_stat = *(volatile unsigned int*) (sem_stat_1);
    }

    return core_sem_stat;
}
unsigned int hsem_check_lck(unsigned int sem_id, unsigned int sem_stat)
{
    unsigned int return_code;
    unsigned int result;
    result = ((sem_stat << (31 - sem_id)) >> 31);
    printf("\n=====check lock=====\n");
    if (result == 1)
    {
        printf("\nlock success\n");
        return_code = 1;
    }
    else if (result == 0)
    {
        printf("\nlock failed\n");
        return_code = 0;
    }

    return return_code;
}
unsigned int hsem_check_rls(unsigned int sem_id, unsigned int sem_stat)
{
    unsigned int return_code;

    unsigned int result;
    result = ((sem_stat << (31 - sem_id)) >> 31);
    printf("\n=====check release=====\n");
    if (result == 0)
    {
        printf("\nrelease success\n");
        return_code = 1;
    }
    else if (result == 1)
    {
        printf("\nrelease failed\n");
        return_code = 0;
    }

    return return_code;
}
unsigned int hsem_try_lock(unsigned int sem_id, unsigned int core_id)
{
    unsigned int lock_code;
    // unsigned int read_sem;
    unsigned int sem_stat; // sem status of one core
    unsigned int return_code;
    printf("\n=====try lock=====\n");
    lock_code = ((core_id << 8) | (0b1)); // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        *(volatile unsigned int*) (sem_0) = lock_code;
        // read_sem = hsem->sem_0;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(0, sem_stat);
    }
    else if (sem_id == 1)
    {
        *(volatile unsigned int*) (sem_1) = lock_code;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(1, sem_stat);
    }
    else if (sem_id == 2)
    {
        *(volatile unsigned int*) (sem_2) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(2, sem_stat);
    }
    else if (sem_id == 3)
    {
        *(volatile unsigned int*) (sem_3) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(3, sem_stat);
    }
    else if (sem_id == 4)
    {
        *(volatile unsigned int*) (sem_4) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(4, sem_stat);
    }
    else if (sem_id == 5)
    {
        *(volatile unsigned int*) (sem_5) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(5, sem_stat);
    }
    else if (sem_id == 6)
    {
        *(volatile unsigned int*) (sem_6) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(6, sem_stat);
    }
    else if (sem_id == 7)
    {
        *(volatile unsigned int*) (sem_7) = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_lck(7, sem_stat);
    }

    return return_code;
}
unsigned int hsem_try_rls(unsigned int sem_id, unsigned int core_id)
{
    unsigned int release_code;
    // unsigned int read_sem;
    unsigned int sem_stat; // sem status of one core
    unsigned int return_code;

    release_code = ((core_id << 8) | (0b0));; // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        *(volatile unsigned int*) (sem_0) = release_code;
        // read_sem = hsem->sem_0;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(0, sem_stat);
    }
    else if (sem_id == 1)
    {
        *(volatile unsigned int*) (sem_1) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(1, sem_stat);
    }
    else if (sem_id == 2)
    {
        *(volatile unsigned int*) (sem_2) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(2, sem_stat);
    }
    else if (sem_id == 3)
    {
        *(volatile unsigned int*) (sem_3) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(3, sem_stat);
    }
    else if (sem_id == 4)
    {
        *(volatile unsigned int*) (sem_4) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(4, sem_stat);
    }
    else if (sem_id == 5)
    {
        *(volatile unsigned int*) (sem_5) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(5, sem_stat);
    }
    else if (sem_id == 6)
    {
        *(volatile unsigned int*) (sem_6) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(6, sem_stat);
    }
    else if (sem_id == 7)
    {
        *(volatile unsigned int*) (sem_7) = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(CORE_1_ID);
        }
        return_code = hsem_check_rls(7, sem_stat);
    }

    return return_code;
}
void hsem_intr_trig(unsigned int core_id)
{
    if (core_id == CORE_0_ID)
    {
        *(volatile unsigned int*) (intr_0) = SW_SET;
    }
    else if (core_id == CORE_1_ID)
    {
        *(volatile unsigned int*) (intr_1) = SW_SET;
    }
}
unsigned int hsem_intr_stat(unsigned int core_id)
{
    unsigned int intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = *(volatile unsigned int*) (intr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = *(volatile unsigned int*) (intr_1);
    }

    return intr_stat;
}
void hsem_intr_clear(unsigned int core_id)
{
    unsigned int intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = *(volatile unsigned int*) (intr_clr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = *(volatile unsigned int*) (intr_clr_1);
    }
}
unsigned int hsem_err_stat(unsigned int core_id)
{
    unsigned int err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = *(volatile unsigned int*) (error_0);
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = *(volatile unsigned int*) (error_1);
    }

    return err_stat;
}
void hsem_err_clear(unsigned int core_id)
{
    unsigned int err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = *(volatile unsigned int*) (err_clr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = *(volatile unsigned int*) (err_clr_1);
    }
}
void hsem_send_task(unsigned int task_code, unsigned int core_id)
{
    *(volatile unsigned int*) (task) = task_code;

    if (core_id == CORE_0_ID)
    {
        *(volatile unsigned int*) (intr_0) = TASK;
    }
    else if (core_id == CORE_1_ID)
    {
        *(volatile unsigned int*) (intr_1) = TASK;
    }
}