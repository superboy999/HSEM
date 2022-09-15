//  ------------------------------------------------------------------------
// File:                        sem_ine.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               HSEM interrupt and error control module.
// Last modified date :         2022/09/13
// Description:                 interrupt will occur when error occurs and task switch 
// -------------------------------------------------------------------
// -------------------------------------------------------------------
module hsem_ine
    (
        hclk,
        hresetn,
        wr_en,
        ihwdata,
        int_reg_en,
        int_clr_reg_en,
        err_reg_en,
        err_clr_reg_en,
        semerr,
        error_stat,
        intr_0,
        intr_1,
        intr_stat
    );
    input   hclk;
    input   hresetn;
    input   wr_en;
    // input   rd_en; //maybe delete later
    input   [`AHB_DATA_WIDTH-1:0]   ihwdata;
    input   int_reg_en;
    input   int_clr_reg_en;
    input   err_reg_en;
    input   err_clr_reg_en;
    input   [`SEMERR_WIDTH-1:0]     semerr;
    output  [`ERROR_REG_WIDTH-1:0]  error_stat;
    output  intr_0; //this signal will directly connect to the top level, connected to the core
    output  intr_1;
    output  [`INTR_REG_WIDTH-1:0]  intr_stat;

    reg [`ERROR_REG_WIDTH-1:0]  error;
    reg [`INTR_REG_WIDTH-1:0]   interrupt; // this reg can be written, it means we can write C to generate interrupt

    wire [`ERROR_REG_WIDTH-1:0]  err_iw; //internal wire
    wire [`INTR_REG_WIDTH-1:0]   intr_iw; //intr_stat internal wire
    wire    intr_0;
    wire    intr1;

    assign  err_iw  = error;
    assign  intr_iw = interrupt;

    always@(posedge hclk or negedge hresetn)
        begin : error
            if(hresetn == 1'b0)
                begin
                    error <= 32'b0;
                end
            else if(err_clr_reg_en)
                begin
                    error <= 32'b0;
                end
            else
                begin
                    error <= semerr;
                end
        end

    always@(posedge hclk or negedge hresetn)
        begin : interrupt
            if(hresetn == 1'b0)
                interrupt <= 32'b0;
            else if(error != 32'b0)
                interrupt <= `ERROR_PRODUCED;
            else if(int_reg_en && wr_en)
                interrupt <= ihwdata; //used to control interrupt to the target Core
            else if(int_clr_reg_en)
                interrupt <= 32'b0;
        end

    always@(*)
        begin : READ_INE_PROC

            intr_stat = {32{1'b0}};
            error_stat = {32{1'b0}};

            if(int_reg_en == 1'b1)
                intr_stat = intr_iw;
            if(err_reg_en == 1'b1)
                error_stat = err_iw;
        end

    assign intr_0 = (interrupt == `CORE_0_INTR) ? 1'b1 : 1'b0;
    assign intr_1 = (interrupt == `CORE_1_INTR) ? 1'b1 : 1'b0;    


endmodule