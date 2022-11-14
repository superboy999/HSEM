#include "hbirdv2.h"
#include "hbirdv2_hsem.h"

uint32_t hsem_stat(HSEM_TypeDef *hsem, uint32_t core_id)
{
    if (__RARELY(hsem == NULL))
    {
        return -1;
    }
    uint32_t core_sem_stat; // core sem status
    // uint32_t sem_stat; // specific sem status
    if (core_id == CORE_0_ID)
    {
        core_sem_stat = hsem->sem_stat_0;
    }
    else if (core_id == CORE_1_ID)
    {
        core_sem_stat = hsem->sem_stat_1;
    }

    return core_sem_stat;
}

uint32_t hsem_check_lck(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t sem_stat) // the return value of this func: 1 means lock success, 0 means lock failed.
{
    if (__RARELY(hsem == NULL))
    {
        return -1;
    }
    uint32_t return_code;

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

uint32_t hsem_check_rls(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t sem_stat) // the return value of this func: 1 means release success, 0 means release failed.
{
    if (__RARELY(hsem == NULL))
    {
        return -1;
    }
    uint32_t return_code;

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

uint32_t hsem_try_lock(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t core_id)
{

    if (__RARELY(hsem == NULL))
    {
        return -1;
    }

    uint32_t lock_code;
    // uint32_t read_sem;
    uint32_t sem_stat; // sem status of one core
    uint32_t return_code;

    lock_code = ((core_id << 8) | (0b1)); // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        hsem->sem_0 = lock_code;
        // read_sem = hsem->sem_0;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 0, sem_stat);
    }
    else if (sem_id == 1)
    {
        hsem->sem_1 = lock_code;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 1, sem_stat);
    }
    else if (sem_id == 2)
    {
        hsem->sem_2 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 2, sem_stat);
    }
    else if (sem_id == 3)
    {
        hsem->sem_3 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 3, sem_stat);
    }
    else if (sem_id == 4)
    {
        hsem->sem_4 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 4, sem_stat);
    }
    else if (sem_id == 5)
    {
        hsem->sem_5 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 5, sem_stat);
    }
    else if (sem_id == 6)
    {
        hsem->sem_6 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 6, sem_stat);
    }
    else if (sem_id == 7)
    {
        hsem->sem_7 = lock_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_lck(HSEM_BASE, 7, sem_stat);
    }

    return return_code;
}

uint32_t hsem_try_rls(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t core_id)
{

    if (__RARELY(hsem == NULL))
    {
        return -1;
    }

    uint32_t release_code;
    // uint32_t read_sem;
    uint32_t sem_stat; // sem status of one core
    uint32_t return_code;

    release_code = 0; // The value that will be write to the sem_x
    if (sem_id == 0)
    {
        hsem->sem_0 = release_code;
        // read_sem = hsem->sem_0;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 0, sem_stat);
    }
    else if (sem_id == 1)
    {
        hsem->sem_1 = release_code;
        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 1, sem_stat);
    }
    else if (sem_id == 2)
    {
        hsem->sem_2 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 2, sem_stat);
    }
    else if (sem_id == 3)
    {
        hsem->sem_3 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 3, sem_stat);
    }
    else if (sem_id == 4)
    {
        hsem->sem_4 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 4, sem_stat);
    }
    else if (sem_id == 5)
    {
        hsem->sem_5 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 5, sem_stat);
    }
    else if (sem_id == 6)
    {
        hsem->sem_6 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 6, sem_stat);
    }
    else if (sem_id == 7)
    {
        hsem->sem_7 = release_code;

        if (core_id == CORE_0_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_0_ID);
        }
        else if (core_id == CORE_1_ID)
        {
            sem_stat = hsem_stat(HSEM_BASE, CORE_1_ID);
        }
        return_code = hsem_check_rls(HSEM_BASE, 7, sem_stat);
    }

    return return_code;
}

void hsem_intr_trig(HSEM_TypeDef *hsem, uint32_t core_id)
{
    if (core_id == CORE_0_ID)
    {
        hsem->intr_0 = SW_SET;
    }
    else if (core_id == CORE_1_ID)
    {
        hsem->intr_1 = SW_SET;
    }
}

int32_t hsem_intr_stat(HSEM_TypeDef *hsem, int core_id)
{
    uint32_t intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = hsem->intr_0;
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = hsem->intr_1;
    }

    return intr_stat;
}

void hsem_intr_clear(HSEM_TypeDef *hsem, int core_id)
{
    uint32_t intr_stat;
    if (core_id == CORE_0_ID)
    {
        intr_stat = hsem->intr_clr_0;
    }
    else if (core_id == CORE_1_ID)
    {
        intr_stat = hsem->intr_clr_1;
    }
}

int32_t hsem_err_stat(HSEM_TypeDef *hsem, int core_id)
{
    uint32_t err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = hsem->error_0;
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = hsem->error_1;
    }

    return err_stat;
}

void hsem_err_clear(HSEM_TypeDef *hsem, int core_id)
{
    uint32_t err_stat;
    if (core_id == CORE_0_ID)
    {
        err_stat = hsem->err_clr_0;
    }
    else if (core_id == CORE_1_ID)
    {
        err_stat = hsem->err_clr_1;
    }
}

void hsem_send_task(HSEM_TypeDef *hsem, int task_code, int core_id)
{
    hsem->task = task_code;

    if (core_id == CORE_0_ID)
    {
        hsem->intr_0 = TASK;
    }
    else if (core_id == CORE_1_ID)
    {
        hsem->intr_1 = TASK;
    }
}
