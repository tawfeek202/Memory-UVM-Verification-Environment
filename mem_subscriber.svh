import uvm_pkg::*;
`include "uvm_macros.svh"

//------------------------------------------------------
// Subscriber Class
//------------------------------------------------------
class mem_subscriber extends uvm_subscriber #(mem_seq_item);
  // [1] Registration (matches class name)
  `uvm_component_utils(mem_subscriber)

  // [2] Creation
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display("Iam in the subscriber class build phase");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("Iam in the subscriber class connect phase");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

  // Implementation of the pure virtual write method required by uvm_subscriber
  function void write(mem_seq_item t);
    // Functional coverage sampling logic will go here later!
  endfunction

endclass
