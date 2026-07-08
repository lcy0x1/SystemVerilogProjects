`ifndef UVM_MULT_DRIVER
`define UVM_MULT_DRIVER

class MultResetDriver #(W=7) extends uvm_driver #(MultResetTransaction);

    `uvm_component_param_utils(MultResetDriver#(W))

    virtual mult_bus #(W) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual mult_bus #(W))::get(this, "", "mult_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface mult_bus")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        MultResetTransaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            @(posedge vif.clk);
            vif.reset <= tr.reset;
            vif.enable <= tr.enable;
            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask

endclass

class MultDriver #(W=7) extends uvm_driver #(MultInputTransaction#(W));

    `uvm_component_param_utils(MultDriver#(W))

    virtual mult_bus #(W) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual mult_bus #(W))::get(this, "", "mult_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface mult_bus")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        MultInputTransaction #(W) tr;
        int i, j;
        forever begin
            seq_item_port.get_next_item(tr);
            @(posedge vif.clk);
            vif.clear_in <= 0;
            vif.conf <= tr.conf;
            vif.en <= 1;
            @(posedge vif.clk);
            vif.en <= 0;
            for(int t=0; t<=W*2+1; t++) begin
                for(i=0; i<=W; i++) begin
                    j = t-i;
                    if(t>=i && j<=W) begin
                        vif.x_in[i] <= tr.x[i*(W+1)+j];
                        vif.w_in[i] <= tr.w[i*(W+1)+j];
                    end else begin
                        vif.x_in[i] <= 0;
                        vif.w_in[i] <= 0;
                    end
                    vif.clear_in[i] <= tr.clear && j == W;
                end
                @(posedge vif.clk);
            end
            for(int t=0; t<tr.delay; t++) begin
                @(posedge vif.clk);
            end
            seq_item_port.item_done();
        end
    endtask

endclass

`endif