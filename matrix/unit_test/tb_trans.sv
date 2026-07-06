`include "dut/mat/trans.v"
`include "dut/mat/transpose.v"

module tb_trans();
  
	parameter CLK = 4;
	
	reg enable;
	reg clk;
	reg reset;
	reg do_transpose;
	reg en;
	reg [31:0] x_in [7:0];
	reg [7:0] in_mult_clear;
    wire [31:0] z_out [7:0];
    wire [7:0] out_mult_clear;

	t8x8 main(clk, enable, reset, do_transpose, x_in, en, z_out, in_mult_clear, out_mult_clear);
	


	initial begin
		#1;
		forever begin
			clk = ~clk;
			#2;
		end
	end

	int data[8][8];
	int i,j;
	
	initial begin
		$dumpfile ("dump.vcd");
		$dumpvars;
		for(i=0;i<8;i++) begin
			for(j=0;j<8;j++) begin
				data[i][j]=i*8+j+1;
			end
			x_in[i] = 0;
		end
		clk = 0;
		reset = 0;
		enable = 0; 
		do_transpose = 0;
		en = 0;
		in_mult_clear = 0;
		#(CLK);
		reset = 1;
		#(CLK);
		reset = 0;
		enable = 1;
		#(CLK);
		do_transpose = 1;
		#(CLK);
		en = 1;
		#(CLK);
		for(int t=0;t<16;t++) begin
			for(i=0;i<8;i++) begin
				j = t-i;
				if(t>=i && j<8) begin
					x_in[i]=data[i][j];
				end else begin
					x_in[i] = 0;
				end
				in_mult_clear[i] = j == 7;
			end
			#(CLK);
		end
		en = 0;
		#(CLK*20)
		do_transpose = 0;
		#(CLK);
		en = 1;
		#(CLK);
		for(int t=0;t<16;t++) begin
			for(i=0;i<8;i++) begin
				j = t-i;
				if(t>=i && j<8) begin
					x_in[i]=data[i][j];
				end else begin
					x_in[i] = 0;
				end
				in_mult_clear[i] = j == 7;
			end
			#(CLK);
		end
		en = 0;
		#(CLK*20)
		
		$finish;
	end
  
endmodule
