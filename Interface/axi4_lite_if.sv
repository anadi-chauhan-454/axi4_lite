interface axi4_lite_if #(parameter int DATA_WIDTH = 32,
                         parameter int ADDR_WIDTH = 32)
  (
    input logic clk,
    input logic rst_n
  );
  
  logic [ADDR_WIDTH-1:0] mw_addr;
  logic [DATA_WIDTH-1:0] mw_data;
  logic [(DATA_WIDTH/8)-1:0] mw_strb;
  resp_e write_resp;
  
  logic [ADDR_WIDTH-1:0] mr_addr;
  logic [DATA_WIDTH-1:0] mr_data;
  resp_e read_resp;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #1;
    output mw_addr, mw_data, mw_strb;
    input  write_resp;
    output mr_addr;
    input  mr_data;
    input  read_resp;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step output #1;
    input mw_addr, mw_data, mw_strb;
    input write_resp;
    input mr_addr;
    input mr_data;
    input read_resp;
  endclocking
endinterface
