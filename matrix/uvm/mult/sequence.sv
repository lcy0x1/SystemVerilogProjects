`ifndef UVM_MULT_SEQUENCE
`define UVM_MULT_SEQUENCE

class MultSequence #(W=7) extends uvm_sequence #(MultInputTransaction #(W));
    
    `uvm_object_param_utils(MultSequence#(W))

    function new(string name = "mult_sequence");
        super.new(name);
    endfunction

    virtual task body();
    int i;
        `uvm_info(get_name(), "Mult Sequence Start", UVM_LOW)
        for(int i=0;i<256;i++) begin
            req = MultInputTransaction#(W)::type_id::create("matrix");
            start_item(req);
            assert(req.randomize());
            req.conf = {i[2:0],1'b0};
            finish_item(req);

            `uvm_info(get_name(), $sformatf("Progress: %0d/%0d", i, 256), UVM_LOW)
        end
        
    endtask

endclass

class MultResetSequence extends uvm_sequence #(MultResetTransaction);
    
    `uvm_object_utils(MultResetSequence)

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    task driveReset(bit reset, bit enable);
        req = MultResetTransaction::type_id::create("rst_tx");
        req.reset = reset;
        req.enable = enable;
        start_item(req);
        finish_item(req);
    endtask

    virtual task body();
        driveReset(0,0);
        driveReset(1,0);
        driveReset(0,1);
    endtask

endclass

`endif