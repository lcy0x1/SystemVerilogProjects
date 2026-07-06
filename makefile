FLAGS = --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --sched-zero-delay --timescale 1ns/1ps --binary
UVM = +incdir+uvm/src +define+UVM_NO_DPI uvm/src/uvm_pkg.sv

all:
	OBJCACHE=ccache verilator $(FLAGS) +incdir+async_fifo module_test/tb_fifo.sv --trace

run:
	./obj_dir/Vtb_fifo

.PHONY: uvm
uvm:
	verilator -j 4 $(FLAGS) $(UVM) +incdir+async_fifo uvm/tb_top.sv --top-module tb_top --debug --coverage-user

.PHONY: uvm_trace
uvm_trace:
	OBJCACHE=ccache verilator -j 4 $(FLAGS) $(UVM) +incdir+async_fifo uvm/tb_top.sv --top-module tb_top --trace


.PHONY: test
test:
	verilator --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --sched-zero-delay --timescale 1ns/1ps --binary test.sv --top-module tb_top --debug --coverage-user

.PHONY: trans
trans:
	OBJCACHE=ccache verilator $(FLAGS) +incdir+matrix unit_test/tb_trans.sv --trace --top-module tb_trans