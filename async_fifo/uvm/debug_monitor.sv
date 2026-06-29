virtual class AbstractDebugMonitor #(P=2, type T = uvm_sequence_item) extends uvm_monitor;

    `uvm_component_abstract_param_utils(AbstractDebugMonitor#(P,T))

    virtual debug_bus #(P) vif;

    uvm_analysis_port #(T) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual debug_bus #(P))::get(this, "", "debug", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface debug_bus")
        end
        analysis_port = new("analysis_port", this);
    endfunction

endclass

class WriteDebugMonitor #(P=2) extends AbstractDebugMonitor #(P, WriteIndexTransaction #(P));

    `uvm_component_param_utils(WriteDebugMonitor#(P))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        WriteIndexTransaction#(P) tr;

        forever begin
            @(posedge vif.clk_w);
            tr = WriteIndexTransaction#(P)::type_id::create("tr", this);
            tr.ptr = vif.bwptr;
            analysis_port.write(tr);
        end
    endtask

endclass

class ReadDebugMonitor #(P=2) extends AbstractDebugMonitor #(P, ReadIndexTransaction #(P));

    `uvm_component_param_utils(ReadDebugMonitor#(P))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ReadIndexTransaction#(P) tr;
        forever begin
            @(posedge vif.clk_r);
            tr = ReadIndexTransaction#(P)::type_id::create("tr", this);
            tr.ptr = vif.brptr;
            analysis_port.write(tr);
        end
    endtask

endclass