module transpose #(P=2, W=((1<<(P+1))-1)) (
    input clk,
    input enable,
    input reset,
    input do_transpose,
    input [31:0] x_in [W:0],
    input en,
    output reg [31:0] z_out [W:0],
    input [W:0] in_mult_clear,
    output reg [W:0] out_mult_clear,
    output reg valid
);

wire valid_next;
wire [31:0] out_pre [W:0];

reg transpose_en;
reg[P+1:0] counter;
reg [W:0] delay_mult_clear;

assign valid_next = counter > 0 && !(&counter);

always @(posedge clk) begin
    if(reset) begin
        out_mult_clear <= 0;
        valid <= 0;
        transpose_en <= 0;
        counter <= 0;
        out_mult_clear <= 0;
        delay_mult_clear <= 0;
    end else if(enable) begin
        if(en) begin
            counter <= 1;
        end else if(counter > 0) begin
            counter <= counter+1;
        end else begin
            counter <= 0;
        end
        valid <= counter > 0;
        delay_mult_clear <= in_mult_clear;
        out_mult_clear <= delay_mult_clear;
        transpose_en <= en ? do_transpose : valid_next ? transpose_en : 0;
    end
    z_out <= out_pre;
end

genvar i;
generate
    for(i=0; i<=W; i=i+1) begin
        assign out_pre[i] = reset | !enable ? 0 : transpose_en && ( !counter[P+1] && i < counter || counter[P+1] && i >= counter-W-1) ? x_in[counter-i-1] : x_in[i];
    end
endgenerate

endmodule
