class add_sequence extends uvm_seqeunce #(add_transation);
    `uvm_object_utils(adder_sequence)                                  
    
    function new(string name="add_sequence");
        super.new(name);
    endfunction

    virtual task body();

    repeat (5) begin
        req=add_transaction::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    end
    endtask


endclass
