DIR = async_fifo
FLAGS = --Wno-WIDTHTRUNC --Wno-WIDTHEXPAND --sched-zero-delay --timescale 1ns/1ps --binary +incdir+$(DIR)
UVM = +incdir+uvm/src +define+UVM_NO_DPI uvm/src/uvm_pkg.sv

all:
	OBJCACHE=ccache verilator $(FLAGS) uvm/tb_fifo.sv --trace

run:
	./obj_dir/Vtb_fifo

.PHONY: uvm
uvm:
	OBJCACHE=ccache verilator -j 4 $(FLAGS) $(UVM) $(DIR)/uvm/tb_top.sv --top-module tb_top

.PHONY: uvm_trace
uvm_trace:
	OBJCACHE=ccache verilator -j 4 $(FLAGS) $(UVM) $(DIR)/uvm/tb_top.sv --top-module tb_top --trace