#ifndef _HBIRDV2_HSEM_H
#define _HBIRDV2_HSEM_H

#ifdef __cplusplus
extern "C" {
#endif

#define CORE_0_ID 0xaa
#define CORE_1_ID 0xbb

#define SW_SET 0b1
#define ERROR 0b10
#define TASK 0b11

    // some task code need to be set here!!!!**************
    // intr code need to be added here!!

    uint32_t hsem_stat(HSEM_TypeDef *hsem, uint32_t core_id);
    uint32_t hsem_check_lck(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t sem_stat);
    uint32_t hsem_check_rls(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t sem_stat);
    uint32_t hsem_try_lock(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t core_id);
    uint32_t hsem_try_rls(HSEM_TypeDef *hsem, uint32_t sem_id, uint32_t core_id);
    void hsem_intr_trig(HSEM_TypeDef *hsem, uint32_t core_id);
    uint32_t hsem_intr_stat(HSEM_TypeDef *hsem, uint32_t core_id);
    void hsem_intr_clear(HSEM_TypeDef *hsem, uint32_t core_id);
    uint32_t hsem_err_stat(HSEM_TypeDef *hsem, uint32_t core_id);
    void hsem_err_clear(HSEM_TypeDef *hsem, uint32_t core_id);
    void hsem_send_task(HSEM_TypeDef *hsem, uint32_t task_code, uint32_t core_id);

#ifdef __cplusplus
}
#endif
#endif