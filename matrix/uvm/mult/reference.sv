`ifndef UVM_MULT_REFERENCE
`define UVM_MULT_REFERENCE

class MultReference #(W) extends uvm_component;

    `uvm_component_param_utils(MultReference#(W))

    uvm_analysis_imp #(MultInputTransaction #(W), MultReference #(W)) wt_imp;

    uvm_analysis_port #(MultOutputTransaction #(W)) rt_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wt_imp = new("input", this);
        rt_port = new("output", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual function void write(MultInputTransaction #(W) tr);
        MultOutputTransaction #(W) ans;

        int w[W:0][W:0];
        int x[W:0][W:0];
        int z[W:0][W:0];

        int ii, io;

        ans = new();

        ans.conf = tr.conf;

        for(int i=0; i<=W; i++) begin
            for(int j=0; j<=W; j++) begin
                ii = i*(W+1)+j;
                io = j*(W+1)+i;
                w[i][j] = tr.w[tr.conf[2] ? io : ii];
                x[i][j] = tr.x[tr.conf[3] ? ii : io];
                z[i][j] = 0;
            end
        end

        for(int i=0; i<=W; i++) begin
            for(int j=0; j<=W; j++) begin
                for(int k=0; k<=W; k++) begin
                    z[i][j] += w[i][k] * x[k][j];
                end
            end
        end

        for(int i=0; i<=W; i++) begin
            for(int j=0; j<=W; j++) begin
                ii = i*(W+1)+j;
                ans.data[ii] = !tr.conf[1] || z[i][j] > 0 ? z[i][j] : 0;
            end
            ans.clear[i] = tr.clear;
        end

        rt_port.write(ans);
    endfunction

endclass

`endif