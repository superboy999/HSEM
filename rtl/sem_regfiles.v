//  ------------------------------------------------------------------------
// File:                        sem_regfile.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               Register Block module for the HSEM macrocell.
// Last modified date :         2022/09/22
// Description:                 In this module, only those regs related to the semaphore will appear in this module, those regs related to the interrupt or error will appear in ine.v
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`include "sem_config.v"
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
// own to Core0
`define HSEM_INTERRUPT_0_OFFSET         8'h20 //controled in ine module
`define HSEM_INTERRUPT_CLEAR_0_OFFSET   8'h24
`define HSEM_ERROR_0_OFFSET             8'h28
`define HSEM_ERROR_CLEAR_0_OFFSET       8'h2c
`define HSEM_STATUS_0_OFFSET            8'h30 //record the attribution of the resource; read only
// own to Core1
`define HSEM_INTERRUPT_1_OFFSET         8'h34
`define HSEM_INTERRUPT_CLEAR_1_OFFSET   8'h38
`define HSEM_ERROR_1_OFFSET             8'h3c
`define HSEM_ERROR_CLEAR_1_OFFSET       8'h40
`define HSEM_STATUS_1_OFFSET            8'h44// read only

`define TASK_SWITCH_OFFSET              8'h48

module hsem_regfiles
    (
        hclk,
        hresetn,
        wr_en,
        rd_en,
        ihwdata,
        reg_addr,
        ihrdata,
        intr_stat_0,//from ine
        error_stat_0,//from ine
        intr_stat_1,//from ine
        error_stat_1,//from ine        
        tsk_stat,
        int_reg_en_0,
        int_clr_reg_en_0,
        err_reg_en_0,
        err_clr_reg_en_0,
        int_reg_en_1,
        int_clr_reg_en_1,
        err_reg_en_1,
        err_clr_reg_en_1,
        semerr_0, //add this connect to the ine module
        semerr_1, //add this connect to the ine module
        task_en
    );

    input   hclk;
    input   hresetn;
    input   wr_en;
    input   rd_en;
    input   [`AHB_DATA_WIDTH-1:0]       ihwdata;
    input   [`AHB_SEM_ADDR_WIDTH-1:0]   reg_addr;
    input   [`ERROR_REG_WIDTH-1:0]      error_stat_0; //from ine
    input   [`INTR_REG_WIDTH-1:0]       intr_stat_0;  //from ine
    input   [`ERROR_REG_WIDTH-1:0]      error_stat_1; //from ine
    input   [`INTR_REG_WIDTH-1:0]       intr_stat_1;  //from ine
    input   [`TASK_SWITCH_WIDTH-1:0]    tsk_stat;   //from task
    output  [`AHB_DATA_WIDTH-1:0]       ihrdata;
    output  int_reg_en_0;
    output  int_clr_reg_en_0;
    output  err_reg_en_0;
    output  err_clr_reg_en_0;
    output  int_reg_en_1;
    output  int_clr_reg_en_1;
    output  err_reg_en_1;
    output  err_clr_reg_en_1;
    output  [`SEMERR_WIDTH-1:0]         semerr_0;
    output  [`SEMERR_WIDTH-1:0]         semerr_1;
    output  task_en;

    wire    resource_0_en;
    wire    resource_1_en;
    wire    resource_2_en;
    wire    resource_3_en;
    wire    resource_4_en;
    wire    resource_5_en;
    wire    resource_6_en;
    wire    resource_7_en;
// These signals will connect to the ine module
    wire    int_reg_en_0;
    wire    int_clr_reg_en_0;
    wire    err_reg_en_0;
    wire    err_clr_reg_en_0;
    wire    status_reg_en_0;
    reg    [`ERR_CODE_WIDTH-1:0]   err_code_0; //not real reg after synthesis
    reg    [`SEMNUM_WIDTH-1:0]     semnum_0;
    reg    [`CORE_ID_WIDTH-1:0]    faultid_0;
    
	reg  [`AHB_DATA_WIDTH-1:0]     ihrdata;
