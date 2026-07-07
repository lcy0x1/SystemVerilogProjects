`ifndef UVM_MULT_MONITOR
`define UVM_MULT_MONITOR

class MultInputMonitor #(W=7) extends uvm_monitor;

    `uvm_component_param_utils(MultInputMonitor#(W))

    virtual mult_bus #(W) vif;

    uvm_analysis_port #(MultInputTransaction#(W)) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual mult_bus #(W))::get(this, "", "mult_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface mult_bus")
        end
        analysis_port = new("analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        MultInputTransaction #(W) tr;      
        int j; 
        forever begin
            @(posedge vif.clk);
            if(!vif.en) continue;
            tr = MultInputTransaction#(W)::type_id::create("tr", this);
            tr.mult = vif.do_mult;
            for(int t=0; t<=W*2; t++) begin
                @(posedge vif.clk);
                for(int i=0; i<=W; i++) begin
                    j = t-i;
                    if(t>=i && j<=W) begin
                        tr.data[i*(W+1)+j] = vif.x_in[i];
                    end else begin
                        if(vif.x_in[i]) begin
                            `uvm_error(get_name(), $sformatf("Invalid data at t=%d, i=%d, data=%h", t, i, vif.x_in[i]))
                        end
                    end
                    if(t == i+W) begin
                        if(i == 0) begin
                            tr.clearMult = vif.in_mult_clear[i];
                        end else begin
                            if(vif.in_mult_clear[i] != tr.clearMult) begin
                                `uvm_error(get_name(), $sformatf("Invalid clearMult at t=%d, i=%d", t, i))
                            end
                        end
                    end else begin
                        if(vif.in_mult_clear[i]) begin
                            `uvm_error(get_name(), $sformatf("Invalid clearMult at t=%d, i=%d", t, i))
                        end
                    end
                end
            end
            analysis_port.write(tr);
        end

    endtask

endclass

class MultOutputMonitor #(W=7) extends uvm_monitor;

    `uvm_component_param_utils(MultOutputMonitor#(W))

    virtual mult_bus #(W) vif;

    uvm_analysis_port #(MultOutputTransaction#(W)) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual mult_bus #(W))::get(this, "", "mult_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface mult_bus")
        end
        analysis_port = new("analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        MultOutputTransaction #(W) tr;
        int j;
        forever begin
            @(posedge vif.clk);
            if(!vif.valid) continue;
		    phase.raise_objection(this, "Start recording");
            tr = MultOutputTransaction#(W)::type_id::create("tr", this);
            for(int t=0; t<=W*2+1; t++) begin
                for(int i=0; i<=W; i++) begin
                    j = t-i;
                    if(t>=i && j<=W) begin
                        tr.data[i*(W+1)+j] = vif.z_out[i];
                    end else begin
                        if(vif.z_out[i]) begin
                            `uvm_error(get_name(), $sformatf("Invalid data at t=%d, i=%d, data=%h", t, i, vif.z_out[i]))
                        end
                    end

                    if(t == i+W+1) begin
                        tr.clearMult[i] = vif.out_mult_clear[i];
                    end else begin
                        if(vif.out_mult_clear[i]) begin
                            `uvm_error(get_name(), $sformatf("Invalid clearMult at t=%d, i=%d", t, i))
                        end
                    end
                end
                @(posedge vif.clk);
            end
            analysis_port.write(tr);
		    phase.drop_objection(this, "Finish recording");
        end

    endtask

endclass

`endif