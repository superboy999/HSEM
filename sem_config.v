//  ------------------------------------------------------------------------
// File :                       sem_config.v
// Author :                     superboy
// Created date :               2022/09/09
// Abstract     :               config file for the HSEM.
// Last modified date :         2022/09/1
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`define AHB_DATA_WIDTH 32

`define SEM_REG_WIDTH 32

`define AHB_SEM_ADDR_WIDTH 8

`define SYSTEM_CORE_NUM 2

`define HSEM_DFLT_OWNER 8'h0

`define CORE_ID_WIDTH 8

`define CORE_0_ID 8'haa

`define CORE_1_ID 8'hbb

`define RESOURCE_NUM 8

`define ERROR_REG_WIDTH 32

`define INTR_REG_WIDTH 32

`define ERR_CODE_WIDTH 3

`define SEMERR_WIDTH 32

`define SEMNUM_WIDTH 5 //different from databook is:6

// `define TASK_SWITCH 2'b01

`define ERROR_PRODUCED 2'b01

`define CORE_0_INTR 2'b10

`define CORE_1_INTR 2'b11

`define TASK_SWITCH_WIDTH 32