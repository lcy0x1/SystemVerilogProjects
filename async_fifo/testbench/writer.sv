class Writer #(W=7) extends AbstractWriter #(W);

    virtual fifo_bus #(W) bus;

    function new(virtual fifo_bus #(W) bus);
        this.bus = bus;
    endfunction

    virtual task write(bit[W:0] data);
        bit isFull;
        while(1) begin
            @(posedge bus.clk_w);
            isFull = bus.wen & bus.near_full | bus.full;
            if(!isFull) begin
                bus.din <= data;
                bus.wen <= 1;
                break;
            end else begin
                bus.wen <= 0;
            end
        end
    endtask

    virtual task waitFor(int t);
        for(int i=0; i<t; i++) begin
            @(posedge bus.clk_w);
            bus.wen <= 0;
        end
    endtask

endclass