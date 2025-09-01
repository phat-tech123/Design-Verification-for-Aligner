set UVM_HOME $::env(UVM_HOME)

# crate library
vlib work

# map library
vmap work work

# compile UVM
vlog -work work -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv

# compile RTL 
vlog -work work -sv RTL/design.sv

# compile testbench
vlog -work work -sv testbench/testbench.sv

# run
vsim work.testbench -do "run -all; quit"
