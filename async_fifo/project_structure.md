# Async FIFO

## build command

`verilator --Wno-WIDTHTRUNC --binary async_fifo/module_test/tb_fifo.sv  --trace`

## DUT

This FIFO has a write pointer handler, read pointer handler, buffer.

The pointer handlers are based on respective clock domains.
To know if the fifo is empty or not, it must know the opposite handler pointer.
Cross-Domain data transfer is not safe because the output of the other handler
can violate the setup and hold time of out handler.
To address this issue, we can use 2-stage FF synchronizer.
To prevent every bit transferring at different time, 
we use grey code for pointer communication.
Every time a pointer is incremented, only one bit will change.
Thus, the output will only either be the previous value or the updated value.
No other values could be read.

The buffer is cyclic. There are several ways to design the buffer logic around this:
- Use a flag to represent warpping around the buffer.
- Sacrifice a buffer slot so that total state equals the bits of pointer.

With the first approach, the empty condition is `!warp & wptr == rptr`. 
The full condition is `warp & wptr == rptr`. 
However, it'd difficult to design the logic to update `warp` flag independently on both handlers.

With the second approach, the empty condition is `wptr == rptr`. 
The full condition is `wptr+1 == rptr`. 
It's quite easy but the `full` flag will raise when there is still one buffer slot empty.

## Testbench

### fifo_bus

### SequenceData

### SequenceSource

### Verifier

### Writer

### Reader


wen -> full -> wen