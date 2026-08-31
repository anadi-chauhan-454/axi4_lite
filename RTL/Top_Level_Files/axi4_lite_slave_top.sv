import axi4_lite_pkg::*;

module axi4_lite_slave_top #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH
)
  (
    input logic clk,
    input logic rst_n,
    
    //write side signals sent by master(UVM_TB)
    input logic [ADDR_WIDTH-1:0] aw_addr,
    input logic aw_valid,
    
    input logic [DATA_WIDTH-1:0] w_data,
    input logic [(DATA_WIDTH/8)-1:0] w_strb,
    input logic w_valid,
    
    output resp_e b_resp,
    
    output logic aw_ready,
    output logic w_ready,
    
    output logic b_valid,
    input logic b_ready,
    
    //read side signals sent by master(UVM_TB)
    input logic [ADDR_WIDTH-1:0] ar_addr,
    input logic ar_valid,
    output logic ar_ready,
    
    output logic [DATA_WIDTH-1:0] r_data,
    output logic r_valid,
    output resp_e r_resp,
    input logic r_ready
  );
  
  logic reg_wvalid;
  resp_e reg_wresp;
    
  logic [ADDR_WIDTH-1:0] reg_waddr;
  logic [DATA_WIDTH-1:0] reg_wdata;
  logic [(DATA_WIDTH/8)-1:0] reg_strb;
  
  logic [ADDR_WIDTH-1:0] reg_raddr;
  logic [DATA_WIDTH-1:0] reg_rdata;
  resp_e reg_rresp;
  
  logic [DATA_WIDTH-1:0] control_reg;
  logic [DATA_WIDTH-1:0] status_reg;
  logic [DATA_WIDTH-1:0] config_reg;
  logic [DATA_WIDTH-1:0] data_reg;
  
  
  axi4_lite_slave_write #(.DATA_WIDTH(DATA_WIDTH),
                          .ADDR_WIDTH(ADDR_WIDTH))
  slave_write (
    .clk(clk),
    .rst_n(rst_n),
    .aw_addr(aw_addr),
    .aw_valid(aw_valid),
    .aw_ready(aw_ready),
    
    .w_data(w_data),
    .w_strb(w_strb),
    .w_valid(w_valid),
    .w_ready(w_ready),
    
    .b_valid(b_valid),
    .b_resp(b_resp),
    .b_ready(b_ready),
    
    .reg_wvalid(reg_wvalid),
    .reg_wresp(reg_wresp),
    .reg_waddr(reg_waddr),
    .reg_wdata(reg_wdata),
    .reg_strb(reg_strb)
  );
  
  axi4_lite_slave_read #(.DATA_WIDTH(DATA_WIDTH),
                         .ADDR_WIDTH(ADDR_WIDTH))
  slave_read (
    .clk(clk),
    .rst_n(rst_n),
    .ar_addr(ar_addr),
    .ar_valid(ar_valid),
    .ar_ready(ar_ready),
    
    .r_data(r_data),
    .r_valid(r_valid),
    .r_resp(r_resp),
    .r_ready(r_ready),
   
    .reg_raddr(reg_raddr),
    .reg_rdata(reg_rdata),
    .reg_rresp(reg_rresp)
  );
  
  axi4_lite_slave_registers #(.DATA_WIDTH(DATA_WIDTH),
                         .ADDR_WIDTH(ADDR_WIDTH))
  slave_registers (
    .clk(clk),
    .rst_n(rst_n),
    .reg_wvalid(reg_wvalid),
    .reg_wresp(reg_wresp),
    .reg_waddr(reg_waddr),
    .reg_wdata(reg_wdata),
    .reg_strb(reg_strb),
    .reg_raddr(reg_raddr),
    .reg_rdata(reg_rdata),
    .reg_rresp(reg_rresp),
    .control_reg(control_reg),
    .status_reg(status_reg),
    .config_reg(config_reg),
    .data_reg(data_reg)
  );
endmodule
    
  
  
    
    
  
