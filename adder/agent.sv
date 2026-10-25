class add_agent extends uvm_agent;
    `uvm_compponent_utils(add_agent)

    add_driver m_driver;
    add_monitor m_monitor;
    add_sequencer m_sequencer;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active()) begin
            m_sequencer = add_sequencer::type_id::create("seq", this);
            m_driver = add_driver::type_id::create("driver", this);
        end
        m_monitor = add_monitor::type_id::create("monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase)
        super.connect_phase(phase);
        if (get_is_active())
            m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        m_monitor.mon_analysis_port.connect(m_coverage.analysis_port);
    endfunction
//  uvm_config_db #(uvm_active_passive_enum)::set(this,"path_to_agent","is_active", UVM_PASSIVE);
//   uvm_config_db #(uvm_active_passive_enum)::set(this,"path_to_agent","is_active", UVM_ACIVE);


endclass



        