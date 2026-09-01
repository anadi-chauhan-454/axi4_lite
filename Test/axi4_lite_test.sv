class axi4_lite_test #(parameter int DATA_WIDTH=32,
                       parameter int ADDR_WIDTH=32)
  extends uvm_test;
  
  `uvm_component_param_utils(axi4_lite_test #(DATA_WIDTH, ADDR_WIDTH))
  
  axi4_lite_env #(DATA_WIDTH, ADDR_WIDTH) env;
  axi4_lite_sequence #(DATA_WIDTH, ADDR_WIDTH) seq;
  
  function new(string name="axi4_lite_test",
               uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi4_lite_env #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("env", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = axi4_lite_sequence #(DATA_WIDTH, ADDR_WIDTH)::type_id::create("seq");
    seq.start(env.in_agnt.seqr);
  
    phase.phase_done.set_drain_time(this, 500ns);
    phase.drop_objection(this);
  endtask
endclass

class base_test extends axi4_lite_test#(32, 32);
  `uvm_component_utils(base_test)

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
