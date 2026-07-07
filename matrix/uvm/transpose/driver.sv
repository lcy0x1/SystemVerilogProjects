`ifndef UVM_TRANSPOSE_DRIVER
`define UVM_TRANSPOSE_DRIVER

class TransposeResetDriver #(W=7) extends uvm_driver #(TransposeResetTransaction);

    `uvm_component_param_utils(TransposeResetDriver#(W))

    virtual transpose_bus #(W) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual transpose_bus #(W))::get(this, "", "transpose_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface transpose_bus")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        TransposeResetTransaction tr;
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

class TransposeDriver #(W=7) extends uvm_driver #(TransposeInputTransaction#(W));

    `uvm_component_param_utils(TransposeDriver#(W))

    virtual transpose_bus #(W) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual transpose_bus #(W))::get(this, "", "transpose_bus", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface transpose_bus")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        TransposeInputTransaction #(W) tr;
        int i, j;
        forever begin
            seq_item_port.get_next_item(tr);
            @(posedge vif.clk);
            vif.in_mult_clear <= 0;
            vif.do_transpose <= tr.transpose;
            vif.en <= 1;
            @(posedge vif.clk);
            vif.en <= 0;
            vif.do_transpose <= 0;
            for(int t=0; t<=W*2+1; t++) begin
                for(i=0; i<=W; i++) begin
                    j = t-i;
                    if(t>=i && j<=W) begin
                        vif.x_in[i] <= tr.data[i*(W+1)+j];
                    end else begin
                        vif.x_in[i] <= 0;
                    end
                    vif.in_mult_clear[i] <= tr.clearMult && j == W;
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