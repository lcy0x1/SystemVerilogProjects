`ifndef UVM_MULT_ENV
`define UVM_MULT_ENV

virtual class AbstractEnv extends uvm_env;

	`uvm_component_abstract_utils(AbstractEnv)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

endclass

class MultEnvironment #(W=7) extends AbstractEnv;

    `uvm_component_param_utils(MultEnvironment#(W))

	MultResetAgent #(W) rst_ctrl;
	MultInputAgent #(W) writer;
	MultOutputAgent #(W) reader;
	MultReference #(W) reference;
	MultScoreboard #(W) scoreboard;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rst_ctrl = MultResetAgent#(W)::type_id::create("reset_agent", this);
		writer = MultInputAgent#(W)::type_id::create("write_agent", this);
		reader = MultOutputAgent#(W)::type_id::create("read_agent", this);
		reference = MultReference#(W)::type_id::create("reference", this);
		scoreboard = MultScoreboard#(W)::type_id::create("scoreboard", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		writer.monitor.analysis_port.connect(reference.wt_imp);
		reference.rt_port.connect(scoreboard.wt_imp);
		reader.monitor.analysis_port.connect(scoreboard.rt_imp);
	endfunction

endclass

`endif