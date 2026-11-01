import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"

`include "scoreboard.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "agent.sv"

`include "test.sv"

module tb_top;

  adder_if   add_if0 ();
  adder_block dut0   (add_if0);

  initial begin
    uvm_config_db #(virtual adder_if)::set(null, "uvm_test_top.*", "vif", add_if0);
    run_test("add_test");
  end

endmodule
