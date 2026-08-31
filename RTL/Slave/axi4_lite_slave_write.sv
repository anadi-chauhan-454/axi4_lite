import axi4_lite_pkg::*;

module axi4_lite_slave_write #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH
)
  (
    input logic clk,
    input logic rst_n,
    //write address channel
    input logic [ADDR_WIDTH-1:0] aw_addr,
    input logic aw_valid,
    
    output logic aw_ready,
    //write data channel
    input logic [DATA_WIDTH-1:0] w_data,
    input logic [(DATA_WIDTH/8)-1:0] w_strb,
    input logic w_valid,
    
    output logic w_ready,
    //write response channel
    input logic b_ready,
    
    output logic b_valid,
    output resp_e b_resp,
    //register write signals
    output logic reg_wvalid,
    input resp_e reg_wresp,
    
    output logic [ADDR_WIDTH-1:0] reg_waddr,
    output logic [DATA_WIDTH-1:0] reg_wdata,
    output logic [(DATA_WIDTH/8)-1:0] reg_strb
  );
  
  typedef enum logic[1:0] {
    CAPTURE,
    WRITE,
    RESP
  } state_e;
  
  state_e state, next_state;
  
  logic aw_received, w_received;
  
  logic [ADDR_WIDTH-1:0] aw_addr_reg;
  logic [DATA_WIDTH-1:0] w_data_reg;
  logic [(DATA_WIDTH/8)-1:0] w_strb_reg;
        
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      state <= CAPTURE;
      aw_addr_reg  <= '0;
      w_data_reg   <= '0;
      w_strb_reg   <= '0;

      aw_received  <= 1'b0;
      w_received   <= 1'b0;
    end
    else begin
      state <= next_state;
      if (aw_valid && aw_ready) begin
        aw_addr_reg <= aw_addr;
        aw_received <= 1'b1;
      end
      if (w_valid && w_ready) begin
        w_data_reg  <= w_data;
        w_strb_reg  <= w_strb;
        w_received  <= 1'b1;
      end
      if (state == RESP && b_ready) begin
        aw_received <= 1'b0;
        w_received  <= 1'b0;
      end
    end
  end
  
  always_comb begin
    aw_ready = 1'b0;
    w_ready  = 1'b0;

    reg_wvalid = 1'b0;
    reg_waddr  = aw_addr_reg;
    reg_wdata  = w_data_reg;
    reg_strb   = w_strb_reg;

    b_valid = 1'b0;
    b_resp  = OKAY; 
    
    next_state = state;
    
    case (state)
      CAPTURE: begin
        aw_ready = !aw_received;
        w_ready  = !w_received;
        if (aw_received && w_received)
          next_state = WRITE;
      end
      
      WRITE: begin
        reg_wvalid = 1'b1;
        next_state = RESP;
      end
      
      RESP: begin
        b_valid = 1'b1;
        b_resp  = reg_wresp;
        if (b_valid && b_ready)
          next_state = CAPTURE;
      end
      
      default: begin
        aw_ready = 1'b0;
        w_ready  = 1'b0;
        next_state = CAPTURE;
      end
    endcase
  end
endmodule
