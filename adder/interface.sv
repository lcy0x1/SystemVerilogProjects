

interface adder_if ();
    logic [9:0] a;
    logic [9:0] b;
    logic [10:0] y;
 endinterface

 module adder_block(adder_if vif);
    always @(vif.a or vif.b)
        vif.y<=a+b;
 endmodule


 class adder_transaction extends uvm_sequence_item;
    rand bit [9:0] a;
    rand bit [9:0] b;
    uvm_object_utils_begin(adder_transaciton)
        `uvm_field_int(a,  UVM_ALL_ON)
        `uvm_field_int(b,  UVM_ALL_ON)    
    uvm_object_utils_end
    function new(string name= "adder_transaciton")
        super.new(name)
    endfunction
endclass

class adder_driver extends uvm_driver #(adder_transaciton);
 `uvm_componetnt_utils(adder_driver)
 function new(string name, uvm_componetnt parent);
    super.new(name,parent);
    endfunction


virtual adder_if vif;
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual adder_if)::get(this,"","vif",vif)) begin
        `uvm_fatal(get_type_name(),"didnot get handle to virtual interface reg)if")
        
    end
virtual task run_phase(uvm_phase phase);
    adder_transaction tr;
    forever begin
        seq_item_port.get_next_item(tr);
        vif.a <= tr.a 
        vif.b <= tr.b;

        tr.y=vif.y


        
       wait 1; 
        seq_item_port.item_done();
    end
endtask

endclass

