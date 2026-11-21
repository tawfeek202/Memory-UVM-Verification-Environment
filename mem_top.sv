module mem_top;
  import uvm_pkg::*;
  import mem_pkg::*;
  `include "uvm_macros.svh"

  // Clock Generation
  bit clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset Generation
  logic rst_n;
  initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
  end

  // Interface Instantiation (passing both clk and rst_n)
  mem_if mem_vif (
      clk,
      rst_n
  );

  // DUT Instantiation with Proper Interface Connections
  memory DUT (
      .clk      (mem_vif.clk),
      .rst_n    (mem_vif.rst_n),
      .write_en (mem_vif.write_en),
      .read_en  (mem_vif.read_en),
      .address  (mem_vif.address),
      .data_in  (mem_vif.data_in),
      .data_out (mem_vif.data_out),
      .valid_out(mem_vif.valid_out)
  );

  // Testbench Setup & Test Execution
  initial begin
    uvm_config_db#(virtual mem_if)::set(null, "*", "MEM_VIF", mem_vif);
    run_test("mem_test");
  end

endmodule : mem_top
