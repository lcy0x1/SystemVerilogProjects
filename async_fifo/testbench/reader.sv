class Reader #(W=7) extends AbstractReader #(W);

    virtual fifo_bus #(W) bus;

    bit active = 0;

    function new(virtual fifo_bus #(W) bus);
        this.bus = bus;
    endfunction

    virtual task read(Receiver #(W) dst);

    endtask

    virtual task waitFor(int t);
        for(int i=0; i<t; i++) begin
            @(posedge bus.clk_r);
            bus.ren <= 0;
        end
    endtask

endclass