`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class axi4_lite_scb #(parameter int DATA_WIDTH = 32,
                      parameter int ADDR_WIDTH = 32)
  extends uvm_scoreboard;

  `uvm_component_param_utils(axi4_lite_scb #(DATA_WIDTH, ADDR_WIDTH))

  uvm_analysis_imp_exp #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH),
                         axi4_lite_scb #(DATA_WIDTH, ADDR_WIDTH)) exp_imp;

  uvm_analysis_imp_act #(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH),
                         axi4_lite_scb #(DATA_WIDTH, ADDR_WIDTH)) act_imp;

  axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_wr[$];
  axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) act_wr[$];

  axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_rd[$];
  axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) act_rd[$];

  int match_count = 0;
  int mismatch_count = 0;

  function new(string name = "axi4_lite_scb",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    exp_imp = new("exp_imp", this);
    act_imp = new("act_imp", this);
  endfunction

  virtual function void write_exp(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_item);
    if (exp_item.trans_type == AXI_WRITE) begin
      exp_wr.push_back(exp_item);
      compare_write();
    end
    else if (exp_item.trans_type == AXI_READ) begin
      exp_rd.push_back(exp_item);
      compare_read();
    end
  endfunction

  virtual function void write_act(axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) act_item);
    if (act_item.trans_type == AXI_WRITE) begin
      act_wr.push_back(act_item);
      compare_write();
    end
    else if (act_item.trans_type == AXI_READ) begin
      act_rd.push_back(act_item);
      compare_read();
    end
  endfunction

  virtual function void compare_read();
    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_tr;
    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) act_tr;
    if (exp_rd.size() == 0 || act_rd.size() == 0)
      return;
    exp_tr = exp_rd.pop_front();
    act_tr = act_rd.pop_front();

    if ((act_tr.mr_addr   == exp_tr.mr_addr) && (act_tr.mr_data   == exp_tr.mr_data) &&(act_tr.read_resp == exp_tr.read_resp)) begin
      match_count++;
      `uvm_info( "SCB_READ_PASS", $sformatf("READ PASS | ADDR: 0x%0h | RDATA: 0x%0h | RESP: %s",act_tr.mr_addr,act_tr.mr_data,act_tr.read_resp.name()), UVM_LOW)
    end
    else begin
      mismatch_count++;
      `uvm_error("SCB_READ_FAIL", $sformatf( "READ FAIL | EXPECTED: ADDR: 0x%0h DATA: 0x%0h RESP: %s | ACTUAL: ADDR: 0x%0h DATA: 0x%0h RESP: %s",
          exp_tr.mr_addr,
          exp_tr.mr_data,
          exp_tr.read_resp.name(),
          act_tr.mr_addr,
          act_tr.mr_data,
          act_tr.read_resp.name()
        ))
    end
  endfunction

  virtual function void compare_write();

    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) exp_tr;
    axi4_lite_seq_item #(DATA_WIDTH, ADDR_WIDTH) act_tr;
    if (exp_wr.size() == 0 || act_wr.size() == 0)
      return;
    exp_tr = exp_wr.pop_front();
    act_tr = act_wr.pop_front();
    if ((act_tr.mw_addr    == exp_tr.mw_addr) && (act_tr.mw_data    == exp_tr.mw_data) && (act_tr.mw_strb    == exp_tr.mw_strb) && (act_tr.write_resp == exp_tr.write_resp)) begin
      match_count++;
      `uvm_info("SCB_WRITE_PASS",$sformatf( "WRITE PASS | ADDR: 0x%0h|ADDR: 0x%0h | DATA: 0x%0h | DATA: 0x%0h | STRB: %0b | RESP: %s",
          act_tr.mw_addr,
          exp_tr.mw_addr,
          act_tr.mw_data,
          exp_tr.mw_data,
          act_tr.mw_strb,
          act_tr.write_resp.name()
        ),UVM_LOW)
    end
    else begin
      mismatch_count++;
`uvm_error(
  "SCB_WRITE_FAIL",$sformatf("WRITE FAIL | EXPECTED: ADDR=0x%0h DATA=0x%0h STRB=%0b RESP=%s | ACTUAL: ADDR=0x%0h DATA=0x%0h STRB=%0b RESP=%s",
    exp_tr.mw_addr,
    exp_tr.mw_data,
    exp_tr.mw_strb,
    exp_tr.write_resp.name(),
    act_tr.mw_addr,
    act_tr.mw_data,
    act_tr.mw_strb,
    act_tr.write_resp.name()
  ))
    end
  endfunction

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (exp_rd.size() != 0 || act_rd.size() != 0 || exp_wr.size() != 0 || act_wr.size() != 0) begin
      `uvm_error(
        "SCB_LEAK", $sformatf("Unprocessed transactions left in queues! Exp RD: %0d | Act RD: %0d | Exp WR: %0d | Act WR: %0d",
          exp_rd.size(),
          act_rd.size(),
          exp_wr.size(),
          act_wr.size()
        ))
    end
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(
      "SCB_SUMMARY",
      $sformatf("\n----------------------------\nMATCHES:    %0d\nMISMATCHES: %0d\n----------------------------", match_count, mismatch_count), UVM_LOW)
  endfunction

endclass
