module ahb_rom_slv_if #(parameter p_AW = 15) (
   input               hclk,       // system bus clock
   input               hresetn,    // system bus reset
   input               hsel,       // AHB peripheral select
   input               hready,     // AHB ready input
   input       [2:0]   hburst,     // AHB burst, not used         
   input               hmastlock,  // AHB lock transfer, not used             
   input       [3:0]   hprot,      // AHB protect, not used           
   input       [1:0]   htrans,     // AHB transfer type
   input       [2:0]   hsize,      // AHB hsize, not used
   input               hwrite,     // AHB hwrite, not used
   input      [31:0]   haddr,      // AHB address bus
   input      [31:0]   hwdata,     // AHB write data bus, not used
   output              hreadyout,  // AHB ready output to S->M mux
   output      [1:0]   hresp,      // AHB response
   output     [31:0]   hrdata,     // AHB read data bus

   input      [31:0]   rom_rdata,  // ROM Read Data
   output [p_AW-3:0]   rom_addr,   // ROM address
   output              rom_cs      // ROM Chip Select  (active high)
);

// ----------------------------------------------------------
// Internal state
// ----------------------------------------------------------
wire   ahb_access;
wire   error_resp;

reg    err_resp_s1;
reg    err_resp_s2;

// ----------------------------------------------------------
// Read/write control logic
// ----------------------------------------------------------
assign ahb_access = htrans[1] & hsel & hready;
assign rom_addr   = haddr[p_AW-1:2];

assign rom_cs     = ~hwrite & hsel;

// ----------------------------------------------------------
// AHB response
// ----------------------------------------------------------
// ERROR response should last for 2 hclk cycles 
always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) 
        err_resp_s1 <= 1'b0;
    else if (err_resp_s1) //One cycle high-pulse
        err_resp_s1 <= 1'b0;    
    else 
        err_resp_s1 <= hwrite & ahb_access;
end

always @ (posedge hclk or negedge hresetn) begin
    if (hresetn == 1'b0) 
        err_resp_s2 <= 1'b0;
    else 
        err_resp_s2 <= err_resp_s1;
end

assign error_resp = err_resp_s1 | err_resp_s2;
assign hrdata     = rom_rdata;
assign hreadyout  = ~err_resp_s1;
assign hresp      = {1'b0, error_resp};

endmodule