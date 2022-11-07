//  ------------------------------------------------------------------------
// File:                        tb.v
// Author:                      superboy
// Created date :               2022/09/21
// Abstract     :               Testbench for verifying the hsem module.
// Last modified date :         2022/09/21
// Description:                 Assume the base_addr of the hsem is 0x10002000
// Test List :                  1.all reg write and read
//                              2.AHB 2-stage write read
// -------------------------------------------------------------------
// -------------------------------------------------------------------
`include "sem_config.v"

module hsem_tb();

    reg               hclk;
    reg               hresetn;
    reg               hsel; // In fact, hsel is same as hready in functional judgement
    reg               hready; // this is the ready_in
    reg       [2:0]   hburst; // default is single transfer
    reg               hmastlock; //not used
    reg       [3:0]   hprot;  // not used
    reg       [1:0]   htrans; // only use bit 1 to judge
    reg       [2:0]   hsize;  // default is 3'b010 
    reg               hwrite; // use to judge direction
    reg      [31:0]   haddr;  // Maybe need to use reg to save this
    reg      [31:0]   hwdata; // use 
    wire              hreadyout; //this is the ready_out, here we assume all the transfer will be single, thus this signal will always 1'b1
    wire      [1:0]   hresp; // always send okay:2'b00 
    wire     [31:0]   hrdata;
    wire  intr_0;
    wire  intr_1;

    // // resource_0
    // haddr <= 32'h10002000; // phase_0
    // hsel <= 1;
    // hready <= 1;
    // hburst <= 3'b000;
    // htrans <= 2'b10;
    // hsize <= 3'b010;
    // hwrite <= 1;
    // #10;
    // hwdata <= 32'b1;

    always #5 hclk = ~hclk;

    initial begin
        hclk <= 1;
        hresetn <=0; 
        #10;
        hresetn <=1;
        #10;
        // resource_0
        haddr <= 32'h10002000; // phase_0
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 1;
        #10;
        hwdata <= 32'b1;
        haddr <= 32'h10002000; // phase_1
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 1;
        #10;
        // resource_1
        hwdata <= 32'haa00;
        haddr <= 32'h10002020; // read intr status
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
        #10;
        // resource_1
        haddr <= 32'h10002028; // read err
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
        #10;
        // resource_1
        haddr <= 32'h1000202c; // clear err
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
        #10;
        // resource_1
        haddr <= 32'h10002024; // clear intr
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
        #10;
        // resource_1
        haddr <= 32'h10002030; // read hsem0 status
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
        #10;
        // resource_1
        haddr <= 32'h10002044; // read hsem0 status
        hsel <= 1;
        hready <= 1;
        hburst <= 3'b000;
        htrans <= 2'b10;
        hsize <= 3'b010;
        hwrite <= 0;
    end

    // initial begin
    //     hclk <= 1;
    //     hresetn <=0; 
    //     #10;
    //     hresetn <=1;
    //     #10;
    //     // resource_0
    //     haddr <= 32'h10002000; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002004; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_1
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002008; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1;
    //     haddr <= 32'h1000200c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_0
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002010; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002014; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_1
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002018; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1;
    //     haddr <= 32'h1000201c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_0
    //     hwdata <= 32'b1;
    //     haddr <= 32'h10002020; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1001;
    //     haddr <= 32'h10002024; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_1
    //     hwdata <= 32'b1010;
    //     haddr <= 32'h10002028; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1011;
    //     haddr <= 32'h1000202c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_0
    //     hwdata <= 32'b1100;
    //     haddr <= 32'h10002030; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1101;
    //     haddr <= 32'h10002034; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     // resource_1
    //     hwdata <= 32'b1110;
    //     haddr <= 32'h10002038; // phase_0
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 1;
    //     #10;
    //     hwdata <= 32'b1111;
    //     haddr <= 32'h10002000; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002004; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002008; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     hwdata <= 32'b1111;
    //     haddr <= 32'h1000200c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002010; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002014; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     hwdata <= 32'b1111;
    //     haddr <= 32'h10002018; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h1000201c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002020; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     hwdata <= 32'b1111;
    //     haddr <= 32'h10002024; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002028; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h1000202c; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     hwdata <= 32'b1111;
    //     haddr <= 32'h10002030; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002034; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     haddr <= 32'h10002038; // phase_1
    //     hsel <= 1;
    //     hready <= 1;
    //     hburst <= 3'b000;
    //     htrans <= 2'b10;
    //     hsize <= 3'b010;
    //     hwrite <= 0;
    //     #10;
    //     hsel <= 0;

    // end

    hsem_top i_hsem_top(
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
    .intr_0(intr_0),
    .intr_1(intr_1)
    );
endmodule