virtual class AbstractDriver #(W = 7, type T = uvm_sequence_item) extends uvm_driver #(T);

    `uvm_component_abstract_param_utils(AbstractDriver)

    virtual fifo_bus #(W) vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual fifo_bus #(W))::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface fifo_bus")
        end
    endfunction
    
endclass

class WriteDriver #(W=7) extends AbstractDriver #(W, WriteTransaction #(W));

    `uvm_component_param_utils(WriteDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        WriteTransaction #(W) tr;
        bit isFull;

        seq_item_port.get_next_item(tr);

        forever begin
            @(posedge vif.clk_w);
            if(tr.wen) begin
                isFull = vif.wen & vif.near_full | vif.full;
                if(!isFull) begin
                    vif.din <= tr.data;
                    vif.wen <= 1;
                    seq_item_port.item_done();
                    seq_item_port.get_next_item(tr);
                end else begin
                    vif.wen <= 0;
                end
            end else begin
                @(posedge vif.clk_w);
                vif.wen <= 0;
                seq_item_port.item_done();
                seq_item_port.get_next_item(tr);
            end
        end
    endtask

endclass

class ReadDriver #(W=7) extends AbstractDriver #(W, ReadTransaction #(W));

    `uvm_component_param_utils(ReadDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ReadTransaction #(W) tr;
        bit isEmpty;

        seq_item_port.get_next_item(tr);

        forever begin
            @(posedge vif.clk_r);
            if(tr.ren) begin
                isEmpty = vif.ren & vif.near_empty | vif.empty;
                if(!isEmpty) begin
                    vif.ren <= 1;
                    seq_item_port.item_done();
                    seq_item_port.get_next_item(tr);
                end else begin
                    vif.ren <= 0;
                end
            end else begin
                vif.ren <= 0;
                seq_item_port.item_done();
                seq_item_port.get_next_item(tr);
            end
        end
    endtask

endclass

class ResetDriver #(W=7) extends AbstractDriver #(W, ResetTransaction);

    `uvm_component_param_utils(ResetDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ResetTransaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            vif.rst_n = tr.rst_n;
            @(posedge vif.clk_w);
            @(posedge vif.clk_r);
            seq_item_port.item_done();
        end
    endtask

endclass