class add_driver extends uvm_driver #(add_transaciton);
 `uvm_componetnt_utils(adder_driver)
    function new(string name, uvm_componetnt parent);
        super.new(name,parent);
    endfunction
    virtual add_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual add_if)::get(this,"","vif",vif)) begin
        `uvm_fatal(get_type_name(),"didnot get handle to virtual interface reg)if")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        adder_transaction tr;
        forever begin
        seq_item_port.get_next_item(tr);
        vif.a <= tr.a 
        vif.b <= tr.b;
      //  tr.y=vif.y //??
       wait 1; 
        seq_item_port.item_done();
     end
    endtask

endclass
