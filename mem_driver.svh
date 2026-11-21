//------------------------------------------------------
// Memory Driver Class
//------------------------------------------------------
class mem_driver extends uvm_driver #(mem_seq_item);

  // [1] Registration
  `uvm_component_param_utils(mem_driver)

  virtual mem_if vif;

  // [3] Constructor
  function new(string name = "mem_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // [4] Build Phase: Get Virtual Interface from Config DB
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual mem_if)::get(this, "", "MEM_VIF", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface (MEM_VIF) not found in uvm_config_db!")
    end
  endfunction : build_phase

  // [5] Run Phase: Receive items and drive signals to DUT
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Initial default values for signals
    vif.drv_cb.write_en <= 1'b0;
    vif.drv_cb.read_en  <= 1'b0;
    vif.drv_cb.address  <= '0;
    vif.drv_cb.data_in  <= '0;

    forever begin
      wait (vif.rst_n === 1'b1);
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);

      if (req.op == MEM_WRITE) begin
        vif.drv_cb.write_en <= 1'b1;
        vif.drv_cb.read_en  <= 1'b0;
        vif.drv_cb.address  <= req.address;
        vif.drv_cb.data_in  <= req.data_in;
      end else if (req.op == MEM_READ) begin
        vif.drv_cb.write_en <= 1'b0;
        vif.drv_cb.read_en  <= 1'b1;
        vif.drv_cb.address  <= req.address;
        vif.drv_cb.data_in  <= '0;
      end else begin  // MEM_IDLE
        vif.drv_cb.write_en <= 1'b0;
        vif.drv_cb.read_en  <= 1'b0;
        vif.drv_cb.address  <= '0;
        vif.drv_cb.data_in  <= '0;
      end

      @(vif.drv_cb);
      vif.drv_cb.write_en <= 1'b0;
      vif.drv_cb.read_en  <= 1'b0;

      seq_item_port.item_done();
    end
  endtask : run_phase

endclass : mem_driver
