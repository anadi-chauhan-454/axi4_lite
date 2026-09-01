class axi4_lite_agent #(parameter int DATA_WIDTH = 32,
                        parameter int ADDR_WIDTH = 32)
  extends uvm_agent;
  
  `uvm_component_param_utils(axi4_lite_agent #(DATA_WIDTH, ADDR_WIDTH))
  
  axi4_lite_sequencer #(DATA_WIDTH, ADDR_WIDTH) seqr;
  axi4_lite_driver #(DATA_WIDTH, ADDR_WIDTH) drv;
  axi4_lite_monitor #(DATA_WIDTH, ADDR_WIDTH) mon;
  
  function new(string name = "axi4_lite_agent",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon = axi4_lite_monitor #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("mon", this);
    
    if(get_is_active() == UVM_ACTIVE) begin
      seqr = axi4_lite_sequencer #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("seqr", this);
      drv  = axi4_lite_driver    #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("drv", this);
    end
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
