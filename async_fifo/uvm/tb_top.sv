import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo/uvm/main_env.sv"
`include "async_fifo/uvm/main_test.sv"

module tb_top;

  initial begin
    run_test("main_test");
  end

endmodule