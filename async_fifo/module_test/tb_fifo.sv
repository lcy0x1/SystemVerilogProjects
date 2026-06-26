`include "dut/grey.v"
`include "dut/synchronizer.v"
`include "dut/handler.v"
`include "dut/buffer.v"
`include "dut/async_fifo.v"
`include "testbench/bus.sv"
`include "testbench/seq.sv"
`include "testbench/verifier.sv"
`include "testbench/writer.sv"
`include "testbench/reader.sv"
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

SequenceSource #(W) source = new(100, 5, 30);
Verifier #(W) verifier;
Writer #(W) writer = new(intf);
Reader #(W) reader = new(intf);


initial begin
    $dumpfile("tb_async_fifo.vcd");
    $dumpvars(0, tb_async_fifo);
end

initial begin
    assert(source.randomize());
    source.randomizeData();
    verifier = new(source);
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
            #((source.wtime*TW + source.rtime*TR)*3) $display("Data transfer time out");
            $finish(2);
        end
    join
    
end

endmodule
`default_nettype wire