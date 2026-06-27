`uvm_analysis_imp_decl(_wt)
`uvm_analysis_imp_decl(_rt)

class Scoreboard #(W=7) extends uvm_scoreboard;

    `uvm_component_param_utils(Scoreboard)

    uvm_analysis_imp_wt #(WriteTransaction #(W), Scoreboard #(W)) wt_imp;
    uvm_analysis_imp_rt #(ReadTransaction #(W), Scoreboard #(W)) rt_imp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wt_imp = new("wt_imp", this);
        rt_imp = new("rt_imp", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //m_agent.m_monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
    endfunction

    virtual function void write_wt(WriteTransaction #(W) tr);

    endfunction

    virtual function void write_rt(ReadTransaction #(W) tr);
    
    endfunction

endclass