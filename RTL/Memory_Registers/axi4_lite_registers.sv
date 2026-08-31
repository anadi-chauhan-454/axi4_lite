import axi4_lite_pkg::*;

module axi4_lite_slave_registers #(
  parameter int DATA_WIDTH = 32,
  parameter int ADDR_WIDTH = 32
)(
  input  logic clk,
  input  logic rst_n,

  input  logic [ADDR_WIDTH-1:0] reg_waddr,
  input  logic [DATA_WIDTH-1:0] reg_wdata,
  input  logic [(DATA_WIDTH/8)-1:0] reg_strb,
  input  logic reg_wvalid,

  output resp_e reg_wresp,

  input  logic [ADDR_WIDTH-1:0] reg_raddr,

  output logic [DATA_WIDTH-1:0] reg_rdata,
  output resp_e reg_rresp,

  output logic [DATA_WIDTH-1:0] control_reg,
  output logic [DATA_WIDTH-1:0] status_reg,
  output logic [DATA_WIDTH-1:0] config_reg,
  output logic [DATA_WIDTH-1:0] data_reg
);

  logic [DATA_WIDTH-1:0] mem [0:7];

  localparam logic [ADDR_WIDTH-1:0] ADDR_MAX = 'hFF;

  assign control_reg = mem[0];
  assign status_reg  = mem[1];
  assign config_reg  = mem[2];
  assign data_reg    = mem[3];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (int i = 0; i < 8; i++) begin
        mem[i] <= '0;
      end
    end
    else if (reg_wvalid && (reg_waddr <= ADDR_MAX)) begin
      for (int i = 0; i < DATA_WIDTH/8; i++) begin
        if (reg_strb[i]) begin
          mem[reg_waddr[4:2]][i*8 +: 8] <= reg_wdata[i*8 +: 8];
        end
      end
    end
  end

  always_comb begin
    if (reg_wvalid && (reg_waddr <= ADDR_MAX))
      reg_wresp = OKAY;
    else if (reg_wvalid)
      reg_wresp = DECERR;
    else
      reg_wresp = OKAY;
  end

  always_comb begin
    reg_rdata = '0;
    reg_rresp = OKAY;

    if (reg_raddr <= ADDR_MAX) begin
      reg_rdata = mem[reg_raddr[4:2]];
    end
    else begin
      reg_rresp = DECERR;
    end
  end

endmodule
