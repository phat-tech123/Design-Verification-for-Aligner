xrun -Q -unbuffered '-timescale' '1ns/1ns' '-sysv' '+UVM_TESTNAME=cfs_algn_test_reg_access' '-access' '+rw' -uvmnocdnsextra -uvmhome $UVM_HOME $UVM_HOME/src/uvm_macros.svh design.sv testbench.sv  
