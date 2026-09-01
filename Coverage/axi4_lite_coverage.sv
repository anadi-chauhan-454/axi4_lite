class axi4_lite_coverage #(parameter int DATA_WIDTH = 32,
                           parameter int ADDR_WIDTH = 32)
  extends uvm_subscriber #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH));

  `uvm_component_param_utils(axi4_lite_coverage #(DATA_WIDTH, ADDR_WIDTH))

  localparam int STRB_WIDTH = DATA_WIDTH/8;
  typedef axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) seq_item_t;

  covergroup axi4_lite_cg with function sample(seq_item_t t);

    trans_type_cp: coverpoint t.trans_type {
      bins write = {AXI_WRITE};
      bins read  = {AXI_READ};
    }

    mwaddr_cp: coverpoint t.mw_addr iff (t.trans_type == AXI_WRITE) {
      bins control_reg = {32'h0000_0000};
      bins status_reg  = {32'h0000_0004};
      bins config_reg  = {32'h0000_0008};
      bins data_reg    = {32'h0000_000C};
      bins invalid = default;
    }

    mwdata_cp: coverpoint t.mw_data iff (t.trans_type == AXI_WRITE) {
      bins zero = {'0};
      bins max  = {'1};
      bins other = default;
    }

    mwstrb_cp: coverpoint t.mw_strb iff (t.trans_type == AXI_WRITE) {
      bins no_bytes = {4'b0000};
      bins byte0 = {4'b0001};
      bins byte1 = {4'b0010};
      bins byte2 = {4'b0100};
      bins byte3 = {4'b1000};
      bins all_bytes = {4'b1111};
      bins multiple_bytes = {
        4'b0011,4'b0110,4'b1100,
        4'b0101,4'b1010,4'b1001,
        4'b0111,4'b1011,4'b1101,4'b1110
      };
    }

    wresp_cp: coverpoint t.write_resp iff (t.trans_type == AXI_WRITE) {
      bins okay   = {OKAY};
      bins decerr = {DECERR};
    }

    mraddr_cp: coverpoint t.mr_addr iff (t.trans_type == AXI_READ) {
      bins control_reg = {32'h0000_0000};
      bins status_reg  = {32'h0000_0004};
      bins config_reg  = {32'h0000_0008};
      bins data_reg    = {32'h0000_000C};
      bins invalid = default;
    }

    mrdata_cp: coverpoint t.mr_data iff (t.trans_type == AXI_READ) {
      bins zero = {'0};
      bins max  = {'1};
      bins other = default;
    }

    rresp_cp: coverpoint t.read_resp iff (t.trans_type == AXI_READ) {
      bins okay   = {OKAY};
      bins decerr = {DECERR};
    }

    write_addr_strb_cross: cross mwaddr_cp,mwstrb_cp;

    write_addr_resp_cross: cross mwaddr_cp,wresp_cp {
      illegal_bins valid_fail =
        (binsof(mwaddr_cp.control_reg) ||
         binsof(mwaddr_cp.status_reg)  ||
         binsof(mwaddr_cp.config_reg)  ||
         binsof(mwaddr_cp.data_reg)) &&
        binsof(wresp_cp.decerr);
    }

    read_addr_resp_cross: cross mraddr_cp,rresp_cp {
      illegal_bins valid_fail =
        (binsof(mraddr_cp.control_reg) ||
         binsof(mraddr_cp.status_reg)  ||
         binsof(mraddr_cp.config_reg)  ||
         binsof(mraddr_cp.data_reg)) &&
        binsof(rresp_cp.decerr);
    }

  endgroup

  function new(string name = "axi4_lite_coverage",
               uvm_component parent = null);
    super.new(name,parent);
    axi4_lite_cg = new();
  endfunction

  virtual function void write(seq_item_t t);
    axi4_lite_cg.sample(t);
    `uvm_info(get_type_name(),
              $sformatf("Current coverage = %0.2f%%",
                        axi4_lite_cg.get_coverage()),
              UVM_MEDIUM)
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
              $sformatf("AXI4-LITE Coverage = %0.2f%%",
                        axi4_lite_cg.get_coverage()),
              UVM_NONE)
  endfunction

endclass
