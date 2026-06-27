class AbstractSequence #(T) extends uvm_sequence #(T);

    `uvm_object_abstract_param_utils(AbstractSequence)

    function new(string name = "sequence");
        super.new(name);
    endfunction

endclass

