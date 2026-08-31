import axi4_lite_pkg::*;

module axi4_lite_master_read #(
  parameter int DATA_WIDTH = 32,
  parameter int ADDR_WIDTH = 32
) (
  input  logic clk,
  input  logic rst_n,
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
  
  typedef enum {
    IDLE,
    READ_DATA_RESP
  } state_e;
  state_e state, next_state;
  
  logic [ADDR_WIDTH-1:0] ar_addr_reg;
  logic ar_done;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      state <= IDLE;
      ar_addr_reg <= '0;
      ar_done <= 0;
      mr_data <= '0;
      read_resp <= OKAY;
    end
    else begin
      state <= next_state;
      if(ar_valid && ar_ready) begin
        ar_addr_reg <= mr_addr;
        ar_done <= 1'b1;
      end
      
      if(r_valid && r_ready) begin
        mr_data <= r_data;
        read_resp <= r_resp;
        ar_done <= 1'b0;
      end
    end
  end
  
  always_comb begin
    next_state = state;
    ar_addr = ar_addr_reg;
    ar_valid  =  0;
    r_ready   =  0;
    case(state)
      IDLE: begin
        next_state = READ_DATA_RESP;
      end
      
      READ_DATA_RESP: begin
        ar_valid = !ar_done;
        r_ready = 1'b1;
        if ((ar_done || (ar_valid && ar_ready)) &&
            (r_valid  && r_ready))  begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
endmodule
    
    
    
    
