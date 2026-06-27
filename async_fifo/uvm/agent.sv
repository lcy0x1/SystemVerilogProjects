virtual class WriteAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(WriteAgent#(W))

    WriteDriver #(W) driver;
    WriteMonitor #(W) monitor;
    WriteSequencer #(W) sequencer;
    // coverage

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = WriteSequencer#(W)::type_id::create("write_sequencer", this);
            driver = WriteDriver#(W)::type_id::create("write_driver", this);
        end
        monitor = WriteMonitor#(W)::type_id::create("write_monitor", this);
        //coverage = reg_coverage::type_id::create("write_coverage", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
        //monitor.analysis_port.connect(coverage.analysis_export);
    endfunction

endclass

virtual class ReadAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(ReadAgent#(W))

    ReadDriver #(W) driver;
    ReadMonitor #(W) monitor;
    ReadSequencer #(W) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = ReadSequencer#(W)::type_id::create("read_sequencer", this);
            driver = ReadDriver#(W)::type_id::create("read_driver", this);
        end
        monitor = ReadMonitor#(W)::type_id::create("read_monitor", this);
        //coverage = reg_coverage::type_id::create("read_coverage", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
        //monitor.analysis_port.connect(coverage.analysis_export);
    endfunction

endclass

virtual class ResetAgent #(W=7) extends uvm_agent;

    `uvm_component_param_utils(ResetAgent#(W))

    ResetDriver #(W) driver;
    ResetSequencer sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (get_is_active()) begin
            sequencer = ResetSequencer::type_id::create("reset_sequencer", this);
            driver = ResetDriver#(W)::type_id::create("reset_driver", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active())
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass