module grey2bin #(W = 3) (
    input wire[W:0] in,
    output wire[W:0] out
);

generate
    assign out[W] = in[W];
    for (genvar i = W-1; i >= 0; i = i-1) begin
        assign out[i] = in[i+1] ^ in[i];
    end
endgenerate

endmodule

module bin2grey #(W = 3) (
    input wire[W:0] in,
    output wire[W:0] out
);

generate
    assign out[W] = in[W];
    for (genvar i = W-1; i >= 0; i = i-1) begin
        assign out[i] = out[i+1] ^ in[i];
    end
endgenerate

endmodule