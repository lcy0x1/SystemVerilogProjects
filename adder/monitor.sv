class adder_monitor extends uvm_monitor;
    `uvm_componetnt_utils(adder_montior)
    function new(string name,uvm_componet parent);
        super.new(name,parent);
    end
    virtual adder_if vif;
    uvm_analysis_port #(reg_transaciton) mon_analysis_port;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port=new("mon_analysis",this);
        if (!uvm_config_db #(virtual adder_if)::get(this,"","vif",vif)) begin
            'uvm_error(get_type_name(),"didnot get handle to virtual interface adder_if")
        end
    virtual task run_phase(uvm_phase phase)
    adder_transation tr;
    forever begin
        tr.a=vif.a;
        tr.b=vif.b
        #1 ;
        tr.y=vif.y;
        mon_analysis_port.write(tr);
    end
    endtask
endclass