virtual class AbstractEnv extends uvm_env;

	`uvm_component_abstract_utils(AbstractEnv)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual task runSequence(RootSequence seq);
	endtask

endclass

class Environment #(W=7) extends AbstractEnv;

    `uvm_component_param_utils(Environment)

	ResetAgent #(W) rst_ctrl;
	WriteAgent #(W) writer;
	ReadAgent #(W) reader;
	Scoreboard #(W) scoreboard;
	VirtualSequencer #(W) vir_seq;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_ctrl = ResetAgent#(W)::type_id::create("reset_agent", this);
		writer = WriteAgent#(W)::type_id::create("write_agent", this);
		reader = ReadAgent#(W)::type_id::create("read_agent", this);
		scoreboard = Scoreboard#(W)::type_id::create("scoreboard", this);
		vir_seq = VirtualSequencer#(W)::type_id::create("virtual_sequencer", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		writer.monitor.analysis_port.connect(scoreboard.wt_imp);
		reader.monitor.analysis_port.connect(scoreboard.rt_imp);
		vir_seq.rstseq = rst_ctrl.sequencer;
		vir_seq.wseq = writer.sequencer;
		vir_seq.rseq = reader.sequencer;
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf("Hello UVM ! Simulation has started."), UVM_LOW)
	endtask

	virtual task runSequence(RootSequence seq);
		seq.start(vir_seq);
	endtask

endclass