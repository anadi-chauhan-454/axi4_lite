class axi4_lite_rm #(parameter int DATA_WIDTH = 32,
                     parameter int ADDR_WIDTH = 32)
  extends uvm_component;

  `uvm_component_param_utils(axi4_lite_rm #(DATA_WIDTH, ADDR_WIDTH))

  uvm_analysis_imp #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH),
                     axi4_lite_rm #(DATA_WIDTH, ADDR_WIDTH)) imp;

  uvm_analysis_port #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH)) ap;

  bit [DATA_WIDTH-1:0] mem [0:7];

  function new(string name = "axi4_lite_rm",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    imp = new("imp", this);
    ap  = new("ap", this);

    foreach (mem[i])
      mem[i] = '0;
  endfunction

  virtual function void write( axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) seq_item);

    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_item;
    $cast(exp_item, seq_item.clone());
    if (seq_item.trans_type == AXI_WRITE) begin
      if (seq_item.mw_addr <= 'hFF) begin
        for (int i = 0; i < DATA_WIDTH/8; i++) begin
          if (seq_item.mw_strb[i]) begin
            mem[seq_item.mw_addr[4:2]][i*8 +: 8] =
              seq_item.mw_data[i*8 +: 8];
          end
        end
        exp_item.write_resp = OKAY;
      end
      else begin
        exp_item.write_resp = DECERR;
      end
    end

    else if (seq_item.trans_type == AXI_READ) begin
      if (seq_item.mr_addr <= 'hFF) begin
        exp_item.mr_data = mem[seq_item.mr_addr[4:2]];
        exp_item.read_resp = OKAY;
      end
      else begin
        exp_item.mr_data = '0;
        exp_item.read_resp = DECERR;
      end
    end

    ap.write(exp_item);

  endfunction

endclass
