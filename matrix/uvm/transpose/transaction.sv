`ifndef UVM_TRANSPOSE_TRANSACTION
`define UVM_TRANSPOSE_TRANSACTION

class TransposeResetTransaction extends uvm_sequence_item;

    bit reset;
    bit enable;

    `uvm_object_utils_begin(TransposeResetTransaction)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rst");
        super.new(name);
    endfunction

endclass

class MatrixTransaction #(W=7) extends uvm_sequence_item;

    rand int data[0:(W+1)*(W+1)-1];

    `uvm_object_param_utils_begin(MatrixTransaction#(W))
        `uvm_field_sarray_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "matrix");
        super.new(name);
    endfunction

endclass

class TransposeInputTransaction #(W=7) extends MatrixTransaction #(W);

    randc bit transpose;
    bit clearMult;
    int delay;

    `uvm_object_param_utils_begin(TransposeInputTransaction#(W))
        `uvm_field_int(transpose, UVM_ALL_ON)
        `uvm_field_int(clearMult, UVM_ALL_ON)
        `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "input");
        super.new(name);
        clearMult = 1;
        delay = W*2+1;
    endfunction

endclass


class TransposeOutputTransaction #(W=7) extends MatrixTransaction #(W);

    bit clearMult[0:W];

    `uvm_object_param_utils_begin(TransposeOutputTransaction#(W))
        `uvm_field_sarray_int(clearMult, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "output");
        super.new(name);
    endfunction

endclass

`endif