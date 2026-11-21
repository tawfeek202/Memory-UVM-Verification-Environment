package mem_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Package-level parameters
  parameter int DATA_WIDTH = 32;
  parameter int MEM_DEPTH = 64;
  parameter int ADDR_WIDTH = $clog2(MEM_DEPTH);

  // Enum definition (defined ONCE here)
  typedef enum logic [1:0] {
    MEM_IDLE  = 2'b00,
    MEM_WRITE = 2'b01,
    MEM_READ  = 2'b10
  } mem_op_e;

  // Include component files
  `include "mem_seq_item.svh"
  `include "mem_sequence.svh"
  `include "mem_sequencer.svh"
  `include "mem_driver.svh"
  `include "mem_monitor.svh"
  `include "mem_agent.svh"
  `include "mem_scoreboard.svh"
  `include "mem_env.svh"
  `include "mem_test.svh"

endpackage : mem_pkg
