class SequenceData #(W=7);

    rand bit[W:0] data[];

    function new(int size = 1024);
        data = new[size];
    endfunction

endclass

virtual class AbstractWriter #(W=7);

    virtual task write(bit[W:0] data);
    endtask

    virtual task waitFor(int t);
    endtask

endclass

class SequenceSource #(W=7);

    int segments;
    int min;
    int max;

    rand int write_durations[];
    rand int read_durations[];

    int total;
    SequenceData #(W) data;

    constraint wr {foreach(write_durations[i]) write_durations[i] inside {[min:max]}; }
    constraint rr {foreach(read_durations[i]) read_durations[i] inside {[min:max]}; }

    function new(int segments = 100, int min = 4, int max = 20);
        this.segments = segments * 2 - 1;
        this.min = min;
        this.max = max;
        write_durations = new[this.segments];
        read_durations = new[this.segments];
    endfunction

    function void randomizeData();
        int rtot;
        total = 0;
        foreach(write_durations[i]) begin
            if((i & 1) == 0)
                total += write_durations[i];
        end
        rtot = 0;
        foreach(read_durations[i]) begin
            if((i & 1) == 0)
                rtot += read_durations[i];
        end
        if(total > rtot) begin
            read_durations[segments-1] += total - rtot;
        end else if(total < rtot) begin
            write_durations[segments-1] += rtot - total;
            total = rtot;
        end
        data = new(total);
        assert(data.randomize());
    endfunction

    task writeAll(AbstractWriter #(W) writer);
        int index = 0;
        int dur;
        foreach(write_durations[i]) begin
            dur = write_durations[i];
            if((i & 1) == 0) begin
                for(int step = 0; step < dur; step++) begin
                    writer.write(data.data[index]);
                    $display("Write %d = %h", index, data.data[index]);
                    index++;
                end
            end else begin 
                writer.waitFor(dur);
            end
        end
    endtask

endclass


