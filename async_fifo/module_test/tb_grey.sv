`include "async_fifo/grey.v"
`default_nettype none

module tb_grey;
reg clk;
reg rst_n;
reg[7:0] in;
wire[7:0] out;
wire[7:0] check;

grey2bin #(7) dut0 (in, out);
bin2grey #(7) dut1 (out, check);

localparam T = 10;
always #(T/2) clk=~clk;

initial begin
    $dumpfile("tb_grey.vcd");
    $dumpvars(0, tb_grey);
    //$monitor ($time,"in=%b out=%b",in,out);
end

logic[7:0] prev, diff;
bit[255:0] map;

initial begin
    /*
    #1 rst_n<=1'bx;clk<=1'bx;
    #(T*3) rst_n<=1;
    #(T*3) rst_n<=0;clk<=0;
    repeat(5) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(2) @(posedge clk);
    
    */
    
    prev = 8'b0;
    diff = 8'b0;
    map = 256'b0;
    for (int i = 0; i < 256; i++) begin
        /* verilator lint_off WIDTHTRUNC */
        in = i;
        #5
        if(in != check) begin $display("Error item detected at %d, in = %b, check = %b",i,in,check); end
        if(map[out]) begin $display("Repeated item detected at %d, out = %b",i,out); end
        map[out] = out;
        diff = prev ^ out;
        for(int j = 0; j < 8; j++) begin
            if(diff[0] && (diff >> 1)) begin 
                $display("Differential item detected at %d, prev = %b, out = %b, diff = %b",i,prev, out,prev ^ out); 
                break;
            end
        end
        prev = out;
        #5;
    end

    // 0 000 000
    // 1 001 001
    // 2 010 011
    // 3 011 010
    // 4 100 110

    $finish(2);
end

endmodule
`default_nettype wire