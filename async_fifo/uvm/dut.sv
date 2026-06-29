module wrapper #(P=2, W=7) (
	fifo_bus.dut bus,
    debug_bus.dut debug
);

parameter L = (2 << P) - 1;

wire rst_n, clk_w, wen, clk_r, ren, full, empty, near_full, near_empty;
wire [W:0] din, dout;

assign rst_n = bus.rst_n;
assign clk_w = bus.clk_w;
assign wen = bus.wen;
assign clk_r = bus.clk_r;
assign ren = bus.ren;
assign bus.full = full;
assign bus.empty = empty;
assign bus.near_full = near_full;
assign bus.near_empty = near_empty;

assign din = bus.din;
assign bus.dout = dout;

wire[P:0] bwptr, brptr, gwptr, grptr, gwptrs, grptrs;

assign debug.bwptr = bwptr;
assign debug.brptr = brptr;

write_pointer #(P) wptr(rst_n, clk_w, wen, grptrs, gwptr, bwptr, full, near_full);
read_pointer #(P) rptr(rst_n, clk_r, ren, gwptrs, grptr, brptr, empty, near_empty);
synchronizer #(P) grsync(rst_n, clk_w, grptr, grptrs);
synchronizer #(P) gwsync(rst_n, clk_r, gwptr, gwptrs);
fifo_buffer #(P, L, W) buffer(rst_n, clk_w, wen, clk_r, ren, bwptr, brptr, full, din, dout);

endmodule