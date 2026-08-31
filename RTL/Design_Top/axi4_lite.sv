`include "axi4_lite_pkg.sv"
`include "axi4_lite_master_write.sv"
`include "axi4_lite_master_read.sv"
`include "axi4_lite_slave_write.sv"
`include "axi4_lite_slave_read.sv"
`include "axi4_lite_slave_registers.sv"
`include "axi4_lite_master_top.sv"
`include "axi4_lite_slave_top.sv"
import axi4_lite_pkg::*;

module axi4_lite #(parameter int DATA_WIDTH = 32,
                   parameter int ADDR_WIDTH = 32)
  (
    input  logic clk,
    input  logic rst_n,
    //master signals for write
    input  logic [ADDR_WIDTH-1:0] mw_addr,
    input  logic [DATA_WIDTH-1:0] mw_data,
    input  logic [(DATA_WIDTH/8)-1:0] mw_strb,
    output resp_e write_resp,
    //master signals for read
    input  logic [ADDR_WIDTH-1:0] mr_addr,
    output logic [DATA_WIDTH-1:0] mr_data,
    output resp_e read_resp
  );
  
  logic [ADDR_WIDTH-1:0] aw_addr;
  logic aw_valid;
  logic aw_ready;
  //write data channel
  logic [DATA_WIDTH-1:0] w_data;
  logic [(DATA_WIDTH/8)-1:0] w_strb;
  logic  w_valid;
  logic  w_ready;
  //write response channel
  logic  b_ready;
  logic  b_valid;
  resp_e b_resp;
  //read address channel
  logic [ADDR_WIDTH-1:0] ar_addr;
  logic ar_valid;
  logic ar_ready;
  //read data and response channel
  logic r_ready;
  logic [DATA_WIDTH-1:0] r_data;
  logic r_valid;
  resp_e r_resp;
  
  axi4_lite_master_top #(.DATA_WIDTH(DATA_WIDTH),
                           .ADDR_WIDTH(ADDR_WIDTH))
  master_write (
    .clk(clk),
    .rst_n(rst_n),

    .mw_addr(mw_addr),
    .mw_data(mw_data),
    .mw_strb(mw_strb),
    .write_resp(write_resp),
    
    .aw_addr(aw_addr),
    .aw_valid(aw_valid),
    .aw_ready(aw_ready),
    
    .w_data(w_data),
    .w_strb(w_strb),
    .w_valid(w_valid),
    .w_ready(w_ready),
    
    .b_ready(b_ready),
    .b_valid(b_valid),
    .b_resp(b_resp),
    
    .mr_addr(mr_addr),
    .mr_data(mr_data),
    .read_resp(read_resp),
    
    .ar_addr(ar_addr),
    .ar_valid(ar_valid),
    .ar_ready(ar_ready),
    
    .r_ready(r_ready),
    .r_data(r_data),
    .r_valid(r_valid),
    .r_resp(r_resp)
  );
  
  axi4_lite_slave_top #(.DATA_WIDTH(DATA_WIDTH),
                          .ADDR_WIDTH(ADDR_WIDTH))
  master_read (
    .clk(clk),
    .rst_n(rst_n),
    
    .aw_addr(aw_addr),
    .aw_valid(aw_valid),
    .aw_ready(aw_ready),
    
    .w_data(w_data),
    .w_strb(w_strb),
    .w_valid(w_valid),
    .w_ready(w_ready),
    
    .b_ready(b_ready),
    .b_valid(b_valid),
    .b_resp(b_resp),
    
    .ar_addr(ar_addr),
    .ar_valid(ar_valid),
    .ar_ready(ar_ready),
    
    .r_ready(r_ready),
    .r_data(r_data),
    .r_valid(r_valid),
    .r_resp(r_resp)
  );
endmodule
  
