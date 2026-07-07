virtual class AbstractEnv extends uvm_env;

	`uvm_component_abstract_utils(AbstractEnv)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

endclass

class TransposeEnvironment #(W=7) extends AbstractEnv;

    `uvm_component_param_utils(TransposeEnvironment#(W))

	TransposeResetAgent #(W) rst_ctrl;
	TransposeInputAgent #(W) writer;
	TransposeOutputAgent #(W) reader;
	TransposeScoreboard #(W) scoreboard;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_ctrl = TransposeResetAgent#(W)::type_id::create("reset_agent", this);
		writer = TransposeInputAgent#(W)::type_id::create("write_agent", this);
		reader = TransposeOutputAgent#(W)::type_id::create("read_agent", this);
		scoreboard = TransposeScoreboard#(W)::type_id::create("scoreboard", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		writer.monitor.analysis_port.connect(scoreboard.wt_imp);
		reader.monitor.analysis_port.connect(scoreboard.rt_imp);
	endfunction

endclass