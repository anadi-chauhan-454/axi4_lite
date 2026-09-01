class axi4_lite_driver #(parameter int DATA_WIDTH = 32,
                         parameter int ADDR_WIDTH = 32)
  extends uvm_driver #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH));
  
  `uvm_component_param_utils(axi4_lite_driver #(DATA_WIDTH, ADDR_WIDTH))
  
  virtual axi4_lite_if #(DATA_WIDTH, ADDR_WIDTH) vif; 
  
  function new(string name = "axi4_lite_driver",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual axi4_lite_if #(DATA_WIDTH, ADDR_WIDTH))::get(
      this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Interface Fetch Failed");
    end
  endfunction
  
  task reset();
    wait(!vif.rst_n);
    
    vif.drv_cb.mw_addr <= '0;
    vif.drv_cb.mw_data <= '0;
    vif.drv_cb.mw_strb <= '0;
    
    vif.drv_cb.mr_addr <= '0;
    
    wait(vif.rst_n);
    @(vif.drv_cb);
  endtask
  
  task drive();
    @(vif.drv_cb);
    
    if(req.trans_type == AXI_WRITE) begin
      vif.drv_cb.mw_addr <= req.mw_addr;
      vif.drv_cb.mw_data <= req.mw_data;
      vif.drv_cb.mw_strb <= req.mw_strb;
    end
    
    if(req.trans_type == AXI_READ)
      vif.drv_cb.mr_addr <= req.mr_addr;
    
    @(vif.drv_cb);
  endtask
  
  virtual task run_phase(uvm_phase phase);
    reset();
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask
endclass
      
      
      
    
    
    
