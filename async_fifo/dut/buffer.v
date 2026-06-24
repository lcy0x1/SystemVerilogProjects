module fifo_buffer #(P=2, L=7, W=7) (
    input wire rst_n,
    input wire clk_w,
    input wire wen,
    input wire clk_r,
    input wire ren,
    input wire[P:0] bwptr,
    input wire[P:0] brptr,
    input wire full,
    input wire [W:0] din,
    output wire [W:0] dout
);

reg[W:0] buffer[0:L];

assign dout = buffer[brptr];

integer i;
always @(posedge clk_w) begin
    if(!rst_n) begin
        for(i = 0; i <= L; i = i+1) begin
            buffer[i] = 0;
        end
    end if(wen & !full) begin
        buffer[bwptr] <= din;
    end
end

endmodule