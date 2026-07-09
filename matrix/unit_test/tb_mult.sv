`include "dut/calc/calc.v"
`include "dut/mat/mac.v"
`include "dut/mat/mult.v"
`include "dut/mat/trans.v"
`include "dut/mat/transpose.v"

module tb_mult();
  
	parameter CLK = 4;
	
	reg clk;
	reg reset;
	reg enable;
	reg en;
	reg [3:0] conf;
	reg [31:0] w_in [7:0];
	reg [31:0] x_in [7:0];
	reg [7:0] clear_in;
    wire [31:0] z_out [7:0];
    wire [7:0] clear_out;
	wire [7:0] b_out;

	mult #(2,7) main(clk, reset, enable, en, conf, w_in, x_in, clear_in, z_out, clear_out, b_out);
	
	initial begin
		#1;
		forever begin
			clk = ~clk;
			#2;
		end
	end

	int w[8][8];
	int x[8][8];
	int i,j;
	
	initial begin
		$dumpfile ("dump.vcd");
		$dumpvars;
		for(i=0;i<8;i++) begin
			for(j=0;j<8;j++) begin
				w[i][j]=(i*8+j+1)%5-2;
				x[i][j]=(i*8+j+1)%7-2;
			end
			x_in[i] = 0;
			w_in[i] = 0;
		end
		clk = 0;
		reset = 0;
		enable = 0; 
		en = 0;
		clear_in = 0;
		conf = 0;
		#(CLK);
		reset = 1;
		#(CLK);
		reset = 0;
		enable = 1;
		#(CLK);
		conf = 4'b0010;
		en = 1;
		#(CLK);
		en = 0;
		for(int t=0;t<16;t++) begin
			for(i=0;i<8;i++) begin
				j = t-i;
				if(t>=i && j<8) begin
					x_in[i]=x[i][j];
					w_in[i]=w[i][j];
				end else begin
					x_in[i] = 0;
					w_in[i] = 0;
				end
				clear_in[i] = j == 7;
			end
			#(CLK);
		end
		#(CLK*50)
		
		$finish;
	end
  
endmodule
