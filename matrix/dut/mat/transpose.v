module transpose #(W=7) (
    input clk,
    input enable,
    input reset,
    input do_transpose,
    input [31:0] x_in [W:0],
    input en,
    output [31:0] z_out [W:0],
    input [W:0] in_mult_clear,
    output reg [W:0] out_mult_clear,
    output reg valid
);

wire [32:0] x_mid [W:0][W-1:0];
wire [31:0] y_mid [W-1:0][W:0];
wire v_mid [W-1:0][W:0];
wire clear_mid [W:0][W:0];
wire [32:0] x_delay_mid [W:0][W-1:0];
reg [W:0] v_in;
reg [W:0] clear_in;
reg [4:0] v_count;
reg en_delay;

wire [31:0] y_out [W:0];
wire [32:0] x_delay_out [W:0];
wire [W:0] clear_out;
wire [W:0] v_out;
wire [32:0] x_out [W:0];

wire [W:0] out_mult_clear_pre;

wire do_clock;
assign do_clock = en || en_delay || v_count > 0;

always @(posedge clk) begin
    if(reset)begin
        v_count <= 0;
        v_in <= 0;
        clear_in <= 0;
        en_delay <= 0;
    end
    else if(enable)begin
        en_delay <= en ? 1 : 0;
        v_in <= v_count[0] == 0 ? 8'h11 << v_count[2:1] : 0;
        if(do_clock || |v_count) begin
            v_count <= v_count + 1;
        end 
        else begin
            v_count <= 0;
        end
        valid <= v_count > 16;
        clear_in <= do_clock ? 1 << v_count : 0;
        out_mult_clear <= out_mult_clear_pre;
    end
end

genvar i,j;
generate
    for(i=0;i<=W;i=i+1) begin: row
    end

    for(i=0;i<=W;i=i+1) begin

        assign z_out[i] = do_transpose ? y_out[i] : x_delay_out[i][31:0];
        assign out_mult_clear_pre[i] = x_delay_out[i][32];

        for(j=0;j<=W;j=j+1) begin: trans_cell

            wire[32:0] ixi, ixo, xdi, xdo;
            wire[31:0] iyi, iyo;
            wire ivi, ici, ish, ivo, ico;

            assign ish = clear_out[i];
            assign xsh = clear_out[j];

            if(i == 0) begin: first_x
                assign ixi = {in_mult_clear[j], x_in[j]};
                assign ici = clear_in[j];
                assign xdo = x_delay_out[j];
            end else begin: later_x
                assign ixi = x_mid[j][i-1];
                assign ici = clear_mid[j][i-1];
                assign xdo = x_delay_mid[j][i-1];
            end

            if(i == W) begin: last_x
                assign ixo = x_out[j];
                assign ico = clear_out[j];
                assign dxi = 33'b0;
            end else begin: former_x
                assign ixo = x_mid[j][i];
                assign ico = clear_mid[j][i];
                assign dxi = x_delay_mid[j][i];
            end

            if(j == W) begin: last_j
                assign iyi = 32'b0;
                assign ivo = v_out[j];
            end else begin: former_j
                assign iyi = y_mid[j][i];
                assign ivo = v_mid[j][i];
            end

            if(j == 0) begin: first_j
                assign iyo = y_out[j];
                assign ivi = v_in[i];
            end else begin: later_j
                assign iyo = y_mid[j-1][i];
                assign ivi = v_mid[j-1][i];
            end

            trans tcell(clk, enable, reset, ixi, iyi, ivi, ici, ish, ixo, iyo, ivo, ico, xsh, xdi, xdo);

        end
    end

endgenerate

endmodule
