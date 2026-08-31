import axi4_lite_pkg::*;

module axi4_lite_master_write #(
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
  input  resp_e b_resp 
);

  typedef enum logic [1:0] {
    IDLE,
    SEND_ADDR_DATA,
    RECV_RESP
  } state_e;

  state_e state, next_state;

  logic [ADDR_WIDTH-1:0] aw_addr_reg;
  logic [DATA_WIDTH-1:0] w_data_reg;
  logic [(DATA_WIDTH/8)-1:0] w_strb_reg;

  logic aw_done, w_done;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state       <= IDLE;
      aw_addr_reg <= '0;
      w_data_reg  <= '0;
      w_strb_reg  <= '0;
      aw_done     <= 1'b0;
      w_done      <= 1'b0;
      write_resp  <= OKAY;
    end else begin
      state <= next_state;
      if (aw_valid && aw_ready) begin
        aw_addr_reg <= mw_addr;
        aw_done <= 1'b1;
      end
      if (w_valid  && w_ready) begin
        w_data_reg  <= mw_data;
        w_strb_reg  <= mw_strb;
        w_done  <= 1'b1;
      end
      if (b_valid && b_ready) begin
        write_resp <= b_resp;
        aw_done <= 1'b0;
        w_done  <= 1'b0;
      end
    end
  end

  always_comb begin
    next_state = state;
    aw_valid   = 1'b0;
    w_valid    = 1'b0;
    b_ready    = 1'b0;
    aw_addr = aw_addr_reg;
    w_data  = w_data_reg;
    w_strb  = w_strb_reg;
    case (state)
      IDLE: begin
          next_state = SEND_ADDR_DATA;
      end

      SEND_ADDR_DATA: begin
        aw_valid = !aw_done;
        w_valid  = !w_done;
        if ((aw_done || (aw_valid && aw_ready)) && 
            (w_done  || (w_valid  && w_ready))) begin
          next_state = RECV_RESP;
        end
      end

      RECV_RESP: begin
        b_ready = 1'b1;
        if (b_valid && b_ready) begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
endmodule
