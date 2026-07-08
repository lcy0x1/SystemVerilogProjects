import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dut/calc/calc.v"
`include "dut/mat/transpose.v"
`include "dut/mat/mac.v"
`include "dut/mat/mult.v"
`include "intf/mult_bus.sv"
`include "uvm/mult/transaction.sv"
`include "uvm/mult/driver.sv"
`include "uvm/mult/monitor.sv"
`include "uvm/mult/sequence.sv"
`include "uvm/mult/header.sv"
`include "uvm/mult/agent.sv"
`include "uvm/mult/scoreboard.sv"
`include "uvm/mult/env.sv"

`define POWER 2
`define WIDTH 7
`include "uvm/mult/mult_test.sv"

module tb_top;

	parameter P = `POWER;
	parameter W = `WIDTH;

	localparam T = 10;

	bit clk;

	always #(T/2) clk = ~clk;

	mult_bus #(W) intf(clk);
	//mult_reference #(W) dut(intf.dut);
	mult_wrapper #(P, W) dut(intf.dut);

	initial begin
		$dumpfile("tb_top.vcd");
		$dumpvars;
	end

	initial begin
		uvm_config_db #(virtual mult_bus #(W))::set(null, "uvm_test_top.*", "mult_bus", intf);
		run_test("mult_test");
	end

endmodule