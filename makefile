DIR = async_fifo
TOP = tb_fifo

TARGET = module_test/$(TOP).sv
FLAGS = --Wno-WIDTHTRUNC --sched-zero-delay --timescale 1ns/1ps --binary +incdir+$(DIR)
UVM = +incdir+$$UVM_HOME +define+UVM_NO_DPI $$UVM_HOME/uvm_pkg.sv

all:
	verilator $(FLAGS) $(TARGET) --trace

run:
	./obj_dir/V$(TOP)

.PHONY: uvm
uvm:
	verilator $(FLAGS) $(UVM) -j 4 $(DIR)/$(TARGET)