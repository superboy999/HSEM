//  ------------------------------------------------------------------------
// File :                       shared_mem_top.v
// Author:                      superboy
// Created date :               2022/11/10
// Abstract     :               HSEM top level.
// Last modified date :         2022/11/10
// -------------------------------------------------------------------
// -------------------------------------------------------------------
module shared_mem_top(
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


    wire    [32-1:0]   ihrdata;
    wire    [32-1:0]   ihwdata;
    wire    [32-1:0]                  sram_addr;
    wire                            sram_we;
    wire                            sram_cs;


    ahb_sram_biu i_ahb_sram_biu(
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
        .sram_we(sram_we),
        .sram_cs(sram_cs),
        .sram_addr(sram_addr)
    );

sirv_sim_ram #(
    .FORCE_X2ZERO (1),
    .DP (512),
    .AW (32),
    .MW (4),
    .DW (32) 
)u_sirv_sim_ram (
    .clk   (hclk),
    .din   (ihwdata),
    .addr  (sram_addr),
    .cs    (sram_cs),
    .we    (sram_we),
    .wem   (4'b1111),
    .dout  (ihrdata)
);

endmodule