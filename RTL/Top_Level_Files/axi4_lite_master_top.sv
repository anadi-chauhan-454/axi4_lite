import axi4_lite_pkg::*;

module axi4_lite_master_top #(
  parameter int DATA_WIDTH = 32,
  parameter int ADDR_WIDTH = 32
) (
  input  logic clk,
  input  logic rst_n,
  //master signals for write
  input  logic [ADDR_WIDTH-1:0] mw_addr,
  input  logic [DATA_WIDTH-1:0] mw_data,
  input  logic [(DATA_WIDTH/8)-1:0] mw_strb,
  output resp_e write_resp,
  //write address chaneel
  output logic [ADDR_WIDTH-1:0] aw_addr,
  output logic aw_valid,
  input  logic aw_ready,
  //write data channel
  output logic [DATA_WIDTH-1:0] w_data,
  output logic [(DATA_WIDTH/8)-1:0] w_strb,
  output logic  w_valid,
  input  logic  w_ready,
  //write response channel
  output logic  b_ready,
  input  logic  b_valid,
  input  resp_e b_resp,
  //master signals for read
  input  logic [ADDR_WIDTH-1:0] mr_addr,
  output logic [DATA_WIDTH-1:0] mr_data,
  output resp_e read_resp,
  //read address channel
  output logic [ADDR_WIDTH-1:0] ar_addr,
  output logic ar_valid,
  input  logic ar_ready,
  //read data and response channel
  output logic r_ready,
  input  logic [DATA_WIDTH-1:0] r_data,
  input  logic r_valid,
  input resp_e r_resp
);
  
  axi4_lite_master_write #(.DATA_WIDTH(DATA_WIDTH),
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
    .b_resp(b_resp)
  );
  
  axi4_lite_master_read #(.DATA_WIDTH(DATA_WIDTH),
                          .ADDR_WIDTH(ADDR_WIDTH))
  master_read (
    .clk(clk),
    .rst_n(rst_n),
    
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
endmodule
  
