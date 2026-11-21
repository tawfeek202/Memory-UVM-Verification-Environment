//------------------------------------------------------
// Agent Class
//------------------------------------------------------
class mem_agent extends uvm_agent;

  // [1] Registration
  `uvm_component_param_utils(mem_agent)

  // [2] Constructor
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // [3] Sub-component Handles
  mem_driver    driver;
  mem_monitor   monitor;
  mem_sequencer sequencer;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver    = mem_driver::type_id::create("driver", this);
    monitor   = mem_monitor::type_id::create("monitor", this);
    sequencer = mem_sequencer::type_id::create("sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass : mem_agent
