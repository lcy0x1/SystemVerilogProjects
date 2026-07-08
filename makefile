FLAGS = --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --sched-zero-delay --timescale 1ns/1ps --binary
UVM = +incdir+uvm/src +define+UVM_NO_DPI uvm/src/uvm_pkg.sv

fifo:
	OBJCACHE=ccache verilator $(FLAGS) +incdir+async_fifo module_test/tb_fifo.sv --trace

run_fifo:
	./obj_dir/Vtb_fifo

.PHONY: fifo_uvm
fifo_uvm:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+async_fifo uvm/tb_top.sv --top-module tb_top --debug --coverage-user

.PHONY: fifo_uvm_trace
fifo_uvm_trace:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+async_fifo uvm/tb_top.sv --top-module tb_top --trace


.PHONY: test
test:
	verilator --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --sched-zero-delay --timescale 1ns/1ps --binary test.sv --top-module tb_top --debug --coverage-user

.PHONY: trans
trans:
	OBJCACHE=ccache verilator $(FLAGS) +incdir+matrix unit_test/tb_trans.sv --trace --top-module tb_trans

.PHONY: trans_uvm
trans_uvm:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+matrix uvm/transpose/tb_top.sv --top-module tb_top

.PHONY: trans_uvm_trace
trans_uvm_trace:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+matrix uvm/transpose/tb_top.sv --top-module tb_top --trace

.PHONY: run_uvm
run_uvm:
	./obj_dir/Vtb_top

.PHONY: mult_test
mult_test:
	OBJCACHE=ccache verilator $(FLAGS) +incdir+matrix unit_test/tb_mult.sv --trace --top-module tb_mult

.PHONY: mult_uvm
mult_uvm:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+matrix uvm/mult/tb_top.sv --top-module tb_top

.PHONY: mult_uvm_trace
mult_uvm_trace:
	OBJCACHE=ccache verilator -j 8 $(FLAGS) $(UVM) +incdir+matrix uvm/mult/tb_top.sv --top-module tb_top --trace
