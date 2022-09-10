//  ------------------------------------------------------------------------
// File:                        sem_ine.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               HSEM interrupt and error control module.
// Last modified date :         2022/09/09
// Description:                 interrupt will occur when error occurs and task switch 
// -------------------------------------------------------------------
// -------------------------------------------------------------------
module hsem_ine
    (

    );
    input   hclk;
    input   hresetn;
    input   wr_en;
    input   rd_en; //maybe delete later
    input   int_reg_en;
    input   int_clr_reg_en;
    input   err_reg_en;
    input   err_clr_reg_en;
    output  [`ERROR_REG_WIDTH-1:0]  error_stat;
    output  intr; //this signal will directly connect to the top level, connected to the core
    output  [`INTR_REG_WIDTH-1:0]  intr_stat;

    reg [`ERROR_REG_WIDTH-1:0]  error;
    reg [`INTR_REG_WIDTH-1:0]   interrupt; // this reg can be written, it means we can write C to generate interrupt

    wire [`ERROR_REG_WIDTH-1:0]  err_iw; //internal wire
    wire [`INTR_REG_WIDTH-1:0]   intr_iw; //intr_stat internal wire
    wire    intr;

    assign  err_iw  = error;
    assign  intr_iw = interrupt;

    always@(*)
        begin : READ_INE_PROC

            intr_stat = {32{1'b0}};
            error_stat = {32{1'b0}};

            if(int_reg_en == 1'b1)
                intr_stat = intr_iw;
            if(err_reg_en == 1'b1)
                error_stat = err_iw;
        end


endmodule