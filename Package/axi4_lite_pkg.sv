package axi4_lite_pkg;

 import uvm_pkg::*;
`include "uvm_macros.svh"

  typedef enum logic {
    OKAY ,
    DECERR
  } resp_e;

  typedef enum logic {
    AXI_WRITE,
    AXI_READ
  } trans_e;

  `include "axi4_lite_seq_item.sv"
  `include "axi4_lite_sequence.sv"
  `include "axi4_lite_sequencer.sv"
  `include "axi4_lite_driver.sv"
  `include "axi4_lite_coverage.sv"
  `include "axi4_lite_monitor.sv"
  `include "axi4_lite_rm.sv"
  `include "axi4_lite_scb.sv"
  `include "axi4_lite_agent.sv"
  `include "axi4_lite_env.sv"
  `include "axi4_lite_test.sv"

endpackage
