class ResetTransaction extends uvm_sequence_item;

    bit rst_n;

    `uvm_object_utils_begin(ResetTransaction)
        `uvm_field_int(rst_n, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rst");
        super.new(name);
    endfunction

endclass

class WriteTransaction #(W=7) extends uvm_sequence_item;

    rand bit wen;
    rand bit[W:0] data;

    constraint we {wen dist {0:=30, 1:=70};}

    constraint wd {
        solve wen before data;
        if(!wen) data == 0;
    }

    `uvm_object_param_utils_begin(WriteTransaction#(W))
        `uvm_field_int(wen, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "wt");
        super.new(name);
    endfunction

endclass

class ReadTransaction #(W=7) extends uvm_sequence_item;

    rand bit ren;
    bit[W:0] data;

    constraint re {ren dist {0:=50, 1:=50};}

    `uvm_object_param_utils_begin(ReadTransaction#(W))
        `uvm_field_int(ren, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "rt");
        super.new(name);
    endfunction

endclass