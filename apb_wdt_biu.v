module W_DW_apb_wdt_biu
(
 // APB bus bus interface
 pclk,
                      presetn,
                      psel,
                      penable,
                      pwrite, 
                      paddr,
                      pwdata,
                      prdata,
                      pready,
                      pslverr,
                      // regfile interface
                      wr_en,
                      rd_en,
                      byte_en,
                      reg_addr,
                      ipwdata,
                      penable_int,
                      iprdata
                      );

   parameter ADDR_SLICE_LHS = 10;

   // -------------------------------------
   // -- APB bus signals
   // -------------------------------------
   input                            pclk;      // APB clock
   input                            presetn;   // APB reset
   input                            psel;      // APB slave select
   input       [ADDR_SLICE_LHS-1:0] paddr;     // APB address
   input                            pwrite;    // APB write/read
   input                            penable;   // APB enable
   input                      [7:0] pwdata;    // APB write data bus
   // spyglass disable_block W240
   // SMD: An input has been declared but is not read
   // SJ: This signal is assigned to pprot_int only when SLAVE_INTERFACE_TYPE>1 and SLVERR_RESP_EN=1. It will be ignored if SLVERR_RESP_EN=0, which is intended design.
   // spyglass enable_block W240
   output                           pready;    //Slave ready: A low  on this APB3 signal stalls an APB transaction until signal goes high.
   output                           pslverr;   //Slave error: A high on this APB3 signal indicates an error condition on the transfer.
   output     [`APB_DATA_WIDTH-1:0] prdata;    // APB read data bus

   // -------------------------------------
   // -- Register block interface signals
   // -------------------------------------
   input  [`MAX_APB_DATA_WIDTH-1:0] iprdata;   // Internal read data bus
   output                           penable_int; // Internal PENABLE Signal
   output                           wr_en;     // Write enable signal
   output                           rd_en;     // Read enable signal
   output                           byte_en;   // Active byte lane signal
   output      [ADDR_SLICE_LHS-3:0] reg_addr;  // Register address offset
   output                     [7:0] ipwdata;   // Internal write data bus

   // -------------------------------------
   // -- Local registers & wires
   // -------------------------------------
   reg        [`APB_DATA_WIDTH-1:0] prdata;    // Registered prdata output
   reg                        [7:0] ipwdata;   // Internal pwdata bus
   wire                             byte_en;   // Registered byte_en output



   
   
   // --------------------------------------------
   // -- write/read enable
   //
   // -- Generate write/read enable signals from
   // -- psel, penable and pwrite inputs
   // --------------------------------------------
   assign wr_en = psel & ( pwrite);
   assign rd_en = psel & (!pwrite);
   assign penable_int = penable;
    // Slave error is always zero when slave_error response is disabled. Consequently, the slave will always be ready.
   assign pready      = 1'b1;
   assign pslverr     = 1'b0;

   
   // --------------------------------------------
   // -- Register address
   //
   // -- Strips register offset address from the
   // -- APB address bus
   // --------------------------------------------
   assign reg_addr = paddr[ADDR_SLICE_LHS-1:2];

   
   // --------------------------------------------
   // -- APB write data
   //
   // -- ipwdata is zero padded before being
   //    passed through this block
   // --------------------------------------------
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope
   // SJ: ipwdata is intentionally assigned to zero before getting assigned with pwdata.
   always @(pwdata) begin : IPWDATA_PROC
      ipwdata = 8'h0;
      ipwdata[7:0] = pwdata[7:0];
   end
   // spyglass enable_block W415a
   
   // --------------------------------------------
   // -- Set active byte lane
   //
   // -- This bit vector is used to set the active
   // -- byte lanes for write/read accesses to the
   // -- registers
   // --------------------------------------------

   

    // All bytes in the bus are selected when transfer size is maximum. Hence, all byte_en bits are tied to 1.
    assign  byte_en = 1'b1;



   // --------------------------------------------
   // -- APB read data.
   //
   // -- Register data enters this block on a
   // -- 32-bit bus (iprdata). The upper unused
   // -- bit have been zero padded before entering
   // -- this block.  The process below strips the
   // -- active byte lane(s) from the 32-bit bus
   // -- and registers the data out to the APB
   // -- read data bus (prdata).
   // --------------------------------------------
   
   always @(posedge pclk or negedge presetn) begin : PRDATA_PROC
      if(presetn == 1'b0) begin
         prdata <= { `APB_DATA_WIDTH{1'b0} };
      end else begin
         if(rd_en && (!penable) ) begin
                 prdata <= iprdata;
            end
         end
      end
   
   
endmodule // DW_apb_wdt_biu