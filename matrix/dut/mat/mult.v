	/*
	Author: Arthur Wang
	Creation Date: Nov 13 
	Last Modified: Nov 29

	module mac: multiply and accumulate module
	module m8x8: 8 by 8 matrix multiplication module

	->  clk: clock
	->  enable: global enable, nothing shall be done if it is low
	->  reset: reset everything
	->  config: configurations

	->  win_raw: vertical input
	->  xin_raw: horizontal input
	->  clear_in_raw: clear signal that clears accumulator
	<-  z_out: output of shift register
	<-  clear_out: place to shift out clear signal, typically used for <shift>
	<-  b_out: binary relu derivative output

	How it works:
				     	w_in
	    				 |
	 --------------+-----|----------- shift
				   |     v
				   +-> [   ]
	 x_in, clear_in -> [mac] -> x_out, clear_out
			  y_out <- [   ] <- y_in
						 |
						 v
					   w_out

	config[1]: relu, pass data through relu
	config[2]: transpose w
	config[3]: transpose x

	*/

	module mult #(P=2, W=(1<<(P+1)-1))(
		input clk,
		input reset,
		input enable,
		input en,
		input [3:0] conf,
		input [31:0] win_raw [W:0],
		input [31:0] xin_raw [W:0],
		input [W:0] clear_in_raw,
		output [31:0] z_out [W:0],
		output [W:0] clear_out,
		output [W:0] b_out
	);

    wire relu = conf[1];
    wire wt = conf[2];
    wire xt = conf[3];

    wire [W:0] temp_0;


    wire [31:0] w_in [W:0];
    wire [31:0] x_in [W:0];
    wire [W:0] clear_in, valid_w, valid_x;

    t8x8 transw(clk, enable, reset, wt,  win_raw, en, w_in, clear_in_raw, clear_in, valid_w);
    t8x8 transx(clk, enable, reset, xt,  xin_raw, en, x_in, clear_in_raw, temp_0, valid_x);
    
    wire [31:0] w_mid [W-1:0][W:0];
    wire [31:0] x_mid [W:0][W-1:0];
    wire [31:0] y_mid [W:0][W-1:0];
    wire clear_mid [W:0][W-1:0];


    wire [31:0] y_out[W:0];
    wire [31:0] a_out[W:0];

    wire [31:0] w_out [W:0];
    wire [31:0] x_out [W:0];

    genvar i, j;
    generate
		for(i=0; i<=W; i=i+1) begin
			relu ri(y_out[i], a_out[i], b_out[i]);
			assign z_out[i] = relu ? a_out[i] : y_out[i];
			for(j=0; j<=W; j=j+1) begin
				wire [31:0] iwi, ixi, iyi;
				wire ici, ish;
				wire [31:0] iwo, ixo, iyo;
				wire ico;

				assign ish = clear_out[j];

				if(i == 0) begin: first_x
					assign ixi = x_in[j];
					assign ici = clear_in[j];
					assign y_out[j] = iyo;
				end else begin: later_x
					assign ixi = x_mid[j][i-1];
					assign ici = clear_mid[j][i-1];
					assign y_mid[j][i-1] = iyo;
				end

				if(i == W) begin: last_x
					assign iyi = 32'b0;
					assign x_out[j] = ixo;
					assign clear_out[j] = ico;
				end else begin: former_x
					assign iyi = y_mid[j][i];
					assign x_mid[j][i] = ixo;
					assign clear_mid[j][i] = ico;
				end

				if(j == 0) begin: first_j
					assign iwi = w_in[i];
				end else begin: later_j
					assign iwi = w_mid[j-1][i];
				end

				if(j == W) begin: last_j
					assign w_out[i] = iwo;
				end else begin: former_j
					assign w_mid[j][i] = iwo;
				end

				mac mij(iwi, ixi, iyi, ici, enable, ish, clk, reset, iwo, ixo, iyo, ico);

			end
		end
    endgenerate

endmodule