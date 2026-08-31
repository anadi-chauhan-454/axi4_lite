interface axi4_lite_mon_if #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32
)(
    input logic clk,
    input logic rst_n
);

    logic [ADDR_WIDTH-1:0] aw_addr;
    logic                  aw_valid;
    logic                  aw_ready;

    logic [DATA_WIDTH-1:0] w_data;
    logic [(DATA_WIDTH/8)-1:0] w_strb;
    logic                  w_valid;
    logic                  w_ready;

    logic                  b_valid;
    logic                  b_ready;
    resp_e                 b_resp;

    logic [ADDR_WIDTH-1:0] ar_addr;
    logic                  ar_valid;
    logic                  ar_ready;

    logic [DATA_WIDTH-1:0] r_data;
    logic                  r_valid;
    logic                  r_ready;
    resp_e                 r_resp;
  
  property aw_stable;
    @(posedge clk) disable iff(!rst_n) aw_valid && !aw_ready |=> aw_valid && $stable(aw_addr);
  endproperty
  property w_stable;
    @(posedge clk) disable iff(!rst_n) w_valid && !w_ready |=> w_valid && $stable(w_data) && $stable(w_strb);
  endproperty
  property b_stable;
    @(posedge clk) disable iff(!rst_n) b_valid && !b_ready |=> b_valid && $stable(b_resp);
  endproperty
  property ar_stable;
    @(posedge clk) disable iff(!rst_n) ar_valid && !ar_ready |=> ar_valid && $stable(ar_addr);
  endproperty
  property r_stable;
    @(posedge clk) disable iff(!rst_n) r_valid && !r_ready |=> r_valid && $stable(r_data) && $stable(r_resp);
  endproperty
  property reset_assertion;
    @(posedge clk) (!rst_n) |-> !(aw_valid | w_valid | b_valid | ar_valid | r_valid |                                   aw_ready | w_ready | b_ready | ar_ready | r_ready);
  endproperty
  
  assert property (aw_stable)
    else `uvm_fatal("AXI assertion", "write adress handshake error");
  assert property (w_stable)
    else `uvm_fatal("AXI assertion", "write data and strb handshake error");
  assert property (w_stable)
    else `uvm_fatal("AXI assertion", "write response handshake error");
  assert property (w_stable)
    else `uvm_fatal("AXI assertion", "read addr handshake error");
  assert property (w_stable)
    else `uvm_fatal("AXI assertion", "read data and resp handshake error");
    
  cover property (
    @(posedge clk) disable iff(!rst_n) aw_valid && aw_ready
  );
  cover property (
    @(posedge clk) disable iff(!rst_n) w_valid && w_ready
  );
  cover property (
    @(posedge clk) disable iff(!rst_n) b_valid && b_ready
  );  
  cover property (
    @(posedge clk) disable iff(!rst_n) ar_valid && ar_ready
  );  
  cover property (
    @(posedge clk) disable iff(!rst_n) r_valid && r_ready
  );  
    
    
  clocking mon_cb @(posedge clk);
    default input #1step output #1;
    input aw_addr; 
    input aw_valid;
    input aw_ready;

    input w_data;
    input w_strb;
    input w_valid;
    input w_ready;

    input b_valid;
    input b_ready;
    input b_resp;

    input ar_addr;
    input ar_valid;
    input ar_ready;

    input r_data;
    input r_valid;
    input r_ready;
    input r_resp;

endclocking

endinterface

module axi4_lite_bind #(
    parameter int DATA_WIDTH = 32,
    parameter int ADDR_WIDTH = 32
)(
    axi4_lite_mon_if mon_if,

    input logic [ADDR_WIDTH-1:0] aw_addr,
    input logic                  aw_valid,
    input logic                  aw_ready,

    input logic [DATA_WIDTH-1:0] w_data,
    input logic [(DATA_WIDTH/8)-1:0] w_strb,
    input logic                  w_valid,
    input logic                  w_ready,

    input logic                  b_valid,
    input logic                  b_ready,
    input resp_e                 b_resp,

    input logic [ADDR_WIDTH-1:0] ar_addr,
    input logic                  ar_valid,
    input logic                  ar_ready,

    input logic [DATA_WIDTH-1:0] r_data,
    input logic                  r_valid,
    input logic                  r_ready,
    input resp_e                 r_resp
);

    assign mon_if.aw_addr  = aw_addr;
    assign mon_if.aw_valid = aw_valid;
    assign mon_if.aw_ready = aw_ready;

    assign mon_if.w_data   = w_data;
    assign mon_if.w_strb   = w_strb;
    assign mon_if.w_valid  = w_valid;
    assign mon_if.w_ready  = w_ready;

    assign mon_if.b_valid  = b_valid;
    assign mon_if.b_ready  = b_ready;
    assign mon_if.b_resp   = b_resp;

    assign mon_if.ar_addr  = ar_addr;
    assign mon_if.ar_valid = ar_valid;
    assign mon_if.ar_ready = ar_ready;

    assign mon_if.r_data   = r_data;
    assign mon_if.r_valid  = r_valid;
    assign mon_if.r_ready  = r_ready;
    assign mon_if.r_resp   = r_resp;

endmodule

bind axi4_lite axi4_lite_bind monitor_bind (
    .mon_if(tb_top.mon_vif),

    .aw_addr (aw_addr),
    .aw_valid(aw_valid),
    .aw_ready(aw_ready),

    .w_data  (w_data),
    .w_strb  (w_strb),
    .w_valid (w_valid),
    .w_ready (w_ready),

    .b_valid (b_valid),
    .b_ready (b_ready),
    .b_resp  (b_resp),

    .ar_addr (ar_addr),
    .ar_valid(ar_valid),
    .ar_ready(ar_ready),

    .r_data  (r_data),
    .r_valid (r_valid),
    .r_ready (r_ready),
    .r_resp  (r_resp)
);
