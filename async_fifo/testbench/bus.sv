interface fifo_bus #(W = 7) (input bit rst_n, bit clk_w, bit clk_r);
    logic wen, full;
    logic ren, empty;
    logic [W:0] din, dout;

    clocking cw @(posedge clk_w);
        default input #1ns output #2ns;
        input full;
        output wen, din;
    endclocking

    clocking cr @(posedge clk_r);
        default input #1ns output #2ns;
        input empty, dout;
        output ren;
    endclocking

    modport dut(
        input rst_n, clk_w, wen, clk_r, ren, din,
        output dout, full, empty
    );

    task write(input bit[W:0] data);
        wait(!full);
        din <= data;
        wen <= 1;
        @(posedge clk_w);
        wen <= 0;
    endtask 

    task read(output bit[W:0] data);
        wait(!empty);
        data <= dout;
        ren <= 1;
        @(posedge clk_r);
        ren <= 0;
    endtask 

endinterface

