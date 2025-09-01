module testbench();
  
  import uvm_pkg::*;
  //import cfs_algn_test_pkg::*;
  
  reg clk;
  reg reset_n;
  
  initial begin
  	clk = 0;
    
    forever begin
    	clk = #5ns ~clk;
    end
  end
  
  initial begin
  reset_n = 1;
    #6ns;
    reset_n = 0;
    #30ns;
    reset_n = 1;
  end
  
  
  cfs_aligner dut(
    .clk(clk),
    .reset_n(reset_n)
  );
endmodule
