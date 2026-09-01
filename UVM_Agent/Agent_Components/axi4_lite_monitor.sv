class axi4_lite_monitor #(parameter int DATA_WIDTH = 32,
                          parameter int ADDR_WIDTH = 32)
  extends uvm_monitor;
  
  `uvm_component_param_utils(axi4_lite_monitor #(DATA_WIDTH, ADDR_WIDTH))
  
  uvm_analysis_port #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH)) ap;
  virtual axi4_lite_mon_if #(DATA_WIDTH, ADDR_WIDTH) mon_vif;
  
  function new(string name = "axi4_lite_monitor",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);

    if(!uvm_config_db #(virtual axi4_lite_mon_if #(DATA_WIDTH, ADDR_WIDTH))::get(
      this, "", "mon_vif", mon_vif)) begin
      `uvm_fatal(get_type_name(), "Interface Fetch Failed");
    end
  endfunction
  
   task monitor_write();

    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) write_item;

    forever begin

        write_item =
            axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH)::type_id::create(
                "write_item"
            );
		
        write_item.trans_type = AXI_WRITE;

        fork

            begin
                do @(mon_vif.mon_cb);
                while (!(mon_vif.mon_cb.aw_valid &&
                         mon_vif.mon_cb.aw_ready) &&
                       mon_vif.rst_n);

                write_item.mw_addr = mon_vif.mon_cb.aw_addr;
            end

            begin
                do @(mon_vif.mon_cb);
                while (!(mon_vif.mon_cb.w_valid &&
                         mon_vif.mon_cb.w_ready) &&
                       mon_vif.rst_n);

                write_item.mw_data = mon_vif.mon_cb.w_data;
                write_item.mw_strb = mon_vif.mon_cb.w_strb;
            end

        join

        if (!mon_vif.rst_n)
            continue;

        do @(mon_vif.mon_cb);
        while (!(mon_vif.mon_cb.b_valid &&
                 mon_vif.mon_cb.b_ready) &&
               mon_vif.rst_n);

        if (!mon_vif.rst_n)
            continue;

        write_item.write_resp = mon_vif.mon_cb.b_resp;
        ap.write(write_item);
    end

endtask

  task monitor_read();

    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) read_item;

    forever begin

        read_item =
            axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH)::type_id::create(
                "read_item"
            );

        read_item.trans_type = AXI_READ;

        do @(mon_vif.mon_cb);
        while (!(mon_vif.mon_cb.ar_valid &&
                 mon_vif.mon_cb.ar_ready) &&
               mon_vif.rst_n);

        if (!mon_vif.rst_n)
            continue;

        read_item.mr_addr = mon_vif.mon_cb.ar_addr;

        do @(mon_vif.mon_cb);
        while (!(mon_vif.mon_cb.r_valid &&
                 mon_vif.mon_cb.r_ready) &&
               mon_vif.rst_n);

        if (!mon_vif.rst_n)
            continue;

        read_item.mr_data   = mon_vif.mon_cb.r_data;
        read_item.read_resp = mon_vif.mon_cb.r_resp;

        ap.write(read_item);

    end

endtask
  
  virtual task run_phase(uvm_phase phase);
    fork
      monitor_write();
      monitor_read();
    join
  endtask
endclass
      
      
      
    
    
    
