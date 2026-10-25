class adder_sequence extends uvm_seqeunce #(adder_transation);
    `uvm_object_utils(adder_sequence)
    function new(string name="reg_sequence");
        super.new(name);
    endfunction

virtual task body();
repeat (5) begin
    req=adder_transaction::type_id:create;
    start_item(req);
    assert(req.randomize());
    finish_item(req);
end
endtask
adder_sequence_sequence seq;
seq = adders_equence::type_id::create("seq")
seq.start(m_sequencer)

task run_phase(uvm_phase phase);
    reg_sequence seq;
    seq=reg_sequence::type_id::create("")
    phase.raisse_objection(this);
    seq.start(m_sequencer);
    phase.drop_objection(this);
    end_task

endclass
