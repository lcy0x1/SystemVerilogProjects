class main_env extends uvm_env;

    `uvm_component_utils(main_env)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase (uvm_phase phase);
		`uvm_info(get_name(), $sformatf("Hello UVM ! Simulation has started."), UVM_LOW)
	endtask

endclass