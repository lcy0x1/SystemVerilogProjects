`ifndef UVM_MULT_TRANSACTION
`define UVM_MULT_TRANSACTION

class MultResetTransaction extends uvm_sequence_item;

    bit reset;
    bit enable;

    `uvm_object_utils_begin(MultResetTransaction)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rst");
        super.new(name);
    endfunction

endclass

class MultInputTransaction #(W=7) extends uvm_sequence_item;

    rand int w[0:(W+1)*(W+1)-1];
    rand int x[0:(W+1)*(W+1)-1];
    randc bit[3:0] conf;
    bit clear;
    int delay;

    constraint matw {foreach (w[i]) { w[i] inside {[-255:255]}; } }
    constraint matx {foreach (x[i]) { x[i] inside {[-255:255]}; } }

    `uvm_object_param_utils_begin(MultInputTransaction#(W))
        `uvm_field_sarray_int(w, UVM_ALL_ON)
        `uvm_field_sarray_int(x, UVM_ALL_ON)
        `uvm_field_int(conf, UVM_ALL_ON)
        `uvm_field_int(clear, UVM_ALL_ON)
        `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "input");
        super.new(name);
        clear = 1;
        delay = W-1;
        conf = 0;
    endfunction

endclass

class MultOutputTransaction #(W=7) extends uvm_sequence_item;

    int data[0:(W+1)*(W+1)-1];
    bit[W:0] clear;
    bit[3:0] conf; // for debug purpose only

    `uvm_object_param_utils_begin(MultOutputTransaction#(W))
        `uvm_field_sarray_int(data, UVM_ALL_ON)
        `uvm_field_sarray_int(clear, UVM_ALL_ON)
        `uvm_field_sarray_int(conf, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "output");
        super.new(name);
    endfunction

endclass

`endif