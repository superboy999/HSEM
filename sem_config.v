//  ------------------------------------------------------------------------
// File :                       sem_config.v
// Author :                     superboy
// Created date :               2022/09/09
// Abstract     :               config file for the HSEM.
// Last modified date :         2022/09/09
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`define AHB_DATA_WIDTH 32

`define SEM_REG_WIDTH 32

`define AHB_SEM_ADDR_WIDTH 8

`define SYSTEM_CORE_NUM 2

`define HSEM_DFLT_OWNER 8'h0

`define CORE_0_ID 8'haa

`define CORE_1_ID 8'hbb

`define RESOURCE_NUM 8

`define ERROR_REG_WIDTH 32

`define INTR_REG_WIDTH 32