# System Verilog Projects

## Async FIFO

### Non-UVM random testing

Compile:

`verilator --Wno-WIDTHTRUNC --binary async_fifo/module_test/tb_fifo.sv  --trace`

Execute:

`./obj_dir/Vtb_fifo`