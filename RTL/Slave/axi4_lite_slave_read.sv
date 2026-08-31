import axi4_lite_pkg::*;

module axi4_lite_slave_read #(
  parameter int DATA_WIDTH,
  parameter int ADDR_WIDTH
)
  (
    input logic clk,
    input logic rst_n,
    
    //read address channel
    input logic [ADDR_WIDTH-1:0] ar_addr,
    input logic ar_valid,
    
    output logic ar_ready,
    //read data channel
    output logic [DATA_WIDTH-1:0] r_data,
    output logic r_valid,
    output resp_e r_resp,
    
    input logic r_ready,
    //resgiters data
    output logic [ADDR_WIDTH-1:0] reg_raddr,
    
    input logic [DATA_WIDTH-1:0] reg_rdata,
    input resp_e reg_rresp
  );
  
  typedef enum logic[1:0] {
    CAPTURE,
    READ,
    RESP
  } state_e;
  
  state_e state, next_state;
  
  logic [ADDR_WIDTH-1:0] ar_addr_reg;
  logic ar_received;
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      state <= CAPTURE;
      ar_addr_reg <= '0;
      ar_received <= 1'b0;
      
      r_data <= 1'b0;
      r_resp <= OKAY;
    end
    else begin
      state <= next_state;
      if(ar_valid && ar_ready) begin
        ar_addr_reg <= ar_addr;
        ar_received <= 1'b1;
      end
      if(state == READ) begin
        r_data <= reg_rdata;
        r_resp <= reg_rresp;
      end
      
      if(state == RESP && r_ready) begin
        ar_received <= 1'b0;
      end
    end
  end
  
  always_comb begin
    ar_ready = 1'b0;
    
    r_valid = 1'b0;
    reg_raddr = ar_addr_reg;
    
    next_state = state;
    case(state)
      CAPTURE:begin
        ar_ready = !ar_received;
        if(ar_received)
          next_state = READ;
      end
      
      READ:begin
        next_state = RESP;
      end
      
      RESP:begin
        r_valid = 1'b1;
        if (r_valid && r_ready)
          next_state = CAPTURE;
      end
        
      default: begin
        ar_ready = 1'b0;
        next_state = CAPTURE;
      end
    endcase
  end
endmodule
    
 
      
    
