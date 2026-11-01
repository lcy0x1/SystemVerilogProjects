interface adder_if ();
    logic [9:0] a;
    logic [9:0] b;
    logic [10:0] y;
    logic clk, en;

    clocking drv_cb @(posedge clk);
      default input #1step output #1ns ;
      input y;
      output a,b,en;
    endclocking

    clocking mon_cb @(posedge clk);
      default input #1step;
      input a,b,y, en;
    endclocking

    modport dut(
        input a,b,
        output y
    );

    initial begin
      clk=0;
      forever #5 clk=~clk;
    end

 endinterface

 module adder_block(adder_if.dut vif);

  assign vif.y = vif.a+vif.b;
  
 endmodule

 class add_transaction extends uvm_sequence_item;
    rand int a;
    rand int b;             
    int y;                              
    `uvm_object_utils_begin(add_transaction)
        `uvm_field_int(a,  UVM_ALL_ON)
        `uvm_field_int(b,  UVM_ALL_ON)    
    `uvm_object_utils_end
    function new(string name= "adder_transaciton");
        super.new(name);
    endfunction
endclass


