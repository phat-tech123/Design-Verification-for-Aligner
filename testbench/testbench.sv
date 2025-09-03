`include "./packages/cfs_algn_test_pkg.sv"

module testbench();
  import uvm_pkg::*;
  import cfs_algn_test_pkg::*;
  
  //clock sinal
  reg clk;
  
  //clock generator
  initial begin
    clk = 0;
    forever begin
      //generate 100MHz clock
      clk = #5ns ~clk;
    end
  end
  
  
  //reset signal
  reg reset_n;
  
  initial begin
  	reset_n = 1;
    #6ns;
    reset_n = 0;
    #30ns;
    reset_n = 1;
  end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    run_test("");
  end
  
  
  //instantiate DUT
  cfs_aligner dut(
    .clk(clk),
    .reset_n(reset_n)
  );
  
endmodule
