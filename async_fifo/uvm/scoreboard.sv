class Scoreboard #(W=7) extends uvm_scoreboard;

    `uvm_component_param_utils(Scoreboard#(W))

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
    endfunction

    bit[W:0] data[$];
    int written = 0, index = 0;
    int success = 0, fail = 0;

    virtual function void write_wt(WriteTransaction #(W) tr);
        if(!tr.wen) return;
        written ++;
        data.push_back(tr.data);
    endfunction

    virtual function void write_rt(ReadTransaction #(W) tr);
        bit[W:0] e;
        if(!tr.ren) return;
        e = data.pop_front();
        if(tr.data != e) begin
            fail ++;
            `uvm_error(get_name(), $sformatf("Data Mismatch at index %d: Written %h, Read %h", index, e, tr.data))
        end else begin
            success ++;
        end
        index ++;
    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_name(), $sformatf("Written %d, Read %d, Success %d, Fail %d", written, index, success, fail), UVM_LOW)
    endfunction

endclass