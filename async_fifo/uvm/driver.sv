virtual class AbstractDriver #(T) extends uvm_driver #(T);

    `uvm_component_abstract_param_utils(AbstractDriver)

    virtual fifo_bus vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual fifo_bus)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface fifo_bus")
        end
    endfunction
    
endclass

class WriteDriver #(W=7) extends AbstractDriver #(WriteTransaction #(W));

    `uvm_component_param_utils(WriteDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        WriteTransaction #(W) tr;
        bit isFull;

        seq_item_port.get_next_item(tr);

        forever begin
            @(posedge bus.clk_w);
            if(tr.wen) begin
                isFull = bus.wen & bus.near_full | bus.full;
                if(!isFull) begin
                    bus.din <= data;
                    bus.wen <= 1;
                    seq_item_port.item_done();
                    seq_item_port.get_next_item(tr);
                end else begin
                    bus.wen <= 0;
                end
            end else begin
                @(posedge bus.clk_w);
                bus.wen <= 0;
                seq_item_port.item_done();
                seq_item_port.get_next_item(tr);
            end
        end
    endtask

endclass

class ReadDriver #(W=7) extends AbstractDriver #(ReadTransaction #(W));

    `uvm_component_param_utils(ReadDriver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ReadTransaction #(W) tr;
        bit isEmpty;

        seq_item_port.get_next_item(tr);

        forever begin
            @(posedge bus.clk_r);
            if(tr.ren) begin
                isEmpty = bus.ren & bus.near_empty | bus.empty;
                if(!isEmpty) begin
                    bus.ren <= 1;
                    seq_item_port.item_done();
                    seq_item_port.get_next_item(tr);
                end else begin
                    bus.ren <= 0;
                end
            end else begin
                bus.ren <= 0;
                seq_item_port.item_done();
                seq_item_port.get_next_item(tr);
            end
        end
    endtask

endclass