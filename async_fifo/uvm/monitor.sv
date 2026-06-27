virtual class AbstractMonitor #(W=7, type T = uvm_sequence_item) extends uvm_monitor;

    `uvm_component_abstract_param_utils(AbstractMonitor#(W,T))

    virtual fifo_bus #(W) vif;

    uvm_analysis_port #(T) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual fifo_bus #(W))::get(this, "", "vif", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface fifo_bus")
        end
        analysis_port = new("analysis_port", this);
    endfunction

endclass

class WriteMonitor #(W=7) extends AbstractMonitor #(W, WriteTransaction #(W));

    `uvm_component_param_utils(WriteMonitor#(W))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        WriteTransaction#(W) tr;

        forever begin
            @(posedge vif.clk_w);
            tr = WriteTransaction#(W)::type_id::create("tr", this);
            if (vif.wen) begin
                tr.wen = 1;
                tr.data = vif.din;
            end else begin
                tr.wen = 0;
            end
            analysis_port.write(tr);
        end
    endtask

endclass

class ReadMonitor #(W=7) extends AbstractMonitor #(W, ReadTransaction #(W));

    `uvm_component_param_utils(ReadMonitor#(W))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ReadTransaction#(W) tr[2];
        forever begin
            @(posedge vif.clk_r);
            tr[1] = tr[0];
            tr[0] = ReadTransaction#(W)::type_id::create("tr", this);
            if (vif.ren) begin
                tr[0].ren = 1;
            end else begin
                tr[0].ren = 0;
            end
            if(tr[1] != null) begin
                if(tr[1].ren) begin
                    tr[1].data = vif.dout;
                    `uvm_info(get_name(), $sformatf("Received %h", tr[1].data), UVM_LOW)
                end
                analysis_port.write(tr[1]);
            end
        end
    endtask

endclass