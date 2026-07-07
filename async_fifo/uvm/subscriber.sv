class Coverage #(P=2, W=7) extends uvm_subscriber;

    `uvm_component_param_utils(Coverage#(P,W))

    localparam L = (1 << P) - 1;

    uvm_analysis_imp_wt #(WriteTransaction#(W), Coverage#(P,W)) export_wt;
    uvm_analysis_imp_rt #(ReadTransaction#(W), Coverage#(P,W)) export_rt;
    uvm_analysis_imp_wptr #(WriteIndexTransaction#(P), Coverage#(P,W)) export_wptr;
    uvm_analysis_imp_rptr #(ReadIndexTransaction#(P), Coverage#(P,W)) export_rptr;

    WriteTransaction#(W) wt;
    ReadTransaction#(W) rt;
    WriteIndexTransaction#(P) wptr;
    ReadIndexTransaction#(P) rptr;

    // covergroup cg;
    //     coverpoint wt.wen;
    //     coverpoint rt.ren;
    //     coverpoint wptr.ptr;
    //     coverpoint rptr.ptr;
    // endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        // cg = new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        export_wt = new("wt_imp", this);
        export_rt = new("rt_imp", this);
        export_wptr = new("wptr_imp", this);
        export_rptr = new("rptr_imp", this);
    endfunction

    virtual function write(int t);
    endfunction

    virtual function void write_wt(WriteTransaction#(W) t);
        wt = t;
        checkWrite();
    endfunction

    virtual function void write_rt(ReadTransaction#(W) t);
        rt = t;
        checkRead();
    endfunction

    virtual function void write_wptr(WriteIndexTransaction#(P) t);
        wptr = t;
        checkWrite();
    endfunction

    virtual function void write_rptr(ReadIndexTransaction#(P) t);
        rptr = t;
        checkRead();
    endfunction

    function void checkWrite();
        if(wt==null || wptr==null) return;
        // cg.sample();
        wt = null;
        wptr = null;
    endfunction

    function void checkRead();
        if(rt==null || rptr==null) return;
        // cg.sample();
        rt = null;
        rptr = null;
    endfunction

endclass