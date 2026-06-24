class Reader #(W=7) extends AbstractReader #(W);

    virtual fifo_bus #(W) bus;

    bit active = 0;

    function new(virtual fifo_bus #(W) bus);
        this.bus = bus;
    endfunction

    virtual task read(Receiver #(W) dst);
        bit isEmpty;
        while(1) begin
            @(posedge bus.clk_r);
            isEmpty = bus.ren & bus.near_empty | bus.empty;
            if(!isEmpty) begin
                bus.ren <= 1;
                fork
                    begin
                        @(posedge bus.clk_r);
                        dst.accept(bus.dout);
                    end
                join_none;
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