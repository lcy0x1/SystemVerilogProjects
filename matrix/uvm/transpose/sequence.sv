class TransposeSequence #(W=7) extends uvm_sequence #(TransposeInputTransaction #(W));
    
    `uvm_object_param_utils(TransposeSequence#(W))

    function new(string name = "transpose_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_name(), "Transpose Sequence Start", UVM_LOW)

        req = TransposeInputTransaction#(W)::type_id::create("matrix");
        start_item(req);
        assert(req.randomize());
        finish_item(req);

        req = TransposeInputTransaction#(W)::type_id::create("matrix");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
        
    endtask

endclass

class TransposeResetSequence extends uvm_sequence #(TransposeResetTransaction);
    
    `uvm_object_utils(TransposeResetSequence)

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    task driveReset(bit reset, bit enable);
        req = TransposeResetTransaction::type_id::create("rst_tx");
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