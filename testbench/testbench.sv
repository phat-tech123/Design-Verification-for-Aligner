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
  
  //Instance of the APB interface
  cfs_apb_if apb_if(.pclk(clk));
  
  initial begin
	apb_if.preset_n = 1;
    	#6ns;
    	apb_if.preset_n = 0;
    	#30ns;
    	apb_if.preset_n = 1;
  end
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    uvm_config_db#(virtual cfs_apb_if)::set(null, "uvm_test_top.env.apb_agent", "vif", apb_if);
    
    //Start UVM test and phases
    run_test("");
  end
  
  
  //instantiate DUT
  cfs_aligner dut(
    	.clk(clk),

    	.reset_n(apb_if.preset_n),	
	.psel(apb_if.psel),
	.penable(apb_if.penable),
	.pwrite(apb_if.pwrite),
	.paddr(apb_if.paddr),
	.pwdata(apb_if.pwdata),
	.pready(apb_if.pready),
	.prdata(apb_if.prdata),
	.pslverr(apb_if.pslverr)
  );
  
endmodule
