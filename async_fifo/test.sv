class CoverageState;
    bit test;
endclass

class Coverage;

    covergroup cg(CoverageState st);
        coverpoint st.test;
    endgroup

    CoverageState state;

    function new();
        state = new();
        cg = new(state);
    endfunction

endclass

module tb_top;

Coverage cov;

initial begin
    cov = new();
    cov.cg.sample();
end

endmodule