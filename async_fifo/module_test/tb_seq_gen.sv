`include "async_fifo/testbench/seq"

class TestWriter extends AbstractWriter;

    virtual task write(bit[W:0] data);
        $display("Writing %h", data);
    endtask

    virtual task waitFor(int t);
        $display("Waiting for %d clock cycles", t);
    endtask

endclass

module testbench();

SequenceSource #(7) src;
TestWriter tester = new();

initial begin
    src = new(4, 5, 20);
    src.randomizeAll();
    $display("Total Data: %d", src.total);
    src.writeAll(tester);
    $finish();
end

endmodule