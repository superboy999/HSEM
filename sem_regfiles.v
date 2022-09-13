//  ------------------------------------------------------------------------
// File:                        sem_regfile.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               Register Block module for the HSEM macrocell.
// Last modified date :         2022/09/10
// Description:                 In this module, only those regs related to the semaphore will appear in this module, those regs related to the interrupt or error will appear in ine.v
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
// own to Core0
`define HSEM_INTERRUPT_OFFSET         8'h20 //controled in ine module
`define HSEM_INTERRUPT_CLEAR_OFFSET   8'h24
`define HSEM_ERROR_OFFSET             8'h28
`define HSEM_ERROR_CLEAR_OFFSET       8'h2c
`define HSEM_STATUS_0_OFFSET          8'h30 //record the attribution of the resource
// own to Core1
//`define HSEM_INTERRUPT_1_OFFSET         8'h34
//`define HSEM_INTERRUPT_CLEAR_1_OFFSET   8'h38
//`define HSEM_ERROR_1_OFFSET             8'h3c
//`define HSEM_ERROR_CLEAR_1_OFFSET       8'h40
`define HSEM_STATUS_1_OFFSET          8'h34

module hsem_regfiles
    (
        hclk,
        hresetn,
        wr_en,
        rd_en,
        ihwdata,
        reg_addr,
        ihrdata,
        intr_stat,//from ine
        error_stat,//from ine
        int_reg_en,
        int_clr_reg_en,
        err_reg_en,
        err_clr_reg_en,
        semerr //add this connect to the ine module
        // int_reg_en_1,
        // int_clr_reg_en_1,
        // err_reg_en_1,
        // err_clr_reg_en_1,
    );

    input   hclk;
    input   hresetn;
    input   wr_en;
    input   rd_en;
    input   [`AHB_DATA_WIDTH-1:0]       ihwdata;
    input   [`AHB_SEM_ADDR_WIDTH-1:0]   reg_addr;
    input   [`ERROR_REG_WIDTH-1:0]      error_stat; //from ine
    input   [`INTR_REG_WIDTH-1:0]       intr_stat;  //from ine
    output  [`AHB_DATA_WIDTH-1:0]       ihrdata;
    output  int_reg_en;
    output  int_clr_reg_en;
    output  err_reg_en;
    output  err_clr_reg_en;
    output  [`SEMERR_WIDTH-1:0]         semerr;
    // output  int_reg_en_1;
    // output  int_clr_reg_en_1;
    // output  err_reg_en_1;
    // output  err_clr_reg_en_1;

    wire    resource_0_en;
    wire    resource_1_en;
    wire    resource_2_en;
    wire    resource_3_en;
    wire    resource_4_en;
    wire    resource_5_en;
    wire    resource_6_en;
    wire    resource_7_en;
// These signals will connect to the ine module
    wire    int_reg_en;
    wire    int_clr_reg_en;
    wire    err_reg_en;
    wire    err_clr_reg_en;
    wire    [`ERR_CODE_WIDTH-1:0]   err_code;
    wire    [`SEMNUM_WIDTH-1:0]     semnum;
    wire    [`CORE_ID_WIDTH-1:0]    faultid;
