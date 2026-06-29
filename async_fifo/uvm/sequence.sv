class SeqConfig;

    int count = 0;

endclass

class WriteSequence #(W=7) extends uvm_sequence #(WriteTransaction #(W));
    
    `uvm_object_param_utils(WriteSequence#(W))
    
    SeqConfig conf;
    int count;

    function new(string name = "write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_name(), "Write Sequence Start", UVM_LOW)
        while (conf.count > count) begin
            req = WriteTransaction#(W)::type_id::create("write_tx");
            start_item(req);
            assert(req.randomize());
            if(req.wen) count ++;
            finish_item(req);
        end
        req = WriteTransaction#(W)::type_id::create("write_tx");
        start_item(req);
        finish_item(req);
    endtask

endclass

class ReadSequence #(W=7) extends uvm_sequence #(ReadTransaction #(W));
    
    `uvm_object_param_utils(ReadSequence#(W))

    SeqConfig conf;
    int count;

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_name(), "Read Sequence Start", UVM_LOW)
        while (conf.count > count) begin
            req = ReadTransaction#(W)::type_id::create("read_tx");
            start_item(req);
            assert(req.randomize());
            if(req.ren) count ++;
            finish_item(req);
        end
        req = ReadTransaction#(W)::type_id::create("read_tx");
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

    `uvm_object_param_utils(VirtualSequence#(W))
    `uvm_declare_p_sequencer(VirtualSequencer#(W))

    SeqConfig conf = new();

    function new(string name = "root_sequence");
        super.new(name);
    endfunction
        
    virtual task body();
        ResetSequence rstseq = ResetSequence::type_id::create("reset_seq");
        WriteSequence #(W) wseq = WriteSequence#(W)::type_id::create("write_seq");
        ReadSequence #(W) rseq = ReadSequence#(W)::type_id::create("read_seq");
        wseq.conf = conf;
        rseq.conf = conf;

        `uvm_info(get_name(), "Squence Start", UVM_LOW)
        rstseq.start(p_sequencer.rstseq);
        `uvm_info(get_name(), "Reset Complete", UVM_LOW)
        fork
            wseq.start(p_sequencer.wseq);
            rseq.start(p_sequencer.rseq);
        join
    endtask
    
endclass