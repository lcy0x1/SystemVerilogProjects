`timescale 1ns / 1ps
`include "async_fifo/dut/grey.v"
`include "async_fifo/dut/synchronizer.v"
`include "async_fifo/dut/handler.v"
`include "async_fifo/dut/buffer.v"
`include "async_fifo/dut/async_fifo.v"
`include "async_fifo/testbench/bus.sv"
`include "async_fifo/testbench/seq.sv"
`include "async_fifo/testbench/verifier.sv"
`include "async_fifo/testbench/writer.sv"
`include "async_fifo/testbench/reader.sv"
`default_nettype none

module wrapper #(P=2, W=7) (
    fifo_bus.dut bus
);

async_fifo #(P,W) fifo(bus.rst_n, bus.clk_w, bus.wen, bus.clk_r, bus.ren, bus.din, bus.dout, bus.full, bus.empty, bus.near_full, bus.near_empty);

endmodule

module tb_async_fifo;

parameter P = 3;
parameter W = 7;

localparam TW = 10, TR = 8;

reg clk_w, clk_r;
reg rst_n;

always #(TW/2) clk_w = ~clk_w;
always #(TR/2) clk_r = ~clk_r;

fifo_bus #(W) intf(rst_n, clk_w, clk_r);
wrapper #(P,W) dut(intf.dut);

SequenceSource #(W) source = new(3, 30, 30);
Verifier #(W) verifier = new(source);
Writer #(W) writer = new(intf);
Reader #(W) reader = new(intf);


initial begin
    $dumpfile("tb_async_fifo.vcd");
    $dumpvars(0, tb_async_fifo);
end

initial begin
    //assert(source.randomize());
    source.write_durations[0] = 30;
    source.write_durations[1] = 30;
    source.write_durations[2] = 30;
    source.read_durations[0] = 0;
    source.read_durations[1] = 30;
    source.read_durations[2] = 60;
    source.randomizeData();
    $display("Total Data: %d", source.total);

    #1 
    rst_n = 1;
    clk_w = 1;
    clk_r = 1;
    #(TW + TR) rst_n = 0;
    #(TW + TR) rst_n = 1;
    
    fork
        begin
            fork
                source.writeAll(writer);
                verifier.readAll(reader);
            join
            $display("Data transfer complete");
            $finish(2);
        end
        begin
            #10000 $display("Data transfer failed");
            $finish(2);
        end
    join
    
    
end

endmodule
`default_nettype wire