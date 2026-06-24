virtual class AbstractReader #(W=7);

    virtual task read(output bit[W:0] data);
    endtask

    virtual task waitFor(int t);
    endtask

endclass

class Verifier #(W=7);

    SequenceSource #(W) source;
    bit[W:0] buffer[];

    function new(SequenceSource #(W) source);
        this.source = source;
        buffer = new[source.total];
    endfunction

    task readAll(AbstractReader #(W) reader);
        int index = 0;
        bit[W:0] val = 0;
        foreach(source.read_durations[i]) begin
            if((i & 1) == 0) begin
                for(int step = 0; step < source.read_durations[i]; step++) begin
                    reader.read(val);
                    $display("Read %d = %h", index, val);
                    buffer[index] = val;
                    if(source.data.data[index] != buffer[index]) begin 
                        $display("Mismatch data at %d: Write %h but read %h", index, source.data.data[index], buffer[index]);
                    end
                    index++;
                end
            end else begin 
                reader.waitFor(source.read_durations[i]);
            end
        end
    endtask

endclass