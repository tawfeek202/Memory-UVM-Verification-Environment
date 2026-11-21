//------------------------------------------------------
// Sequencer Class
// Included inside mem_pkg.sv
//------------------------------------------------------
class mem_sequencer extends uvm_sequencer #(mem_seq_item);

  `uvm_component_param_utils(mem_sequencer)

  function new(string name = "mem_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  // [3] Phase Methods (Tracing Phase Execution)
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "In build phase", UVM_HIGH)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "In connect phase", UVM_HIGH)
  endfunction : connect_phase

endclass : mem_sequencer
