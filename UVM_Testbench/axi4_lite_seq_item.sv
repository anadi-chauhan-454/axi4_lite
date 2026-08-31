import axi4_lite_pkg::*;

class axi4_lite_seq_item #(parameter int DATA_WIDTH = 32,
                           parameter int ADDR_WIDTH = 32)
  extends uvm_sequence_item;
  
  rand trans_e trans_type;
  
  rand bit [ADDR_WIDTH-1:0] mw_addr;
  rand bit [DATA_WIDTH-1:0] mw_data;
  rand bit [(DATA_WIDTH/8)-1:0] mw_strb;
  
  resp_e write_resp;
  
  rand bit [ADDR_WIDTH-1:0] mr_addr;
  bit [DATA_WIDTH-1:0] mr_data;
  resp_e read_resp;
  
  constraint addr {
    mw_addr inside {[32'h04 : 32'hFC]};
    mw_addr[1:0] == 2'b00;
    mw_strb != '0;
    mr_addr inside {[32'h04 : 32'hFC]};
    mr_addr[1:0] == 2'b00;
  }
  
  
  `uvm_object_param_utils_begin(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH))
  
  `uvm_field_enum(trans_e, trans_type, UVM_ALL_ON)
  `uvm_field_int(mw_addr, UVM_ALL_ON)
  `uvm_field_int(mw_data, UVM_ALL_ON)
  `uvm_field_int(mw_strb, UVM_ALL_ON)
  `uvm_field_enum(resp_e, write_resp, UVM_ALL_ON)
  `uvm_field_int(mr_addr, UVM_ALL_ON)
  `uvm_field_int(mr_data, UVM_ALL_ON)
  `uvm_field_enum(resp_e, read_resp, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name="axi4_lite_seq_item");
    super.new(name);
  endfunction
  
endclass
