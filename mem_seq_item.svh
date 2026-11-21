class mem_seq_item extends uvm_sequence_item;

  // [1] Randomized Input Fields (Must be declared BEFORE macros)
  rand mem_op_e                  op;
  rand logic    [ADDR_WIDTH-1:0] address;
  rand logic    [DATA_WIDTH-1:0] data_in;

  // [2] Non-Randomized Output Fields
  logic         [DATA_WIDTH-1:0] data_out;
  logic                          valid_out;

  // [3] Registration with Field Macros
  `uvm_object_param_utils_begin(mem_seq_item)
    `uvm_field_enum(mem_op_e, op, UVM_DEFAULT)
    `uvm_field_int(address, UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(data_in, UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(data_out, UVM_DEFAULT | UVM_HEX)
    `uvm_field_int(valid_out, UVM_DEFAULT)
  `uvm_object_utils_end

  // [4] Constraints
  constraint addr_range_c {address < MEM_DEPTH;}

  constraint default_op_dist_c {
    op dist {
      MEM_WRITE := 40,
      MEM_READ  := 40,
      MEM_IDLE  := 20
    };
  }

  // [5] Constructor
  function new(string name = "mem_seq_item");
    super.new(name);
  endfunction : new

endclass : mem_seq_item
