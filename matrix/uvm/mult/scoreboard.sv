`ifndef UVM_MULT_SCOREBOARD
`define UVM_MULT_SCOREBOARD

class MultScoreboard #(W=7) extends uvm_scoreboard;

    `uvm_component_param_utils(MultScoreboard#(W))

    uvm_analysis_imp_wt #(MultOutputTransaction #(W), MultScoreboard #(W)) wt_imp;
    uvm_analysis_imp_rt #(MultOutputTransaction #(W), MultScoreboard #(W)) rt_imp;

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

    MultOutputTransaction #(W) queue[$];

    virtual function void write_wt(MultOutputTransaction #(W) tr);
        queue.push_back(tr);
    endfunction

    virtual function void write_rt(MultOutputTransaction #(W) tr);
        MultOutputTransaction #(W) intr;
        int ii;

        intr = queue.pop_front();

        for(int i=0; i<=W; i++) begin
            for(int j=0; j<=W; j++) begin
                ii = i*(W+1)+j;
                if(intr.data[ii] != tr.data[ii]) begin
                    `uvm_error(get_name(), $sformatf("Matrix mismatch at %d, %d: expected %h, get%h",i,j, intr.data[ii], tr.data[ii]));
                end
            end
            if(tr.clear[i] != intr.clear[i]) begin
                `uvm_error(get_name(), $sformatf("ClearMult mismatch at %d",i));
            end
        end
        `uvm_info(get_name(), $sformatf("Comparison complete"), UVM_LOW)
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction

endclass

`endif