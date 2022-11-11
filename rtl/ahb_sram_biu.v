//  ------------------------------------------------------------------------
// File :                       ahb_sram_biu.v
// Author :                     superboy
// Created date :               2022/11/10
// Abstract     :               AHB bus interface module.
// Last Modified : 2022/11/11 14:49
// Description :                Only the ihwdata and hrdata will be the reg
//                              cancel the read reg, implement read func in combinational circuit
// -------------------------------------------------------------------
// -------------------------------------------------------------------
module ahb_sram_biu(
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
    ihrdata,
    ihwdata,
    sram_we,
    sram_cs,
    sram_addr
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

// all these signals down here, will be connected to the regfile.v
    input   [`AHB_DATA_WIDTH-1:0]   ihrdata;
    output  [`AHB_DATA_WIDTH-1:0]   ihwdata;
    output                          sram_we;
    output                          sram_cs;
    output  [9-1:0]                 sram_addr;

//
    wire [`AHB_DATA_WIDTH-1:0]       hrdata;
    wire [`AHB_DATA_WIDTH-1:0]       ihwdata;
    wire [9-1:0]                    sram_addr; //DP=512, log2(512)=9

    // reg     ahb_wr;
    // reg     ahb_rd;
    // reg     ahb_cs;
    // wire    control_wr; // used to save data in reg
    // wire    control_rd;
    // wire    wr_en;
    reg     control_cs;
    reg     control_we;
    // assign  control_wr   = htrans[1] & hsel & hready & hwrite;
    // assign  control_rd   = htrans[1] & hsel & hready & ~hwrite;
    assign  hresp        = 2'b00;
    assign  hreadyout    = 1'b1;

    assign  ihwdata     = hwdata;
    assign  hrdata      = ihrdata;

    assign  sram_cs     = hwrite ? control_cs : htrans[1] & hsel & hready;
    assign  sram_we     = hwrite ? control_we : htrans[1] & hsel & hready & hwrite;

    assign  sram_addr   = (haddr[12-1:0] >> 2);

    always@(posedge hclk or negedge hresetn)
        begin: delay_cs_for_one_cycle
            if(hresetn == 1'b0) 
            begin
                control_cs <= 0;
            end
            else
                control_cs <= htrans[1] & hsel & hready;
            begin
            end
        end

    always@(posedge hclk or negedge hresetn)
        begin: delay_we_for_one_cycle
            if(hresetn == 1'b0) 
            begin
                control_we <= 0;
            end
            else
                control_we <= htrans[1] & hsel & hready & hwrite;
            begin
            end
        end

endmodule
