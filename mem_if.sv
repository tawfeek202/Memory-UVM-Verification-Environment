interface mem_if (
    input bit clk,
    input bit rst_n
);

  // Package-level parameters
  parameter int DATA_WIDTH = 32;
  parameter int MEM_DEPTH = 64;
  parameter int ADDR_WIDTH = $clog2(MEM_DEPTH);


  // Interface Signals
  logic                  write_en;
  logic                  read_en;
  logic [ADDR_WIDTH-1:0] address;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic                  valid_out;

  // ------------------------------------------------------------------
  // Clocking Block for Driver
  // Drives signals at #1ns after posedge, samples input signals at #1step
  // ------------------------------------------------------------------
  clocking drv_cb @(posedge clk);
    default input #1step output #1ns;
    output write_en;
    output read_en;
    output address;
    output data_in;
    input data_out;
    input valid_out;
  endclocking : drv_cb

  // ------------------------------------------------------------------
  // Clocking Block for Monitor
  // Passively samples all signals at #1step before posedge clk
  // ------------------------------------------------------------------
  clocking mon_cb @(posedge clk);
    default input #1step output #1ns;
    input write_en;
    input read_en;
    input address;
    input data_in;
    input data_out;
    input valid_out;
  endclocking : mon_cb

  // ------------------------------------------------------------------
  // Modports
  // ------------------------------------------------------------------
  // Driver Modport (uses clocking block + raw reset)
  modport drv_mp(clocking drv_cb, input rst_n);

  // Monitor Modport (uses clocking block + raw reset)
  modport mon_mp(clocking mon_cb, input rst_n);

endinterface : mem_if
