interface mult_bus #(W = 7) (input bit clk);
    logic enable, reset, en;
    logic [3:0] conf;
    logic [W:0] clear_in, clear_out, b_out;
    logic [31:0] x_in [W:0];
    logic [31:0] w_in [W:0];
    logic [31:0] z_out [W:0];

    clocking cl @(posedge clk);
        default input #1ns output #2ns;
        input z_out, clear_out, b_out;
        output enable, reset, en, clear_in, x_in, w_in, conf;
    endclocking

    modport dut(
        input clk, enable, reset, en, clear_in, x_in, w_in, conf,
        output z_out, clear_out, b_out
    );

endinterface

module mult_wrapper #(P=2, W=((1<<(P+1))-1)) (
    mult_bus.dut bus
);

mult #(P, W) dut(bus.clk, bus.reset, bus.enable, bus.en, bus.conf, bus.x_in, bus.w_in, bus.clear_in, bus.z_out, bus.clear_out, bus.b_out);

endmodule