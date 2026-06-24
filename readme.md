# System Verilog Projects

## Project Requirements
- Verilator
- Z3
- Surfer

## Async FIFO

### Non-UVM random testing

Compile:

`verilator --Wno-WIDTHTRUNC --binary async_fifo/module_test/tb_fifo.sv  --trace`

Execute:

`./obj_dir/Vtb_fifo`