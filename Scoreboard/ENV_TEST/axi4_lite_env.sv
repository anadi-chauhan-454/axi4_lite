class axi4_lite_env #(parameter int DATA_WIDTH=32,
                      parameter int ADDR_WIDTH=32)
  extends uvm_env;
  
  `uvm_component_param_utils(axi4_lite_env #(DATA_WIDTH, ADDR_WIDTH))
  
  axi4_lite_agent #(DATA_WIDTH, ADDR_WIDTH) in_agnt;
  axi4_lite_agent #(DATA_WIDTH, ADDR_WIDTH) out_agnt;
  
  axi4_lite_rm #(DATA_WIDTH, ADDR_WIDTH) rm;
  axi4_lite_scb #(DATA_WIDTH, ADDR_WIDTH) scb;
  
  axi4_lite_coverage #(DATA_WIDTH, ADDR_WIDTH) cg;
  
  function new(string name = "axi4_lite_env",
               uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    in_agnt = axi4_lite_agent #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("in_agnt", this);
    out_agnt = axi4_lite_agent #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("out_agnt", this);
    
    rm = axi4_lite_rm #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("rm", this);
    
    scb  = axi4_lite_scb #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("scb", this);
    cg   = axi4_lite_coverage #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("cg", this);

  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    in_agnt.mon.ap.connect(rm.imp);
    rm.ap.connect(scb.exp_imp);
    out_agnt.mon.ap.connect(scb.act_imp);
    out_agnt.mon.ap.connect(cg.analysis_export);
  endfunction
endclass
