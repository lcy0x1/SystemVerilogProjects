import uvm_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo/testbench/bus.sv"
`include "async_fifo/uvm/transaction.sv"
`include "async_fifo/uvm/driver.sv"
`include "async_fifo/uvm/monitor.sv"
`include "async_fifo/uvm/sequencer.sv"
`include "async_fifo/uvm/sequence.sv"
`include "async_fifo/uvm/main_env.sv"
`include "async_fifo/uvm/main_test.sv"

module tb_top;

  initial begin
    run_test("main_test");
  end

endmodule