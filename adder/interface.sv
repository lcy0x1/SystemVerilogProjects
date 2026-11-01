

interface adder_if ();
    logic [9:0] a;
    logic [9:0] b;
    logic [10:0] y;
 endinterface

 module adder_block(adder_if vif);
    always @(vif.a or vif.b)
        vif.y<=a+b;
 endmodule


 class add_transaction extends uvm_sequence_item;
    rand bit [9:0] a;
    rand bit [9:0] b;                                           
    `uvm_object_utils_begin(add_transaciton)
        `uvm_field_int(a,  UVM_ALL_ON)
        `uvm_field_int(b,  UVM_ALL_ON)    
    `uvm_object_utils_end
    function new(string name= "adder_transaciton");
        super.new(name);
    endfunction
endclass


