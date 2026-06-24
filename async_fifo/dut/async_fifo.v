module async_fifo #(P=2, W=7) (
    input wire rst_n,
    input wire clk_w,
    input wire wen,
    input wire clk_r,
    input wire ren,
    input wire [W:0] din,
    output wire [W:0] dout,
    output wire full,
    output wire empty,
    output wire near_full,
    output wire near_empty
);

parameter L = (2 << P) - 1;

wire[P:0] bwptr, brptr, gwptr, grptr, gwptrs, grptrs;

write_pointer #(P) wptr(rst_n, clk_w, wen, grptrs, gwptr, bwptr, full, near_full);
read_pointer #(P) rptr(rst_n, clk_r, ren, gwptrs, grptr, brptr, empty, near_empty);
synchronizer #(P) grsync(rst_n, clk_w, grptr, grptrs);
synchronizer #(P) gwsync(rst_n, clk_r, gwptr, gwptrs);
fifo_buffer #(P,L,W) buffer(rst_n, clk_w, wen, clk_r, ren, bwptr, brptr, full, din, dout);

endmodule