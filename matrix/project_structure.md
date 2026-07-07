# Matrix Multiplier

data_interface
| |-> block_mem
| | |-> memory
|-> controller
| |-> m8x8
| | |-> relu
| | |-> mac
| | | |-> adder
| | | |-> multiplier
| | |-> t8x8
| | | |-> trans