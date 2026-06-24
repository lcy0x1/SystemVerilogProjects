module write_pointer #(P=2) (
    input wire rst_n,
    input wire clk,
    input wire wen,
    input wire[P:0] grptr,
    output wire[P:0] gwptr,
    output reg[P:0] bwptr,
    output reg full
);

wire[P:0] brptr;

bin2grey #(P) wcast(bwptr, gwptr);
grey2bin #(P) rcast(grptr, brptr);

always @(posedge clk) begin
    if(!rst_n) begin
        bwptr <= 0;
        full <= 0;
    end else begin
        if(wen & !full) begin
            bwptr <= bwptr + 1;
            full <= bwptr + 2 == brptr;
        end else begin
            full <= bwptr + 1 == brptr;
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
    output reg empty
);

wire[P:0] bwptr;

bin2grey #(P) rcast(brptr, grptr);
grey2bin #(P) wcast(gwptr, bwptr);

always @(posedge clk) begin
    if(!rst_n) begin
        brptr <= 0;
        empty <= 1;
    end else begin
        if(ren & !empty) begin
            brptr <= brptr + 1;
            empty <= brptr + 1 == bwptr;
        end else begin
            empty <= brptr == bwptr;
        end
    end
end

endmodule