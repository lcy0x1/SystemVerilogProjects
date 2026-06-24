interface fifo_bus #(W = 7) (input bit rst_n, bit clk_w, bit clk_r);
    logic wen, full, near_full;
    logic ren, empty, near_empty;
    logic [W:0] din, dout;

    clocking cw @(posedge clk_w);
        default input #1ns output #2ns;
        input full, near_full;
        output wen, din;
    endclocking

    clocking cr @(posedge clk_r);
        default input #1ns output #2ns;
        input empty, near_empty, dout;
        output ren;
    endclocking

    modport dut(
        input rst_n, clk_w, wen, clk_r, ren, din,
        output dout, full, empty, near_full, near_empty
    );

endinterface

