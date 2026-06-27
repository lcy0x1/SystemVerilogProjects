virtual class AbstractSequencer #(T) extends uvm_sequencer #(T);

    `uvm_component_abstract_param_utils(AbstractSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class WriteSequencer #(W=7) extends AbstractSequencer #(WriteTransaction #(W));

    `uvm_component_param_utils(WriteSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class ReadSequencer #(W=7) extends AbstractSequencer #(ReadTransaction #(W));

    `uvm_component_param_utils(ReadSequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass