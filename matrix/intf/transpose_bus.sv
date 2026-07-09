interface transpose_bus #(W = 7) (input bit clk);
    logic enable, reset, do_transpose, en, valid;
    logic [W:0] in_mult_clear, out_mult_clear;
    logic [31:0] x_in [W:0];
    logic [31:0] z_out [W:0];

    clocking cl @(posedge clk);
        default input #1ns output #2ns;
        input z_out, out_mult_clear, valid;
        output enable, reset, do_transpose, en, in_mult_clear, x_in;
    endclocking

    modport dut(
        input clk, enable, reset, do_transpose, en, in_mult_clear, x_in,
        output z_out, out_mult_clear, valid
    );

endinterface

module transpose_wrapper #(P=2, W=((1<<(P+1))-1)) (
    transpose_bus.dut bus
);

transpose #(P, W) dut(bus.clk, bus.enable, bus.reset, bus.do_transpose, bus.x_in, bus.en, bus.z_out, bus.in_mult_clear, bus.out_mult_clear, bus.valid);

endmodule