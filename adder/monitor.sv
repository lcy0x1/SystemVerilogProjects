class add_monitor extends uvm_monitor;
    `uvm_component_utils(add_monitor)
    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual adder_if vif;
    uvm_analysis_port #(add_transaction) mon_analysis_port;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port=new("mon_analysis",this);
        if (!uvm_config_db #(virtual adder_if)::get(this,"","vif",vif)) begin
            `uvm_error(get_type_name(),"didnot get handle to virtual interface adder_if")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
    add_transaction tr;
    forever begin

        @(vif.mon_cb)
        `uvm_info(get_name(), $sformatf("en=%0d, a=%0d, b=%0d", vif.mon_cb.en, vif.mon_cb.a, vif.mon_cb.b), UVM_LOW)
        if(vif.mon_cb.en) begin
            tr = add_transaction::type_id::create("tr", this);
            tr.a=vif.mon_cb.a;
            tr.b=vif.mon_cb.b;
            tr.y=vif.mon_cb.y;
            mon_analysis_port.write(tr);
        end
    end
    endtask
endclass