import axi4_lite_pkg::*;

class axi4_lite_sequence #(parameter int DATA_WIDTH = 32,
                           parameter int ADDR_WIDTH = 32)
  extends uvm_sequence #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH));
  
  `uvm_object_param_utils(axi4_lite_sequence #(DATA_WIDTH, ADDR_WIDTH))
  
  int num_tr;
  
  function new(string name = "axi4_lite_sequence");
    super.new(name);
    num_tr = 500;
  endfunction
  
  virtual task body();
    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) seq_item;
    repeat(num_tr) begin
      seq_item = axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("seq_item");
      start_item(seq_item);
      assert(seq_item.randomize())
        else
          `uvm_fatal(get_type_name(), "Randomization Failed");
      finish_item(seq_item);
    end
  endtask
endclass
  
