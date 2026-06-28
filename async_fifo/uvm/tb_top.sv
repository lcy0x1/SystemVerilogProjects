import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dut/grey.v"
`include "dut/synchronizer.v"
`include "dut/handler.v"
`include "dut/buffer.v"
`include "dut/async_fifo.v"
`include "uvm/bus.sv"
`include "uvm/transaction.sv"
`include "uvm/driver.sv"
`include "uvm/monitor.sv"
`include "uvm/sequencer.sv"
`include "uvm/sequence.sv"
`include "uvm/agent.sv"
`include "uvm/scoreboard.sv"
`include "uvm/env.sv"

`define WIDTH 15
`include "uvm/main_test.sv"

module wrapper #(P=2, W=7) (
	fifo_bus.dut bus
);

async_fifo #(P,W) fifo(bus.rst_n, bus.clk_w, bus.wen, bus.clk_r, bus.ren, bus.din, bus.dout, bus.full, bus.empty, bus.near_full, bus.near_empty);

endmodule

module tb_top;

	parameter P = 3;
	parameter W = `WIDTH;

	localparam TW = 10, TR = 8;

	reg clk_w, clk_r;

	always #(TW/2) clk_w = ~clk_w;
	always #(TR/2) clk_r = ~clk_r;

	fifo_bus #(W) intf(clk_w, clk_r);
	wrapper #(P,W) dut(intf.dut);

	initial begin
		$dumpfile("tb_top.vcd");
		$dumpvars;
	end

	initial begin
		uvm_config_db #(virtual fifo_bus #(W))::set(null, "uvm_test_top.*", "vif", intf);
		run_test("main_test");
	end

endmodule