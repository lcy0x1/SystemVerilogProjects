uvm_sequencer #(reg_transaction) m_sequencer;
class adder_sequencer extends uvm_sequencer #(adder_transaction);
    `uvm_component_utils(adder_sequencer)
    function new(string name, uvm_componet parent);
        super.new(name,parent);
    endfunction
endclass

virtual function void build_phase(uvm_phase);
    super.build_phase(phase);
    m_sequencer = uvm_sequencer#(adder_transaciton)::type_id::create("m_sequencer",this);
    m_driver =reg_driver::type_id::create("m_driver",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
endfunction