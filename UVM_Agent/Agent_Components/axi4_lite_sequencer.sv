class axi4_lite_sequencer #(parameter int DATA_WIDTH = 32,
                            parameter int ADDR_WIDTH = 32)
  extends uvm_sequencer #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH));
  
  `uvm_component_param_utils(axi4_lite_sequencer #(DATA_WIDTH, ADDR_WIDTH))
  
  function new(string name = "axi4_lite_sequencer",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
