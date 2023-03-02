//  ------------------------------------------------------------------------
// File :                       sem_biu.v
// Author :                     superboy
// Created date :               2022/09/09
// Abstract     :               AHB bus interface module.
// Last modified date :         2022/09/18
// Description :                Only the ihwdata and hrdata will be the reg
//                              cancel the read reg, implement read func in combinational circuit
// -------------------------------------------------------------------
// -------------------------------------------------------------------
// `include "hsem_config.v"
module hsem_biu(
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
    wr_en,
    rd_en,
    reg_addr
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
    output                          wr_en;
    output                          rd_en;
    output                          reg_addr;    

// 
    reg [`AHB_DATA_WIDTH-1:0]       hrdata;
    wire [`AHB_DATA_WIDTH-1:0]       ihwdata;
    reg [`AHB_SEM_ADDR_WIDTH-1:0]   reg_addr;

    reg     ahb_wr;
    reg     ahb_rd;
    wire    control_wr; // used to save data in reg
    wire    control_rd;

    assign  control_wr   = htrans[1] & hsel & hready & hwrite;
    assign  control_rd   = htrans[1] & hsel & hready & ~hwrite;    
    assign  hresp        = 2'b00;
    assign  hreadyout    = 1'b1;

    always@(posedge hclk or negedge hresetn)
        begin : save_control_in_ahb_wr
            if(hresetn == 1'b0)
                ahb_wr <= 1'b0;
            else if(control_wr == 1'b1)
                ahb_wr <= control_wr;
            else
                ahb_wr <= 1'b0;
        end 

    always@(posedge hclk or negedge hresetn)
        begin : save_control_in_ahb_rd
            if(hresetn == 1'b0)
                ahb_rd <= 1'b0;
            else if(control_rd == 1'b1)
                ahb_rd <= control_rd;
            else
                ahb_rd <= 1'b0;
        end 

    always@(posedge hclk or negedge hresetn)
        begin:reg_addr_control
            if(hresetn == 1'b0)
                reg_addr <= 8'b00000000;
            else if((control_wr||control_rd) == 1'b1)
                reg_addr <= haddr[7:0];
        end
    
    assign  wr_en   = ahb_wr;
    assign  rd_en   = ahb_rd;
    assign  ihwdata = hwdata;

    // always@(posedge hclk or negedge hresetn)
    //     begin: hrdata_control
    //         if(hresetn == 1'b0)
    //             hrdata <= 0;
    //         else if(rd_en == 1'b1)
    //             hrdata <= ihrdata;
    //     end
    
    always@(*)
        begin: hrdata_control
            if(hresetn == 1'b0)
                hrdata = 0;
            else if(rd_en == 1'b1)
                hrdata = ihrdata;
        end

    // always@(posedge hclk or negedge hresetn)
    //     begin: hwdata_control
    //         if(hresetn == 1'b0)
    //             ihwdata <= 0;
    //         else if(wr_en == 1'b1)
    //             ihwdata <= hwdata;
    //     end

endmodule