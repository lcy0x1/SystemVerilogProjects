uvm_sequencer #(add_transaction) m_sequencer;

class add_sequencer extends uvm_sequencer #(add_transaction);
    `uvm_component_utils(add_sequencer)
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass

