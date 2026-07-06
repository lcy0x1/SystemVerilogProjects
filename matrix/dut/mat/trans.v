/*

->  clk: clock
->  enable: global enable, nothing shall be done if it is low
->  reset: reset everything

-> x_in: {x_clear_mult, x_data}
-> y_in
-> v_in
-> clear_in
-> shift
<- x_out: {x_clear_mult, x_data}
<- y_out
<- v_out
<- clear_out
-> x_shift
-> x_delay_in
<- x_delay_out

How it works:
                   top  shift
                    ^     ^
--------------+-----|-----|----- x_shift
              |     v     |
              +-> [   ] <-+
         left <-> [mac] <-|-> right
                  [   ]   |
                    ^     |
                    |     |
                    v     |
                  bottom

left: x_in, clear_in, x_delay_out
right: x_out, clear_out, x_delay_in
top: y_out, v_in
bottom: y_in, v_out

shift logic:
    x_out <= x_in;
    v_out <= v_in;
    y_out <= y_in;
    x_delay_out <= x_delay_in;
    clear_out <= clear_in;

y_shift:    y_out <= standby[31:0];
x_shift:    x_delay_out <= standby;
v_in:       xr <= x_in;
clear_in:   standby <= xr;

*/
module trans(
    input clk,
    input enable,
    input reset,
    input [32:0] x_in,
    input [31:0] y_in,
    input v_in,
    input clear_in,
    input y_shift,
    output reg [32:0] x_out,
    output reg [31:0] y_out,
    output reg v_out,
    output reg clear_out,
    input x_shift,
    input [32:0] x_delay_in,
    output reg [32:0] x_delay_out
);
    reg [32:0] xr;
    reg [32:0] standby;

    always @(posedge clk) begin
        if(reset) begin
            x_out <= 0;
            y_out <= 0;
            v_out <= 0;
            xr <= 0;
            clear_out <= 0;
            standby <= 0;
            x_delay_out <= 0;
        end else if(enable) begin
            x_out <= x_in;
            y_out <= y_shift ? standby[31:0] : y_in;
            x_delay_out <= x_shift ? standby : x_delay_in;
            v_out <= v_in;
            xr <= v_in ? x_in : xr;
            clear_out <= clear_in;
            standby <= clear_in ? xr : standby;
        end
    end
endmodule