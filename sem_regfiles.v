//  ------------------------------------------------------------------------
// File:                        sem_regfile.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               Register Block module for the HSEM macrocell.
// Last modified date :         2022/09/09
// -------------------------------------------------------------------
// -------------------------------------------------------------------

// -----------------------------------------------------------
// -- Register address offset macros
// -----------------------------------------------------------
`define HSEM_RESOURCE_0_OFFSET        8'h0 //real_offset=0x0=00000000
`define HSEM_RESOURCE_1_OFFSET        8'h4 //real_offset=0x4=00000100
`define HSEM_RESOURCE_2_OFFSET        8'h8 //real_offset=0x8=00001000
`define HSEM_RESOURCE_3_OFFSET        8'hc //real_offset=0xc=00001100
`define HSEM_RESOURCE_4_OFFSET        8'h10 //real_offset=0x10=00010000
`define HSEM_RESOURCE_5_OFFSET        8'h14 //real_offset=0x14=
`define HSEM_RESOURCE_6_OFFSET        8'h18 //real_offset=0x18
`define HSEM_RESOURCE_7_OFFSET        8'h1c //real_offset=0x1c

`define HSEM_INTERRUPT_1_OFFSET         8'h20
`define HSEM_INTERRUPT_CLEAR_1_OFFSET   8'h24
`define HSEM_ERROR_1_OFFSET             8'h28
`define HSEM_ERROR_CLEAR_1_OFFSET       8'h2c
`define HSEM_STATUS_1_OFFSET            8'h30
`define HSEM_INTERRUPT_2_OFFSET         8'h34
`define HSEM_INTERRUPT_CLEAR_2_OFFSET   8'h38
`define HSEM_ERROR_2_OFFSET             8'h3c
`define HSEM_ERROR_CLEAR_2_OFFSET       8'h40
`define HSEM_STATUS_2_OFFSET            8'h44

module hsem_regfiles
    (

    );

    input   hclk;
    input   hresetn;
    input   wr_en;
    input   rd_en;
    input   [`AHB_DATA_WIDTH-1:0]       hwdata;
    input   [`AHB_SEM_ADDR_WIDTH-1:0]   reg_addr;
    output  [`AHB_DATA_WIDTH-1:0]       hrdata;

    wire    resource_0_en;
    wire    resource_1_en;
    wire    resource_2_en;
    wire    resource_3_en;
    wire    resource_4_en;
    wire    resource_5_en;
    wire    resource_6_en;
    wire    resource_7_en;

    wire    int_reg_en_1;
    wire    int_clr_reg_en_1;
    wire    err_reg_en_1;
    wire    err_clr_reg_en_1;
    wire    status_reg_en_1;

    wire    int_reg_en_2;
    wire    int_clr_reg_en_2;
    wire    err_reg_en_2;
    wire    err_clr_reg_en_2;
    wire    status_reg_en_2;

    assign  resource_0_en = (reg_addr == `HSEM_RESOURCE_0_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_1_en = (reg_addr == `HSEM_RESOURCE_1_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_2_en = (reg_addr == `HSEM_RESOURCE_2_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_3_en = (reg_addr == `HSEM_RESOURCE_3_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_4_en = (reg_addr == `HSEM_RESOURCE_4_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_5_en = (reg_addr == `HSEM_RESOURCE_5_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_6_en = (reg_addr == `HSEM_RESOURCE_6_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_7_en = (reg_addr == `HSEM_RESOURCE_7_OFFSET) ? 1'b1 : 1'b0;

    assign int_reg_en_1       = (reg_addr == `HSEM_INTERRUPT_1_OFFSET) ? 1'b1 : 1'b0;
    assign int_clr_reg_en_1   = (reg_addr == `HSEM_INTERRUPT_CLEAR_1_OFFSET) ? 1'b1 : 1'b0;
    assign  err_reg_en_1      = (reg_addr == `HSEM_ERROR_1_OFFSET          ) ? 1'b1 : 1'b0;
    assign  err_clr_reg_en_1  = (reg_addr == `HSEM_ERROR_CLEAR_1_OFFSET    ) ? 1'b1 : 1'b0;
    assign  status_reg_en_1   = (reg_addr == `HSEM_STATUS_1_OFFSET         ) ? 1'b1 : 1'b0;