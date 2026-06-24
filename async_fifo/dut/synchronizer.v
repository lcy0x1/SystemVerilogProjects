module synchronizer #(W = 7)(
    input wire rst_n,
    input wire clk,
    input wire[W:0] in,
    output reg[W:0] out
);

reg[W:0] mid;

always @(posedge clk) begin
    if(!rst_n) begin
        out <= 0;
        mid <= 0;
    end else begin 
        out <= mid;
        mid <= in;
    end
end

endmodule
