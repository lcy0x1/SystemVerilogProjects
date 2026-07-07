`ifndef UVM_MULT_AGENT
`define UVM_MULT_AGENT

virtual class MultInputAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(MultInputAgent#(W))

    MultDriver #(W) driver;
    MultInputMonitor #(W) monitor;
    uvm_sequencer #(MultInputTransaction#(W)) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = uvm_sequencer#(MultInputTransaction#(W))::type_id::create("mult_sequencer", this);
            driver = MultDriver#(W)::type_id::create("mult_driver", this);
        end
        monitor = MultInputMonitor#(W)::type_id::create("mult_input_monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass

virtual class MultOutputAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(MultOutputAgent#(W))

    MultOutputMonitor #(W) monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = MultOutputMonitor#(W)::type_id::create("mult_output_monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

endclass

virtual class MultResetAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(MultResetAgent#(W))

    MultResetDriver #(W) driver;
    uvm_sequencer #(MultResetTransaction) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = uvm_sequencer#(MultResetTransaction)::type_id::create("mult_reset_sequencer", this);
            driver = MultResetDriver#(W)::type_id::create("mult_reset_driver", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass

`endif