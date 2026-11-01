class add_test extends uvm_test;
    `uvm_component_utils(add_test)

    add_agent m_agent;
    add_scoreboard m_scoreboard;
    add_env m_top_env;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_top_env = add_env::type_id::create("m_top_env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        add_sequence m_seq = reg_sequence::type_id::create("m_seq");
        phase.raise_objection(this);
        m_seq.start(m_top_env.m_agent.m_sequencer);
        phase.drop_objection(this);
    endtask

enclass

class add_env extends uvm_env;

  `uvm_component_utils(add_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
reg_agent      m_agent;
reg_scoreboard m_scoreboard;

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_agent      = reg_agent::type_id::create("m_agent", this);
  m_scoreboard = reg_scoreboard::type_id::create("m_scoreboard", this);
endfunction

virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  m_agent.m_monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
endfunction

  // Code for rest of the steps come here
endclass

class reg_write_only_sequence extends reg_sequence;

  `uvm_object_utils(reg_write_only_sequence)

  function new(string name = "reg_write_only_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (5) begin
      req = add_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { wr_en == 1; });
      finish_item(req);
    end
  endtask

endclass
