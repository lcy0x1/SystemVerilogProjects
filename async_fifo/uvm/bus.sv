interface fifo_bus #(W = 7) (bit clk_w, bit clk_r);
    logic rst_n;
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

interface debug_bus #(P = 2) (bit clk_w, bit clk_r);
    logic [P:0] bwptr, brptr;

    clocking cw @(posedge clk_w);
        default input #1ns output #2ns;
        input bwptr;
    endclocking

    clocking cr @(posedge clk_r);
        default input #1ns output #2ns;
        input brptr;
    endclocking

    modport dut(
        output bwptr, brptr
    );

endinterface

