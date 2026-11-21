//------------------------------------------------------
// Memory Monitor Class
//------------------------------------------------------
class mem_monitor extends uvm_monitor;

  // [1] Registration
  `uvm_component_param_utils(mem_monitor)

  // [2] Virtual Interface & Analysis Port Handles
  virtual mem_if vif;
  uvm_analysis_port #(mem_seq_item) item_port;

  // [3] Constructor
  function new(string name = "mem_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // [4] Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual mem_if)::get(this, "", "MEM_VIF", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface (MEM_VIF) not found in uvm_config_db!")
    end

    item_port = new("item_port", this);
  endfunction : build_phase

  // [5] Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      mem_seq_item item;

      @(vif.mon_cb);

      if (vif.rst_n === 1'b1) begin
        if (vif.mon_cb.write_en) begin
          item         = mem_seq_item::type_id::create("item");
          item.op      = MEM_WRITE;
          item.address = vif.mon_cb.address;
          item.data_in = vif.mon_cb.data_in;
          item_port.write(item);
        end else if (vif.mon_cb.read_en) begin
          item         = mem_seq_item::type_id::create("item");
          item.op      = MEM_READ;
          item.address = vif.mon_cb.address;

          @(vif.mon_cb);
          item.data_out  = vif.mon_cb.data_out;
          item.valid_out = vif.mon_cb.valid_out;
          item_port.write(item);
        end
      end
    end
  endtask : run_phase

endclass : mem_monitor
