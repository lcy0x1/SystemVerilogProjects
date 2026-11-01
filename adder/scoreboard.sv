class add_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(add_scoreboard)
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    uvm_analysis_imp #(add_transaction, add_scoreboard) ap_imp;
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp=new("ap_imp",this);
    endfunction

    int pass, fail;
    
    virtual function void write(add_transaction tr);
        if(tr.y==tr.a+tr.b) begin
            pass +=1;
            `uvm_info(get_name(), $sformatf("pass: %0d + %0d = %0d", tr.a, tr.b, tr.y), UVM_LOW)
        end else begin
            fail +=1;
            `uvm_error(get_type_name(),$sformatf("fail: %0d + %0d != %0d", tr.a, tr.b, tr.y))
        end
    endfunction
    
endclass