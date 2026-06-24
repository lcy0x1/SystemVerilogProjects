module write_pointer #(P=2) (
    input wire rst_n,
    input wire clk,
    input wire wen,
    input wire[P:0] grptr,
    output wire[P:0] gwptr,
    output reg[P:0] bwptr,
    output reg full,
    output reg last
);

wire[P:0] brptr;
wire[P:0] nptr, nnptr, nnnptr;

assign nptr = bwptr + 1;
assign nnptr = bwptr + 2;
assign nnnptr = bwptr + 3;

bin2grey #(P) wcast(bwptr, gwptr);
grey2bin #(P) rcast(grptr, brptr);

always @(posedge clk) begin
    if(!rst_n) begin
        bwptr <= 0;
        full <= 0;
        last <= 0;
    end else begin
        if(wen & !full) begin
            bwptr <= nptr;
            full <= nnptr == brptr;
            last <= nnnptr == brptr;
        end else begin
            full <= nptr == brptr;
            last <= nnptr == brptr;
        end
    end
end

endmodule

module read_pointer #(P=2) (
    input wire rst_n,
    input wire clk,
    input wire ren,
    input wire[P:0] gwptr,
    output wire[P:0] grptr,
    output reg[P:0] brptr,
    output reg empty,
    output reg last
);

wire[P:0] bwptr;
wire[P:0] nptr, nnptr;

assign nptr = brptr + 1;
assign nnptr = brptr + 2;

bin2grey #(P) rcast(brptr, grptr);
grey2bin #(P) wcast(gwptr, bwptr);

always @(posedge clk) begin
    if(!rst_n) begin
        brptr <= 0;
        empty <= 1;
        last <= 1;
    end else begin
        if(ren & !empty) begin
            brptr <= nptr;
            empty <= nptr == bwptr;
            last <= nnptr == bwptr;
        end else begin
            empty <= brptr == bwptr;
            last <= nptr == bwptr;
        end
    end
end

endmodule