/*

module mac: multiply and accumulate module

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

*/

module mac(
  input [31:0] w_in,
  input [31:0] x_in,
  input [31:0] y_in,
  input clear_in,
  input enable,
  input shift,
  input clk,
  input reset,
  output reg [31:0] w_out,
  output reg [31:0] x_out,
  output reg [31:0] y_out,
  output reg clear_out
);
  
  reg [31:0] acc;
  reg [31:0] standby;
  
  wire [31:0] wx;
  wire [31:0] sum;
  wire [31:0] preg = clear_in ? 0 : acc;
  multiplier m0(w_in, x_in, wx);
  adder m1(wx, preg, sum);
  
  always @(posedge clk) begin
    if(enable || reset) begin
      w_out <= reset ? 0 : w_in;
      x_out <= reset ? 0 : x_in;
      clear_out <= reset ? 0 : clear_in;
      acc <= reset ? 0 : sum;
      standby <= reset ? 0 : clear_in ? acc : standby;
      y_out <= reset ? 0 : shift ? standby : y_in;
    end
  end
  
endmodule