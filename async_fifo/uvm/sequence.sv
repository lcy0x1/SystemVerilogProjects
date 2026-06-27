class Counter;

    int count = 0;

endclass

class WriteSequence #(W=7) extends uvm_sequence #(WriteTransaction #(W));
    
    `uvm_object_param_utils(WriteSequence)

    typedef WriteTransaction #(W) WTX;
    
    Counter counter;
    int count;

    function new(string name = "write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        while (counter.count > count) begin
            req = WTX::type_id::create("write_tx");
            start_item(req);
            assert(req.randomize());
            if(req.wen) count ++;
            finish_item(req);
        end
        req = WTX::type_id::create("write_tx");
        start_item(req);
        finish_item(req);
    endtask

endclass

class ReadSequence #(W=7) extends uvm_sequence #(ReadTransaction #(W));
    
    `uvm_object_param_utils(ReadSequence)

    typedef ReadTransaction #(W) RTX;

    Counter counter;
    int count;

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        while (counter.count > count) begin
            req = RTX::type_id::create("read_tx");
            start_item(req);
            assert(req.randomize());
            if(req.ren) count ++;
            finish_item(req);
        end
        req = RTX::type_id::create("read_tx");
        start_item(req);
        finish_item(req);
    endtask

endclass

class ResetSequence extends uvm_sequence #(ResetTransaction);
    
    `uvm_object_utils(ResetSequence)

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    task driveReset(bit rst_n);
        req = ResetTransaction::type_id::create("rst_tx");
        req.rst_n = rst_n;
        start_item(req);
        finish_item(req);
    endtask

    virtual task body();
        driveReset(1);
        driveReset(0);
        driveReset(1);
    endtask

endclass

virtual class RootSequence extends uvm_sequence;

    `uvm_object_abstract_utils(RootSequence)

    function new(string name = "root_sequence");
        super.new(name);
    endfunction

endclass

class VirtualSequence #(W=7) extends RootSequence;

    `uvm_object_param_utils(VirtualSequence)
    `uvm_declare_p_sequencer(VirtualSequencer)

    function new(string name = "root_sequence");
        super.new(name);
    endfunction
        
    virtual task body();
        Counter counter = new();
        ResetSequence rstseq = ResetSequence::type_id::create("reset_seq");
        WriteSequence #(W) wseq = WriteSequence#(W)::type_id::create("write_seq");
        ReadSequence #(W) rseq = ReadSequence#(W)::type_id::create("read_seq");
        wseq.counter = counter;
        rseq.counter = counter;
        counter.count = 1000;

        //TODO do something to configure sequences

        rstseq.start(p_sequencer.rstseq);
        fork
            wseq.start(p_sequencer.wseq);
            rseq.start(p_sequencer.rseq);
        join
    endtask
    
endclass