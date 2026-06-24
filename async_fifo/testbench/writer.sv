class Writer #(W=7) extends AbstractWriter #(W);

    virtual fifo_bus #(W) bus;

    function new(virtual fifo_bus #(W) bus);
        this.bus = bus;
    endfunction

    virtual task write(bit[W:0] data);
        bus.write(data);
    endtask

    virtual task waitFor(int t);
        for(int i=0; i<t; i++) begin
            @(posedge bus.clk_w);
        end
    endtask

endclass