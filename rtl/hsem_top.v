//  ------------------------------------------------------------------------
// File :                       sem_top.v
// Author:                      superboy
// Created date :               2022/09/09
// Abstract     :               HSEM top level.
// Last modified date :         2022/09/18
// -------------------------------------------------------------------
// -------------------------------------------------------------------
// `include "hsem_config.v"
module hsem_top(
    hclk,
    hresetn,
    hsel, 
    hready,
    hburst,
    hmastlock,
    hprot,
    htrans,
    hsize,
    hwrite,
    haddr,
    hwdata,
    hreadyout,
    hresp,
    hrdata,
    intr_0,
    intr_1
);
    input               hclk;
    input               hresetn;
    input               hsel; // In fact, hsel is same as hready in functional judgement
    input               hready; // this is the ready_in
    input       [2:0]   hburst; // default is single transfer
    input               hmastlock; //not used
    input       [3:0]   hprot;  // not used
    input       [1:0]   htrans; // only use bit 1 to judge
    input       [2:0]   hsize;  // default is 3'b010 
    input               hwrite; // use to judge direction
    input      [31:0]   haddr;  // Maybe need to use reg to save this
    input      [31:0]   hwdata; // use 
    output              hreadyout; //this is the ready_out, here we assume all the transfer will be single, thus this signal will always 1'b1
    output      [1:0]   hresp; // always send okay:2'b00 
    output     [31:0]   hrdata;

    output  intr_0;
    output  intr_1;

    wire    [`AHB_DATA_WIDTH-1:0]   ihrdata;
    wire    [`AHB_DATA_WIDTH-1:0]   ihwdata;
    wire    wr_en;
    wire    rd_en;
    wire                    [7:0]    reg_addr;
    wire    [`INTR_REG_WIDTH-1:0]    intr_stat_0;
    wire    [`ERROR_REG_WIDTH-1:0]   error_stat_0;
    wire    [`INTR_REG_WIDTH-1:0]    intr_stat_1;
    wire    [`ERROR_REG_WIDTH-1:0]   error_stat_1;
    wire    [`TASK_SWITCH_WIDTH-1:0] tsk_stat;
    wire    int_reg_en_0;
    wire    int_clr_reg_en_0;
    wire    err_reg_en_0;
    wire    err_clr_reg_en_0;
    wire    [`SEMERR_WIDTH-1:0]      semerr_0;
    wire    int_reg_en_1;
    wire    int_clr_reg_en_1;
    wire    err_reg_en_1;
    wire    err_clr_reg_en_1;
    wire    [`SEMERR_WIDTH-1:0]      semerr_1;
    wire    task_en;


    hsem_biu i_hsem_biu(
        .hclk(hclk),
        .hresetn(hresetn),
        .hsel(hsel), 
        .hready(hready),
        .hburst(hburst),
        .hmastlock(hmastlock),
        .hprot(hprot),
        .htrans(htrans),
        .hsize(hsize),
        .hwrite(hwrite),
        .haddr(haddr),
        .hwdata(hwdata),
        .hreadyout(hreadyout),
        .hresp(hresp),
        .hrdata(hrdata),
        .ihrdata(ihrdata),
        .ihwdata(ihwdata),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .reg_addr(reg_addr)
    );

    hsem_regfiles i_hsem_regfiles(
        .hclk(hclk),
        .hresetn(hresetn),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .ihwdata(ihwdata),
        .reg_addr(reg_addr),
        .ihrdata(ihrdata),
        .intr_stat_0(intr_stat_0),
        .error_stat_0(error_stat_0),
        .int_reg_en_0(int_reg_en_0),
        .int_clr_reg_en_0(int_clr_reg_en_0),
        .err_reg_en_0(err_reg_en_0),
        .err_clr_reg_en_0(err_clr_reg_en_0),
        .semerr_0(semerr_0),
        .intr_stat_1(intr_stat_1),
        .error_stat_1(error_stat_1),
        .int_reg_en_1(int_reg_en_1),
        .int_clr_reg_en_1(int_clr_reg_en_1),
        .err_reg_en_1(err_reg_en_1),
        .err_clr_reg_en_1(err_clr_reg_en_1),
        .semerr_1(semerr_1),
        .tsk_stat(tsk_stat),
        .task_en(task_en)
    );

    hsem_ine i_hsem_ine(
        .hclk(hclk),
        .hresetn(hresetn),
        .wr_en(wr_en),
        .ihwdata(ihwdata),
        .int_reg_en_0(int_reg_en_0),
        .int_clr_reg_en_0(int_clr_reg_en_0),
        .err_reg_en_0(err_reg_en_0),
        .err_clr_reg_en_0(err_clr_reg_en_0),
        .semerr_0(semerr_0),
        .error_stat_0(error_stat_0),
        .int_reg_en_1(int_reg_en_1),
        .int_clr_reg_en_1(int_clr_reg_en_1),
        .err_reg_en_1(err_reg_en_1),
        .err_clr_reg_en_1(err_clr_reg_en_1),
        .semerr_1(semerr_1),
        .error_stat_1(error_stat_1),
        .intr_0(intr_0),
        .intr_1(intr_1),
        .intr_stat_0(intr_stat_0),
        .intr_stat_1(intr_stat_1)
    );

    hsem_task i_hsem_task(
        .hclk(hclk),
        .hresetn(hresetn),
        .wr_en(wr_en),
        .ihwdata(ihwdata),
        .task_en(task_en),
        .tsk_stat(tsk_stat)
    );
endmodule