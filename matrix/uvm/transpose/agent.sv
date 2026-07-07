virtual class TransposeInputAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(TransposeInputAgent#(W))

    TransposeDriver #(W) driver;
    TransposeInputMonitor #(W) monitor;
    uvm_sequencer #(TransposeInputTransaction#(W)) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = uvm_sequencer#(TransposeInputTransaction#(W))::type_id::create("transpose_sequencer", this);
            driver = TransposeDriver#(W)::type_id::create("transpose_driver", this);
        end
        monitor = TransposeInputMonitor#(W)::type_id::create("transpose_input_monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass

virtual class TransposeOutputAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(TransposeOutputAgent#(W))

    TransposeOutputMonitor #(W) monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = TransposeOutputMonitor#(W)::type_id::create("transpose_output_monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

endclass

virtual class TransposeResetAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(TransposeResetAgent#(W))

    TransposeResetDriver #(W) driver;
    uvm_sequencer #(TransposeResetTransaction) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = uvm_sequencer#(TransposeResetTransaction)::type_id::create("transpose_reset_sequencer", this);
            driver = TransposeResetDriver#(W)::type_id::create("transpose_reset_driver", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass
