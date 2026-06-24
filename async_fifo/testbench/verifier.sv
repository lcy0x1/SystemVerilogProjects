virtual class Receiver #(W=7);

    virtual task accept(bit[W:0] data);
    endtask;

endclass

virtual class AbstractReader #(W=7);

    virtual task read(Receiver #(W) dst);
    endtask

    virtual task waitFor(int t);
    endtask

endclass

class Verifier #(W=7) extends Receiver #(W);

    SequenceSource #(W) source;
    bit[W:0] buffer[];

    std::mailbox #(bit[W:0]) pending = new(1);

    function new(SequenceSource #(W) source);
        this.source = source;
        buffer = new[source.total];
    endfunction

    virtual task accept(bit[W:0] data);
        pending.put(data);
    endtask;

    task readAll(AbstractReader #(W) reader);
        int index = 0;
        int dur;
        bit[W:0] val = 0;
        foreach(source.read_durations[i]) begin
            dur = source.read_durations[i];
            if((i & 1) == 0) begin
                fork
                    begin
                        for(int step = 0; step < dur; step++) begin
                            pending.get(val);
                            $display("Read %d = %h", index, val);
                            buffer[index] = val;
                            if(source.data.data[index] != buffer[index]) begin 
                                $display("Mismatch data at %d: Write %h but read %h", index, source.data.data[index], buffer[index]);
                                #20 $finish(2);
                            end
                            index++;
                        end
                    end
                join_none
                for(int step = 0; step < dur; step++) begin
                    reader.read(this);
                end    
            end else if(dur > 0) begin 
                reader.waitFor(source.read_durations[i]);
            end
        end
    endtask

endclass