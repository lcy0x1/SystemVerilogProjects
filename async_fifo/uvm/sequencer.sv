class WriteSequencer #(W=7) extends uvm_sequencer #(WriteTransaction #(W));

    `uvm_component_param_utils(WriteSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class ReadSequencer #(W=7) extends uvm_sequencer #(ReadTransaction #(W));

    `uvm_component_param_utils(ReadSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class ResetSequencer extends uvm_sequencer #(ResetTransaction);

    `uvm_component_utils(ResetSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class VirtualSequencer #(W=7) extends uvm_sequencer;
    
    ResetSequencer rstseq;
    WriteSequencer #(W) wseq;
    ReadSequencer #(W) rseq;

    `uvm_component_param_utils(VirtualSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
