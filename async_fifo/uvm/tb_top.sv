import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dut/grey.v"
`include "dut/synchronizer.v"
`include "dut/handler.v"
`include "dut/buffer.v"
`include "dut/async_fifo.v"
`include "uvm/bus.sv"
`include "uvm/dut.sv"
`include "uvm/transaction.sv"
`include "uvm/driver.sv"
`include "uvm/monitor.sv"
`include "uvm/debug_monitor.sv"
`include "uvm/sequencer.sv"
`include "uvm/sequence.sv"
`include "uvm/header.sv"
`include "uvm/subscriber.sv"
`include "uvm/agent.sv"
`include "uvm/scoreboard.sv"
`include "uvm/env.sv"

`define WIDTH 15
`define POWER 3
`include "uvm/main_test.sv"

module tb_top;

	parameter P = `POWER;
	parameter W = `WIDTH;

	localparam TW = 10, TR = 8;

	reg clk_w, clk_r;

	always #(TW/2) clk_w = ~clk_w;
	always #(TR/2) clk_r = ~clk_r;

	fifo_bus #(W) intf(clk_w, clk_r);
	debug_bus #(P) debug(clk_w, clk_r);
	wrapper #(P,W) dut(intf.dut, debug.dut);

	initial begin
		$dumpfile("tb_top.vcd");
		$dumpvars;
	end

	initial begin
		uvm_config_db #(virtual fifo_bus #(W))::set(null, "uvm_test_top.*", "vif", intf);
		uvm_config_db #(virtual debug_bus #(P))::set(null, "uvm_test_top.*", "debug", debug);
		run_test("main_test");
	end

endmodule