module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  bit clk;
  always #10 clk = ~clk;

  adder_if   add_if0 (clk);
  adder_block dut0   (add_if0);

  initial begin
    uvm_config_db #(virtual add_if)::set(null, "uvm_test_top.*", "vif", reg_if0);
    run_test("reg_test");
  end

endmodule


interface adder_if ();
    logic [9:0] a;
    logic [9:0] b;
    logic [10:0] y;
 endinterface

 module adder_block(adder_if vif);
    always @(vif.a or vif.b)
        vif.y<=a+b;
 endmodule
