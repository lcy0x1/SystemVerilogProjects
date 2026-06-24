class Reader #(W=7) extends AbstractReader #(W);

    virtual fifo_bus #(W) bus;

    bit active = 0;

    function new(virtual fifo_bus #(W) bus);
        this.bus = bus;
    endfunction

    virtual task read(output bit[W:0] data);
        bit isEmpty;
        while(1) begin
            @(posedge bus.clk_r);
            isEmpty = bus.ren & bus.near_empty | bus.empty;
            if(!isEmpty) begin
                data <= bus.dout;
                bus.ren <= 1;
                break;
            end else begin
                bus.ren <= 0;
            end
        end
    endtask

    virtual task waitFor(int t);
        for(int i=0; i<t; i++) begin
            @(posedge bus.clk_r);
            bus.ren <= 0;
        end
    endtask

endclass