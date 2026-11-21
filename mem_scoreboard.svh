//------------------------------------------------------
// Scoreboard Class
//------------------------------------------------------
class mem_scoreboard extends uvm_scoreboard;

  // [1] Registration
  `uvm_component_param_utils(mem_scoreboard)

  // [2] Analysis Implementation Port to receive items from Monitor
  uvm_analysis_imp #(mem_seq_item, mem_scoreboard) item_export;

  // [3] Reference Memory Model (Array to simulate expected memory state)
  logic [DATA_WIDTH-1:0] ref_mem[MEM_DEPTH];

  // [4] Constructor
  function new(string name = "mem_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // [5] Build Phase: Create analysis port
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
    `uvm_info(get_type_name(), "Scoreboard build phase: item_export created", UVM_LOW)
  endfunction


  // [6] Write function implementation (triggered automatically when monitor calls write())
  virtual function void write(mem_seq_item item);
    if (item.op == MEM_WRITE) begin
      // Store the written data in our reference model
      ref_mem[item.address] = item.data_in;
      `uvm_info(get_type_name(), $sformatf("SCOREBOARD WRITE: Addr = 0x%0h, Data = 0x%0h",
                                           item.address, item.data_in), UVM_LOW)
    end else if (item.op == MEM_READ) begin
      // Check if data matches the reference model when valid_out is high
      if (item.valid_out) begin
        if (ref_mem[item.address] === item.data_out) begin
          `uvm_info(get_type_name(),
                    $sformatf("PASS: Read Addr = 0x%0h | Expected = 0x%0h | Actual = 0x%0h",
                              item.address, ref_mem[item.address], item.data_out), UVM_LOW)
        end else begin
          `uvm_error(get_type_name(), $sformatf(
                     "FAIL: Read Addr = 0x%0h | Expected = 0x%0h | Actual = 0x%0h",
                     item.address,
                     ref_mem[item.address],
                     item.data_out
                     ))
        end
      end
    end
  endfunction

endclass : mem_scoreboard