// module internal wire
    wire    status_reg_en;

    // wire    int_reg_en_1;
    // wire    int_clr_reg_en_1;
    // wire    err_reg_en_1;
    // wire    err_clr_reg_en_1;
    // wire    status_reg_en_1;
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

    wire  sem_0_rls; //internal wire connected to the reg sem_0
    wire  sem_1_rls;
    wire  sem_2_rls;
    wire  sem_3_rls;
    wire  sem_4_rls;
    wire  sem_5_rls;
    wire  sem_6_rls;
    wire  sem_7_rls;

    assign  resource_0_en = (reg_addr == `HSEM_RESOURCE_0_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_1_en = (reg_addr == `HSEM_RESOURCE_1_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_2_en = (reg_addr == `HSEM_RESOURCE_2_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_3_en = (reg_addr == `HSEM_RESOURCE_3_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_4_en = (reg_addr == `HSEM_RESOURCE_4_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_5_en = (reg_addr == `HSEM_RESOURCE_5_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_6_en = (reg_addr == `HSEM_RESOURCE_6_OFFSET) ? 1'b1 : 1'b0;
    assign  resource_7_en = (reg_addr == `HSEM_RESOURCE_7_OFFSET) ? 1'b1 : 1'b0;

    assign  sem_0_rls     = (resource_0_en && wr_en && (hwdata == 1));
    assign  sem_1_rls     = (resource_1_en && wr_en && (hwdata == 1));
    assign  sem_2_rls     = (resource_2_en && wr_en && (hwdata == 1));
    assign  sem_3_rls     = (resource_3_en && wr_en && (hwdata == 1));
    assign  sem_4_rls     = (resource_4_en && wr_en && (hwdata == 1));
    assign  sem_5_rls     = (resource_5_en && wr_en && (hwdata == 1));
    assign  sem_6_rls     = (resource_6_en && wr_en && (hwdata == 1));
    assign  sem_7_rls     = (resource_7_en && wr_en && (hwdata == 1));

// own to the Core 0
    assign  int_reg_en        = (reg_addr == `HSEM_INTERRUPT_OFFSET      ) ? 1'b1 : 1'b0;
    assign  int_clr_reg_en    = (reg_addr == `HSEM_INTERRUPT_CLEAR_OFFSET) ? 1'b1 : 1'b0;
    assign  err_reg_en        = (reg_addr == `HSEM_ERROR_OFFSET          ) ? 1'b1 : 1'b0;
    assign  err_clr_reg_en    = (reg_addr == `HSEM_ERROR_CLEAR_OFFSET    ) ? 1'b1 : 1'b0;
    assign  status_reg_en_0   = (reg_addr == `HSEM_STATUS_0_OFFSET       ) ? 1'b1 : 1'b0;
// own to the Core 1
    // assign  int_reg_en_1      = (reg_addr == `HSEM_INTERRUPT_1_OFFSET      ) ? 1'b1 : 1'b0;
    // assign  int_clr_reg_en_1  = (reg_addr == `HSEM_INTERRUPT_CLEAR_1_OFFSET) ? 1'b1 : 1'b0;
    // assign  err_reg_en_1      = (reg_addr == `HSEM_ERROR_1_OFFSET          ) ? 1'b1 : 1'b0;
    // assign  err_clr_reg_en_1  = (reg_addr == `HSEM_ERROR_CLEAR_1_OFFSET    ) ? 1'b1 : 1'b0;
    assign  status_reg_en_1   = (reg_addr == `HSEM_STATUS_1_OFFSET       ) ? 1'b1 : 1'b0;

// ------------------------------------------------------
// -- semaphore reg
// ------------------------------------------------------
    always@(posedge hclk or negedge hresetn)
        begin : sem_0
            if(hresetn == 1'b0)
                sem_0 <= 0;
            else
                begin
                    if(resource_0_en && wr_en)
                        begin
                            sem_0[0] <= ihwdata[0];
                            sem_0[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_0_rls)
                        begin
                            sem_0[0] <= ihwdata[0];
                            sem_0[15:8] <= 0;
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_1
            if(hresetn == 1'b0)
                sem_1 <= 0;
            else
                begin
                    if(resource_1_en && wr_en)
                        begin
                            sem_1[0] <= ihwdata[0];
                            sem_1[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_1_rls)
                        begin
                            sem_1[0] <= ihwdata[0];
                            sem_1[15:8] <= 0;
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_2
            if(hresetn == 1'b0)
                sem_2 <= 0;
            else
                begin
                    if(resource_2_en && wr_en)
                        begin
                            sem_2[0] <= ihwdata[0];
                            sem_2[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_2_rls)
                        begin
                            sem_2[0] <= ihwdata[0];
                            sem_2[15:8] <= 0;
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_3
            if(hresetn == 1'b0)
                sem_3 <= 0;
            else
                begin
                    if(resource_3_en && wr_en)
                        begin
                            sem_3[0] <= ihwdata[0];
                            sem_3[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_3_rls)
                        begin
                            sem_3[0] <= ihwdata[0];
                            sem_3[15:8] <= 0;
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_4
            if(hresetn == 1'b0)
                sem_4 <= 0;
            else
                begin
                    if(resource_4_en && wr_en)
                        begin
                            sem_4[0] <= ihwdata[0];
                            sem_4[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_4_rls)
                        begin
                            sem_4[0] <= ihwdata[0];
                            sem_4[15:8] <= 0;
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_5
            if(hresetn == 1'b0)
                sem_5 <= 0;
            else
                begin
                    if(resource_5_en && wr_en)
                        begin
                            sem_5[0] <= ihwdata[0];
                            sem_5[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_5_rls)
                        begin
                            sem_5[0] <= ihwdata[0];
                            sem_5[15:8] <= 0;
                        end
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : sem_6
            if(hresetn == 1'b0)
                sem_6 <= 0;
            else
                begin
                    if(resource_6_en && wr_en)
                        begin
                            sem_6[0] <= ihwdata[0];
                            sem_6[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_6_rls)
                        begin
                            sem_6[0] <= ihwdata[0];
                            sem_6[15:8] <= 0;
                        end
                end
        end
        
    always@(posedge hclk or negedge hresetn)
        begin : sem_7
            if(hresetn == 1'b0)
                sem_7 <= 0;
            else
                begin
                    if(resource_7_en && wr_en)
                        begin
                            sem_7[0] <= ihwdata[0];
                            sem_7[15:8] <= ihwdata[15:8];
                        end
                    else if(sem_7_rls)
                        begin
                            sem_7[0] <= ihwdata[0];
                            sem_7[15:8] <= 0;
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

            hrdata = {32{1'b0}}; // in the combinational circuit, this line is to prevent the latch condition, it is same as add an "else" in the judgment process
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
            if(int_reg_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = error_stat[`ERROR_REG_WIDTH-1:0];
            if(err_reg_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = intr_stat[`INTR_REG_WIDTH-1:0];
            if(int_clr_reg_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
            if(err_clr_reg_en == 1'b1)
                ihrdata[`SEM_REG_WIDTH-1:0]  = {32{1'b0}};
        end

//-----------------------------------------------------------------------
    assign sem_status_0[0] = (sem_0_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[1] = (sem_1_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[2] = (sem_2_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[3] = (sem_3_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[4] = (sem_4_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0;  
    assign sem_status_0[5] = (sem_5_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[6] = (sem_6_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_0[7] = (sem_7_iw[15:8] == CORE_0_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[0] = (sem_0_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0;  
    assign sem_status_1[1] = (sem_1_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[2] = (sem_2_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[3] = (sem_3_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[4] = (sem_4_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0;  
    assign sem_status_1[5] = (sem_5_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[6] = (sem_6_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
    assign sem_status_1[7] = (sem_7_iw[15:8] == CORE_1_ID) ? 1'b1 : 1'b0; 
//-----------------------------------------------------------------------

    always@(*)
        begin : ERR_CODE_PROC
            err_code = {3{1'b1}};

        end

endmodule