// module internal wire
    wire    int_reg_en_1;
    wire    int_clr_reg_en_1;
    wire    err_reg_en_1;
    wire    err_clr_reg_en_1;
    wire    status_reg_en_1;
    reg    [`ERR_CODE_WIDTH-1:0]   err_code_1; //not real reg after synthesis
    reg    [`SEMNUM_WIDTH-1:0]     semnum_1;
    reg    [`CORE_ID_WIDTH-1:0]    faultid_1;

    wire    task_en;
//----------------------------------------------
    reg [`SEM_REG_WIDTH-1:0]  sem_0;
    reg [`SEM_REG_WIDTH-1:0]  sem_1;
    reg [`SEM_REG_WIDTH-1:0]  sem_2;
    reg [`SEM_REG_WIDTH-1:0]  sem_3;
    reg [`SEM_REG_WIDTH-1:0]  sem_4;
    reg [`SEM_REG_WIDTH-1:0]  sem_5;
    reg [`SEM_REG_WIDTH-1:0]  sem_6;
    reg [`SEM_REG_WIDTH-1:0]  sem_7;

    // reg [`RESOURCE_NUM-1:0]   sem_status_0;
    // reg [`RESOURCE_NUM-1:0]   sem_status_1;

    // wire [`RESOURCE_NUM-1:0]  sem_status_0_iw; //internal wire for reading convinence
    // wire [`RESOURCE_NUM-1:0]  sem_status_1_iw;

    wire [`RESOURCE_NUM-1:0]   sem_status_0;
    wire [`RESOURCE_NUM-1:0]   sem_status_1;

    wire [`SEM_REG_WIDTH-1:0]  sem_0_iw; //internal wire connected to the reg sem_0
    wire [`SEM_REG_WIDTH-1:0]  sem_1_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_2_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_3_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_4_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_5_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_6_iw;
    wire [`SEM_REG_WIDTH-1:0]  sem_7_iw;

    wire  sem_0_rls; //release
    wire  sem_1_rls;
    wire  sem_2_rls;
    wire  sem_3_rls;
    wire  sem_4_rls;
    wire  sem_5_rls;
    wire  sem_6_rls;
    wire  sem_7_rls;

    wire  sem_0_lck; //lock
    wire  sem_1_lck;
    wire  sem_2_lck;
    wire  sem_3_lck;
    wire  sem_4_lck;
    wire  sem_5_lck;
    wire  sem_6_lck;
    wire  sem_7_lck;

    assign  resource_0_en = (reg_addr == `HSEM_RESOURCE_0_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_1_en = (reg_addr == `HSEM_RESOURCE_1_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_2_en = (reg_addr == `HSEM_RESOURCE_2_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_3_en = (reg_addr == `HSEM_RESOURCE_3_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_4_en = (reg_addr == `HSEM_RESOURCE_4_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_5_en = (reg_addr == `HSEM_RESOURCE_5_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_6_en = (reg_addr == `HSEM_RESOURCE_6_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_7_en = (reg_addr == `HSEM_RESOURCE_7_OFFSET) ? 1'b1 : 1'b0;

    // assign  sem_0_lck     = (resource_0_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_0_iw[15:8])); //modify in 9.14，考虑到这个信号需要直接加上core match的因素才可以对semaphore进行读写。
    // assign  sem_1_lck     = (resource_1_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_1_iw[15:8])); //modify in 9.22, change the behavior: 0x0 is free;0x1 is lock
    // assign  sem_2_lck     = (resource_2_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_2_iw[15:8]));
    // assign  sem_3_lck     = (resource_3_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_3_iw[15:8]));
    // assign  sem_4_lck     = (resource_4_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_4_iw[15:8]));
    // assign  sem_5_lck     = (resource_5_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_5_iw[15:8]));
    // assign  sem_6_lck     = (resource_6_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_6_iw[15:8]));
    // assign  sem_7_lck     = (resource_7_en && wr_en && (ihwdata[0] == 1) && (ihwdata[15:8] == sem_7_iw[15:8]));

    assign  sem_0_lck     = (resource_0_en && wr_en && (ihwdata[0] == 1)); //modify in 9.14，考虑到这个信号需要直接加上core match的因素才可以对semaphore进行读写。
    assign  sem_1_lck     = (resource_1_en && wr_en && (ihwdata[0] == 1)); //modify in 9.22, change the behavior: 0x0 is free;0x1 is lock
    assign  sem_2_lck     = (resource_2_en && wr_en && (ihwdata[0] == 1));
    assign  sem_3_lck     = (resource_3_en && wr_en && (ihwdata[0] == 1));
    assign  sem_4_lck     = (resource_4_en && wr_en && (ihwdata[0] == 1));
    assign  sem_5_lck     = (resource_5_en && wr_en && (ihwdata[0] == 1));
    assign  sem_6_lck     = (resource_6_en && wr_en && (ihwdata[0] == 1));
    assign  sem_7_lck     = (resource_7_en && wr_en && (ihwdata[0] == 1));

    assign  sem_0_rls     = (resource_0_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_0_iw[15:8])); //modify in 9.14
    assign  sem_1_rls     = (resource_1_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_1_iw[15:8]));
    assign  sem_2_rls     = (resource_2_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_2_iw[15:8]));
    assign  sem_3_rls     = (resource_3_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_3_iw[15:8]));
    assign  sem_4_rls     = (resource_4_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_4_iw[15:8]));
    assign  sem_5_rls     = (resource_5_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_5_iw[15:8]));
    assign  sem_6_rls     = (resource_6_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_6_iw[15:8]));
    assign  sem_7_rls     = (resource_7_en && wr_en && (ihwdata[0] == 0) && (ihwdata[15:8] == sem_7_iw[15:8]));

// own to the Core 0
    assign  int_reg_en_0        = (reg_addr == `HSEM_INTERRUPT_0_OFFSET      ) ? 1'b1 : 1'b0;
    assign  int_clr_reg_en_0    = (reg_addr == `HSEM_INTERRUPT_CLEAR_0_OFFSET) ? 1'b1 : 1'b0;
    assign  err_reg_en_0        = (reg_addr == `HSEM_ERROR_0_OFFSET          ) ? 1'b1 : 1'b0;
    assign  err_clr_reg_en_0    = (reg_addr == `HSEM_ERROR_CLEAR_0_OFFSET    ) ? 1'b1 : 1'b0;
    assign  status_reg_en_0     = (reg_addr == `HSEM_STATUS_0_OFFSET       ) ? 1'b1 : 1'b0;
// own to the Core 1
    assign  int_reg_en_1      = (reg_addr == `HSEM_INTERRUPT_1_OFFSET      ) ? 1'b1 : 1'b0;
    assign  int_clr_reg_en_1  = (reg_addr == `HSEM_INTERRUPT_CLEAR_1_OFFSET) ? 1'b1 : 1'b0;
    assign  err_reg_en_1      = (reg_addr == `HSEM_ERROR_1_OFFSET          ) ? 1'b1 : 1'b0;
    assign  err_clr_reg_en_1  = (reg_addr == `HSEM_ERROR_CLEAR_1_OFFSET    ) ? 1'b1 : 1'b0;
    assign  status_reg_en_1   = (reg_addr == `HSEM_STATUS_1_OFFSET       ) ? 1'b1 : 1'b0;
// connected to the task.v
    assign  task_en           = (reg_addr == `TASK_SWITCH_OFFSET         ) ? 1'b1 : 1'b0;

// ------------------------------------------------------
// -- semaphore reg
// ------------------------------------------------------
    always@(posedge hclk or negedge hresetn)
        begin : sem_0_proc
            if(hresetn == 1'b0)
                sem_0 <= 0;
            else
                begin
                    // if(resource_0_en && wr_en)
                    //     begin
                    //         sem_0[0] <= ihwdata[0];
                    //         sem_0[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_0_rls)
                        begin
                            sem_0[0] <= ihwdata[0];
                            sem_0[15:8] <= 0;
                        end
                    else if(sem_0_lck)
                        begin
                            sem_0[0] <= ihwdata[0];
                            sem_0[15:8] <= ihwdata[15:8];
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_1_proc
            if(hresetn == 1'b0)
                sem_1 <= 0;
            else
                begin
                    // if(resource_1_en && wr_en)
                    //     begin
                    //         sem_1[0] <= ihwdata[0];
                    //         sem_1[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_1_rls)
                        begin
                            sem_1[0] <= ihwdata[0];
                            sem_1[15:8] <= 0;
                        end
                    else if(sem_1_lck)
                        begin
                            sem_1[0] <= ihwdata[0];
                            sem_1[15:8] <= ihwdata[15:8];
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_2_proc
            if(hresetn == 1'b0)
                sem_2 <= 0;
            else
                begin
                    // if(resource_2_en && wr_en)
                    //     begin
                    //         sem_2[0] <= ihwdata[0];
                    //         sem_2[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_2_rls)
                        begin
                            sem_2[0] <= ihwdata[0];
                            sem_2[15:8] <= 0;
                        end
                    else if(sem_2_lck)
                        begin
                            sem_2[0] <= ihwdata[0];
                            sem_2[15:8] <= ihwdata[15:8];
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_3_proc
            if(hresetn == 1'b0)
                sem_3 <= 0;
            else
                begin
                    // if(resource_3_en && wr_en)
                    //     begin
                    //         sem_3[0] <= ihwdata[0];
                    //         sem_3[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_3_rls)
                        begin
                            sem_3[0] <= ihwdata[0];
                            sem_3[15:8] <= 0;
                        end
                    else if(sem_3_lck)
                        begin
                            sem_3[0] <= ihwdata[0];
                            sem_3[15:8] <= ihwdata[15:8];
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_4_proc
            if(hresetn == 1'b0)
                sem_4 <= 0;
            else
                begin
                    // if(resource_4_en && wr_en)
                    //     begin
                    //         sem_4[0] <= ihwdata[0];
                    //         sem_4[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_4_rls)
                        begin
                            sem_4[0] <= ihwdata[0];
                            sem_4[15:8] <= 0;
                        end
                    else if(sem_4_lck)
                        begin
                            sem_4[0] <= ihwdata[0];
                            sem_4[15:8] <= ihwdata[15:8];
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_5_proc
            if(hresetn == 1'b0)
                sem_5 <= 0;
            else
                begin
                    // if(resource_5_en && wr_en)
                    //     begin
                    //         sem_5[0] <= ihwdata[0];
                    //         sem_5[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_5_rls)
                        begin
                            sem_5[0] <= ihwdata[0];
                            sem_5[15:8] <= 0;
                        end
                    else if(sem_5_lck)
                        begin
                            sem_5[0] <= ihwdata[0];
                            sem_5[15:8] <= ihwdata[15:8];
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_6_proc
            if(hresetn == 1'b0)
                sem_6 <= 0;
            else
                begin
                    // if(resource_6_en && wr_en)
                    //     begin
                    //         sem_6[0] <= ihwdata[0];
                    //         sem_6[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_6_rls)
                        begin
                            sem_6[0] <= ihwdata[0];
                            sem_6[15:8] <= 0;
                        end
                    else if(sem_6_lck)
                        begin
                            sem_6[0] <= ihwdata[0];
                            sem_6[15:8] <= ihwdata[15:8];
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_7_proc
            if(hresetn == 1'b0)
                sem_7 <= 0;
            else
                begin
                    // if(resource_7_en && wr_en)
                    //     begin
                    //         sem_7[0] <= ihwdata[0];
                    //         sem_7[15:8] <= ihwdata[15:8];
                    //     end
                    if(sem_7_rls)
                        begin
                            sem_7[0] <= ihwdata[0];
                            sem_7[15:8] <= 0;
                        end
                    else if(sem_7_lck)
                        begin
                            sem_7[0] <= ihwdata[0];
                            sem_7[15:8] <= ihwdata[15:8];
                        end
                end
        end

    assign sem_0_iw = sem_0;
    assign sem_1_iw = sem_1;
    assign sem_2_iw = sem_2;
    assign sem_3_iw = sem_3;
    assign sem_4_iw = sem_4;
    assign sem_5_iw = sem_5;
    assign sem_6_iw = sem_6;
    assign sem_7_iw = sem_7;

    always@(*)
        begin : READ_SEM_PROC

            ihrdata = {32{1'b0}}; // in the combinational circuit, this line is to prevent the latch condition, it is same as add an "else" in the judgment process
// the reason why here just judge the en signal is that, ihrdata will be just sent into biu module, and whether the direction is read or write, just send it, the biu module will decide if ihrdata will be sent to real hrdata(for AHB bus).
            if(resource_0_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_0_iw[`SEM_REG_WIDTH-1:0];
            if(resource_1_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_1_iw[`SEM_REG_WIDTH-1:0];
            if(resource_2_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_2_iw[`SEM_REG_WIDTH-1:0];
            if(resource_3_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_3_iw[`SEM_REG_WIDTH-1:0];
            if(resource_4_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_4_iw[`SEM_REG_WIDTH-1:0];
            if(resource_5_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_5_iw[`SEM_REG_WIDTH-1:0];
            if(resource_6_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_6_iw[`SEM_REG_WIDTH-1:0];
            if(resource_7_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_7_iw[`SEM_REG_WIDTH-1:0];
            if(status_reg_en_0 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_status_0[`RESOURCE_NUM-1:0];
            if(status_reg_en_1 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = sem_status_1[`RESOURCE_NUM-1:0];
            if(int_reg_en_0 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = intr_stat_0[`ERROR_REG_WIDTH-1:0];
            if(err_reg_en_0 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = error_stat_0[`INTR_REG_WIDTH-1:0];
            if(int_clr_reg_en_0 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
            if(err_clr_reg_en_0 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
            if(int_reg_en_1 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = intr_stat_1[`ERROR_REG_WIDTH-1:0];
            if(err_reg_en_1 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = error_stat_1[`INTR_REG_WIDTH-1:0];
            if(int_clr_reg_en_1 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
            if(err_clr_reg_en_1 == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
            if(task_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = tsk_stat;
        end

//-----------------------------------------------------------------------
    assign sem_status_0[0] = (sem_0_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[1] = (sem_1_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[2] = (sem_2_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[3] = (sem_3_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[4] = (sem_4_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0;  
    assign sem_status_0[5] = (sem_5_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[6] = (sem_6_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[7] = (sem_7_iw[15:8] == `CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[0] = (sem_0_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0;  
    assign sem_status_1[1] = (sem_1_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[2] = (sem_2_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[3] = (sem_3_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[4] = (sem_4_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0;  
    assign sem_status_1[5] = (sem_5_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[6] = (sem_6_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[7] = (sem_7_iw[15:8] == `CORE_1_ID) ? 1'b1 : 1'b0; 
//-----------------------------------------------------------------------

    always@(*)
        begin : SEMERR_PROC
            faultid_0  = {8{1'b0}};
            semnum_0   = {5{1'b0}};
            err_code_0 = {3{1'b0}};
            faultid_1  = {8{1'b0}};
            semnum_1   = {5{1'b0}};
            err_code_1 = {3{1'b0}};
            //In this proc, we will use if to judge every semaphore
            if((resource_0_en == 1'b1) && wr_en) //semaphore 0 error
                begin
                    if((ihwdata[0]==0) && (sem_0_iw[15:8]==ihwdata[15:8]) && (sem_0_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b0;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b0;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_0_iw[15:8]!=ihwdata[15:8]) && (sem_0_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b0;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b0;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_0_iw[15:8]==ihwdata[15:8]) && (sem_0_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b0;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b0;                                   
                                end
                        end
                    // if((sem_0_iw[0]==ihwdata[0])&&(sem_0_iw[15:8]!=sem_0_iw[15:8])) //Already Requested Error 删除这个机制吧
                    //     begin
                    //         err_code = 3'b4;
                    //         semnum = 5'b0;
                    //         if(ihwdata[15:8]==`CORE_0_ID)
                    //             begin
                    //                 faultid = `CORE_0_ID;
                    //             end
                    //         else if(ihwdata[15:8]==`CORE_1_ID)
                    //             begin
                    //                 faultid = `CORE_1_ID;
                    //             end
                    //     end
                end
            if((resource_1_en == 1'b1) && wr_en) //semaphore 1 error
                begin
                    if((ihwdata[0]==0) && (sem_1_iw[15:8]==ihwdata[15:8]) && (sem_1_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b1;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b1;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_1_iw[15:8]!=ihwdata[15:8]) && (sem_1_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b1;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b1;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_1_iw[15:8]==ihwdata[15:8]) && (sem_1_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b1;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b1;                                   
                                end
                        end
                end
            if((resource_2_en == 1'b1) && wr_en) //semaphore 2 error
                begin
                    if((ihwdata[0]==0) && (sem_2_iw[15:8]==ihwdata[15:8]) && (sem_2_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b10;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b10;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_2_iw[15:8]!=ihwdata[15:8]) && (sem_2_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b10;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b10;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_2_iw[15:8]==ihwdata[15:8]) && (sem_2_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b10;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b10;                                   
                                end
                        end
                end
            if((resource_3_en == 1'b1) && wr_en) //semaphore 3 error
                begin
                    if((ihwdata[0]==0) && (sem_3_iw[15:8]==ihwdata[15:8]) && (sem_3_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b11;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b11;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_3_iw[15:8]!=ihwdata[15:8]) && (sem_3_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b11;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b11;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_3_iw[15:8]==ihwdata[15:8]) && (sem_3_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b11;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b11;                                   
                                end
                        end
                end
            if((resource_4_en == 1'b1) && wr_en) //semaphore 4 error
                begin
                    if((ihwdata[0]==0) && (sem_4_iw[15:8]==ihwdata[15:8]) && (sem_4_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b100;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b100;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_4_iw[15:8]!=ihwdata[15:8]) && (sem_4_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b100;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b100;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_4_iw[15:8]==ihwdata[15:8]) && (sem_4_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b100;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b100;                                   
                                end
                        end
                end
            if((resource_5_en == 1'b1) && wr_en) //semaphore 5 error
                begin
                    if((ihwdata[0]==0) && (sem_5_iw[15:8]==ihwdata[15:8]) && (sem_5_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b101;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b101;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_5_iw[15:8]!=ihwdata[15:8]) && (sem_5_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b101;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b101;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_5_iw[15:8]==ihwdata[15:8]) && (sem_5_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b101;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b101;                                   
                                end
                        end
                end
            if((resource_6_en == 1'b1) && wr_en) //semaphore 6 error
                begin
                    if((ihwdata[0]==0) && (sem_6_iw[15:8]==ihwdata[15:8]) && (sem_6_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b110;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b110;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_6_iw[15:8]!=ihwdata[15:8]) && (sem_6_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b110;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b110;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_6_iw[15:8]==ihwdata[15:8]) && (sem_6_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b110;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b110;                                   
                                end
                        end
                end
            if((resource_7_en == 1'b1) && wr_en) //semaphore 7 error
                begin
                    if((ihwdata[0]==0) && (sem_7_iw[15:8]==ihwdata[15:8]) && (sem_7_iw[0]==0)) //Already Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b0;
                                    semnum_0 = 5'b111;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b0;
                                    semnum_1 = 5'b111;                                   
                                end
                        end
                    if((ihwdata[0]==0) && (sem_7_iw[15:8]!=ihwdata[15:8]) && (sem_7_iw[0]==1)) //Illegal Free Error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b1;
                                    semnum_0 = 5'b111;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b1;
                                    semnum_1 = 5'b111;                                   
                                end
                        end
                    if((ihwdata[0]==1) && (sem_7_iw[15:8]==ihwdata[15:8]) && (sem_7_iw[0]==1)) //Already Own error
                        begin
                            if(ihwdata[15:8]==`CORE_0_ID)
                                begin
                                    faultid_0 = `CORE_0_ID;
                                    err_code_0 = 3'b10;
                                    semnum_0 = 5'b111;
                                end
                            else if(ihwdata[15:8]==`CORE_1_ID)
                                begin
                                    faultid_1 = `CORE_1_ID;
                                    err_code_1 = 3'b10;
                                    semnum_1 = 5'b111;                                   
                                end
                        end
                end
        end
    
    assign semerr_0 = {16'b0,faultid_0,semnum_0,err_code_0};
    assign semerr_1 = {16'b0,faultid_1,semnum_1,err_code_1};

endmodule