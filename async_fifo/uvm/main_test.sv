class main_test extends uvm_test;

    `uvm_component_utils(main_test)

    parameter W = `WIDTH;
    parameter P = `POWER;

    DebugEnvironment #(P, W) env;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = DebugEnvironment#(P,W)::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

    virtual task run_phase(uvm_phase phase);
        VirtualSequence #(W) seq = VirtualSequence#(W)::type_id::create("vir_seq");
        seq.conf.count = 1000;
        
        phase.raise_objection(this);
        env.runSequence(seq);
        phase.drop_objection(this);
    endtask

endclass