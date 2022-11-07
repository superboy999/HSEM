//  ------------------------------------------------------------------------
// File:                        sem_ine.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               HSEM interrupt and error control module.
// Last modified date :         2022/09/22
// Description:                 interrupt will occur when error occurs and task switch 
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`include "sem_config.v"
module hsem_ine
    (
        hclk,
        hresetn,
        wr_en,
        ihwdata,
        int_reg_en_0,
        int_clr_reg_en_0,
        err_reg_en_0,
        err_clr_reg_en_0,
        semerr_0,
        error_stat_0,
        int_reg_en_1,
        int_clr_reg_en_1,
        err_reg_en_1,
        err_clr_reg_en_1,
        semerr_1,
        error_stat_1,
        intr_0,
        intr_1,
        intr_stat_0,
        intr_stat_1
    );
    input   hclk;
    input   hresetn;
    input   wr_en;
    // input   rd_en; //maybe delete later
    input   [`AHB_DATA_WIDTH-1:0]   ihwdata;
    //core_0
    input   int_reg_en_0;
    input   int_clr_reg_en_0;
    input   err_reg_en_0;
    input   err_clr_reg_en_0;
    input   [`SEMERR_WIDTH-1:0]     semerr_0;
    output  [`ERROR_REG_WIDTH-1:0]  error_stat_0;
    //core1
    input   int_reg_en_1;
    input   int_clr_reg_en_1;
    input   err_reg_en_1;
    input   err_clr_reg_en_1;
    input   [`SEMERR_WIDTH-1:0]     semerr_1;
    output  [`ERROR_REG_WIDTH-1:0]  error_stat_1;
    output  intr_0; //this signal will directly connect to the top level, connected to the core
    output  intr_1;
    output  [`INTR_REG_WIDTH-1:0]  intr_stat_0;
    output  [`INTR_REG_WIDTH-1:0]  intr_stat_1;

    reg [`ERROR_REG_WIDTH-1:0]  error_0;
    reg [`INTR_REG_WIDTH-1:0]   interrupt_0; // this reg can be written, it means we can write C to generate interrupt
	reg  [`ERROR_REG_WIDTH-1:0]  error_stat_0;
	reg  [`INTR_REG_WIDTH-1:0]  intr_stat_0;

    reg [`ERROR_REG_WIDTH-1:0]  error_1;
    reg [`INTR_REG_WIDTH-1:0]   interrupt_1; // this reg can be written, it means we can write C to generate interrupt
	reg  [`ERROR_REG_WIDTH-1:0]  error_stat_1;
	reg  [`INTR_REG_WIDTH-1:0]  intr_stat_1;

    wire [`ERROR_REG_WIDTH-1:0]  err_iw_0; //internal wire
    wire [`INTR_REG_WIDTH-1:0]   intr_iw_0; //intr_stat internal wire
    wire [`ERROR_REG_WIDTH-1:0]  err_iw_1; //internal wire
    wire [`INTR_REG_WIDTH-1:0]   intr_iw_1; //intr_stat internal wire
    wire    intr_0;
    wire    intr_1;

    assign  err_iw_0  = error_0;
    assign  intr_iw_0 = interrupt_0;
    assign  err_iw_1  = error_1;
    assign  intr_iw_1 = interrupt_1;
    // 为了让intr快一个周期，err这里采用组合逻辑
    // change!!! 为了让Intr快一个周期，把intr判断条件改成组合逻辑判断，但err还得是寄存器
    always@(posedge hclk or negedge hresetn)
        begin : error0_proc
            if(hresetn == 1'b0)
                begin
                    error_0 <= 32'b0;
                end
            else if(err_clr_reg_en_0 == 1'b1)
                begin
                    error_0 <= 32'b0;
                end
            else if(semerr_0 != 0) //防止err自动清零
                begin
                    error_0 <= semerr_0;
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : error1_proc
            if(hresetn == 1'b0)
                begin
                    error_1 <= 32'b0;
                end
            else if(err_clr_reg_en_1==1'b1)
                begin
                    error_1 <= 32'b0;
                end
            else if(semerr_1 != 0)
                begin
                    error_1 <= semerr_1;
                end
        end

    // always@(*)
    //     begin : error0_proc
    //         if(hresetn == 1'b0)
    //             begin
    //                 error_0 = 32'b0;
    //             end
    //         else if(err_clr_reg_en_0 == 1'b1)
    //             begin
    //                 error_0 = 32'b0;
    //             end
    //         else
    //             begin
    //                 error_0 = semerr_0;
    //             end
    //     end

    // always@(*)
    //     begin : error1_proc
    //         if(hresetn == 1'b0)
    //             begin
    //                 error_1 = 32'b0;
    //             end
    //         else if(err_clr_reg_en_1==1'b1)
    //             begin
    //                 error_1 = 32'b0;
    //             end
    //         else
    //             begin
    //                 error_1 = semerr_1;
    //             end
    //     end

    always@(posedge hclk or negedge hresetn)
        begin : interrupt0_proc
            if(hresetn == 1'b0)
                interrupt_0 <= 32'b0;
            else if(semerr_0 != 32'b0)
                interrupt_0 <= `ERROR_PRODUCED;
            else if(int_reg_en_0 && wr_en)
                interrupt_0 <= ihwdata; //used to control interrupt to the target Core
            else if(int_clr_reg_en_0)
                interrupt_0 <= 32'b0;
        end

    always@(posedge hclk or negedge hresetn)
        begin : interrupt1_proc
            if(hresetn == 1'b0)
                interrupt_1 <= 32'b0;
            else if(semerr_1 != 32'b0)
                interrupt_1 <= `ERROR_PRODUCED;
            else if(int_reg_en_1 && wr_en)
                interrupt_1 <= ihwdata; //used to control interrupt to the target Core
            else if(int_clr_reg_en_1)
                interrupt_1 <= 32'b0;
        end

    always@(*)
        begin : READ_INE_PROC

            intr_stat_0 = {32{1'b0}};
            error_stat_0 = {32{1'b0}};
            intr_stat_1 = {32{1'b0}};
            error_stat_1 = {32{1'b0}};

            if(int_reg_en_0 == 1'b1)
                intr_stat_0 = intr_iw_0;
            if(err_reg_en_0 == 1'b1)
                error_stat_0 = err_iw_0;
            if(int_reg_en_1 == 1'b1)
                intr_stat_1 = intr_iw_1;
            if(err_reg_en_1 == 1'b1)
                error_stat_1 = err_iw_1;
        end


    // assign intr_0 = (interrupt == `CORE_0_INTR) ? 1'b1 : 1'b0;
    // assign intr_1 = (interrupt == `CORE_1_INTR) ? 1'b1 : 1'b0;    
    assign intr_0 = (interrupt_0 != 0) ? 1'b1 : 1'b0;
    assign intr_1 = (interrupt_1 != 0) ? 1'b1 : 1'b0;    

endmodule