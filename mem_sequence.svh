//------------------------------------------------------
// Memory Sequence Class (Exhaustive Write/Read Fill)
//------------------------------------------------------
class mem_sequence extends uvm_sequence #(mem_seq_item);


  parameter DATA_WIDTH = 32;
  parameter MEM_DEPTH = 64;


  // [1] Registration
  `uvm_object_param_utils(mem_sequence)

  // [2] Constructor
  function new(string name = "mem_sequence");
    super.new(name);
  endfunction : new

  // [3] Body Task with Exhaustive Fill & Verify Passes
  virtual task body();

    // ----------------------------------------------------
    // Phase 1: WRITE PASS (Fill every memory location)
    // ----------------------------------------------------
    `uvm_info(get_type_name(), "Starting Memory Fill: Writing to all addresses...", UVM_LOW)

    for (int i = 0; i < MEM_DEPTH; i++) begin
      req = mem_seq_item::type_id::create("req");

      start_item(req);

      // Inline constraint forces a WRITE to specific address 'i'
      // Data will still randomize automatically based on your item constraints
      if (!req.randomize() with {
            op == MEM_WRITE;
            address == i[$clog2(MEM_DEPTH)-1:0];
          }) begin
        `uvm_error(get_type_name(), "Randomization failed during Write Pass")
      end

      finish_item(req);
    end

    // ----------------------------------------------------
    // Phase 2: READ PASS (Verify every memory location)
    // ----------------------------------------------------
    `uvm_info(get_type_name(), "Starting Memory Verification: Reading all addresses...", UVM_LOW)

    for (int i = 0; i < MEM_DEPTH; i++) begin
      req = mem_seq_item::type_id::create("req");

      start_item(req);

      // Inline constraint forces a READ from specific address 'i'
      if (!req.randomize() with {
            op == MEM_READ;
            address == i[$clog2(MEM_DEPTH)-1:0];
          }) begin
        `uvm_error(get_type_name(), "Randomization failed during Read Pass")
      end

      finish_item(req);
    end

    `uvm_info(get_type_name(), "Memory Fill and Verification Sequence Completed!", UVM_LOW)

  endtask : body

endclass : mem_sequence
