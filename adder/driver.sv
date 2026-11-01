class add_driver extends uvm_driver #(add_transaction);
 `uvm_component_utils(add_driver)
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual adder_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual adder_if)::get(this,"","vif",vif)) begin
        `uvm_fatal(get_type_name(),"didnot get handle to virtual interface reg)if")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        add_transaction tr;
        forever begin
        @(vif.drv_cb)
        seq_item_port.get_next_item(tr);
        vif.drv_cb.a <= tr.a ;
        vif.drv_cb.b <= tr.b;
        vif.drv_cb.en <= 1;
        @(vif.drv_cb)
        vif.drv_cb.en <= 0;
        seq_item_port.item_done();
     end
    endtask

endclass
