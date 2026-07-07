class transpose_test extends uvm_test;

    `uvm_component_utils(transpose_test)

    parameter W = `WIDTH;

    TransposeEnvironment #(W) env;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = TransposeEnvironment#(W)::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

    virtual task run_phase(uvm_phase phase);
		TransposeResetSequence rstseq = TransposeResetSequence::type_id::create("reset_seq");
        TransposeSequence #(W) wseq = TransposeSequence#(W)::type_id::create("write_seq");
		phase.raise_objection(this, "Starting sequence");
		`uvm_info(get_name(), $sformatf("Hello UVM ! Simulation has started."), UVM_LOW)

        `uvm_info(get_name(), "Squence Start", UVM_LOW)
        rstseq.start(env.rst_ctrl.sequencer);
        `uvm_info(get_name(), "Reset Complete", UVM_LOW)
        wseq.start(env.writer.sequencer);
        `uvm_info(get_name(), "Sequence Complete", UVM_LOW)

		phase.drop_objection(this, "Sequence finished");
    endtask

endclass