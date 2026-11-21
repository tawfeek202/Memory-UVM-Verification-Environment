import uvm_pkg::*;
`include "uvm_macros.svh"

//------------------------------------------------------
// Environment Class
//------------------------------------------------------
class mem_env extends uvm_env;
  `uvm_component_utils(mem_env)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  mem_agent agent;
  mem_scoreboard scoreboard;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = mem_agent::type_id::create("agent", this);
    scoreboard = mem_scoreboard::type_id::create("scoreboard", this);
    $display("Iam in the environment class build phase");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("Iam in the environment class connect phase");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
endclass
