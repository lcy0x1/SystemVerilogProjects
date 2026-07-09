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
    int pass[8];
    int fail[8];

    virtual function void write_wt(MultOutputTransaction #(W) tr);
        queue.push_back(tr);
    endfunction

    virtual function void write_rt(MultOutputTransaction #(W) tr);
        MultOutputTransaction #(W) intr;
        int ii;
        bit error = 0;

        intr = queue.pop_front();

        for(int i=0; i<=W; i++) begin
            for(int j=0; j<=W; j++) begin
                ii = i*(W+1)+j;
                if(intr.data[ii] != tr.data[ii]) begin
                    `uvm_error(get_name(), $sformatf("Matrix mismatch at [%0d,%0d]: expected %h, get %h. conf = %b", i, j, intr.data[ii], tr.data[ii], intr.conf));
                    error = 1;
                end
            end
            if(tr.clear[i] != intr.clear[i]) begin
                `uvm_error(get_name(), $sformatf("ClearMult mismatch at %0d",i));
            end
        end
        if(error) begin 
            fail[intr.conf[3:1]]++;
        end else begin
            pass[intr.conf[3:1]]++;
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        int i;
        super.report_phase(phase);
        for(i=0; i<8; i++) begin
            `uvm_info(get_name(), $sformatf("conf = %.3b has %0d passed, %0d failed", i, pass[i], fail[i]), UVM_LOW)
        end
    endfunction

endclass

`endif