import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dut/mat/trans.v"
`include "dut/mat/transpose.v"
`include "dut/mat/transpose_ref.v"
`include "intf/transpose_bus.sv"
`include "uvm/transpose/transaction.sv"
`include "uvm/transpose/driver.sv"
`include "uvm/transpose/monitor.sv"
`include "uvm/transpose/sequence.sv"
`include "uvm/transpose/header.sv"
`include "uvm/transpose/agent.sv"
`include "uvm/transpose/scoreboard.sv"
`include "uvm/transpose/env.sv"

`define POWER 2
`define WIDTH 7
`include "uvm/transpose/transpose_test.sv"

module tb_top;

	parameter P = `POWER;
	parameter W = `WIDTH;

	localparam T = 10;

	bit clk;

	always #(T/2) clk = ~clk;

	transpose_bus #(W) intf(clk);
	//transpose_reference #(W) dut(intf.dut);
	transpose_wrapper #(P, W) dut(intf.dut);

	initial begin
		$dumpfile("tb_top.vcd");
		$dumpvars;
	end

	initial begin
		uvm_config_db #(virtual transpose_bus #(W))::set(null, "uvm_test_top.*", "transpose_bus", intf);
		run_test("transpose_test");
	end

endmodule