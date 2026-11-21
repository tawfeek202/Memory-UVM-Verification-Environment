import uvm_pkg::*;
`include "uvm_macros.svh"

//------------------------------------------------------
// Memory Test Class
//------------------------------------------------------
class mem_test extends uvm_test;
  `uvm_component_utils(mem_test)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  mem_env env;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = mem_env::type_id::create("env", this);
    $display("Iam in the test class build phase");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $display("Iam in the test class connect phase");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    begin
      mem_sequence seq;
      seq = mem_sequence::type_id::create("seq");
      phase.raise_objection(this);
      seq.start(env.agent.sequencer);
      phase.drop_objection(this);
    end

  endtask

endclass
