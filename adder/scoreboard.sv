class add_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(add_scoreboard)
    function new(string, uvm_component parent);
        super.new(name,parent);
    endfunction
    uvm_analysis_imp #(adder_transaction, add_scoreboard) ap_imp;
    function void build_phase(uvm_phase,phase);
        super.build_phase(phase);
        ap_imp=new("ap_imp",this);
    endfunction
    bit [10:0] expected_y [2];
    bit writeen [2]
    
    virtual function void write(adder_transaciton tr);
        if (adder_transaction)

    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_agent.m_monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
endclass