#include <hsem.h>

int hsem_stat(int core_id)
{
    int core_sem_stat; // core sem status
    // int sem_stat; // specific sem status
    if (core_id == CORE_0_ID)
    {
        core_sem_stat = *(volatile int *)(sem_stat_0);
    }
    else if (core_id == CORE_1_ID)
    {
        core_sem_stat = *(volatile int *)(sem_stat_1);
    }

    return core_sem_stat;
}
int hsem_check_lck(int sem_id, int sem_stat)
{
    int return_code;

    if (((sem_stat << (31 - sem_id)) >> 31) == 1)
    {
        return_code = 1;
    }
    else if (((sem_stat << (31 - sem_id)) >> 31) == 0)
    {
        return_code = 0;
    }

    return return_code;
}
int hsem_check_rls(int sem_id, int sem_stat)
{
    int return_code;

    if (((sem_stat << (31 - sem_id)) >> 31) == 0)
    {
        return_code = 1;
    }
    else if (((sem_stat << (31 - sem_id)) >> 31) == 1)
    {
        return_code = 0;
    }

    return return_code;
}
int hsem_try_lock(int sem_id, int core_id)
{
    int lock_code;
    // int read_sem;
    int sem_stat; // sem status of one core
    int return_code;

    lock_code = ((core_id << 8) | (0b1)); // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        *(volatile int *)(sem_0) = lock_code;
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
        *(volatile int *)(sem_1) = lock_code;
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
        *(volatile int *)(sem_2) = lock_code;

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
        *(volatile int *)(sem_3) = lock_code;

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
        *(volatile int *)(sem_4) = lock_code;

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
        *(volatile int *)(sem_5) = lock_code;

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
        *(volatile int *)(sem_6) = lock_code;

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
        *(volatile int *)(sem_7) = lock_code;

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
int hsem_try_rls(int sem_id, int core_id)
{
    int release_code;
    // int read_sem;
    int sem_stat; // sem status of one core
    int return_code;

    release_code = 0; // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        *(volatile int *)(sem_0) = release_code;
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
        *(volatile int *)(sem_1) = release_code;

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
        *(volatile int *)(sem_2) = release_code;

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
        *(volatile int *)(sem_3) = release_code;

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
        *(volatile int *)(sem_4) = release_code;

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
        *(volatile int *)(sem_5) = release_code;

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
        *(volatile int *)(sem_6) = release_code;

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
        *(volatile int *)(sem_7) = release_code;

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
void hsem_intr_trig(int core_id)
{
    if (core_id == CORE_0_ID)
    {
        *(volatile int *)(intr_0) = SW_SET;
    }
    else if (core_id == CORE_1_ID)
    {
        *(volatile int *)(intr_1) = SW_SET;
    }
}
int hsem_intr_stat(int core_id)
{
    int intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = *(volatile int *)(intr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = *(volatile int *)(intr_1);
    }

    return intr_stat;
}
void hsem_intr_clear(int core_id)
{
    int intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = *(volatile int *)(intr_clr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = *(volatile int *)(intr_clr_0);
    }
}
int hsem_err_stat(int core_id)
{
    int err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = *(volatile int *)(error_0);
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = *(volatile int *)(error_1);
    }

    return err_stat;
}
void hsem_err_clear(int core_id)
{
    int err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = *(volatile int *)(err_clr_0);
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = *(volatile int *)(err_clr_1);
    }
}
void hsem_send_task(int task_code, int core_id)
{
    *(volatile int *)(task) = task_code;

    if (core_id == CORE_0_ID)
    {
        *(volatile int *)(intr_0) = TASK;
    }
    else if (core_id == CORE_1_ID)
    {
        *(volatile int *)(intr_1) = TASK;
    }
}