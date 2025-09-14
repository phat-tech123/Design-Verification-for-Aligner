`ifndef CFS_APB_AGENT_CONFIG_SV
  `define CFS_APB_AGENT_CONFIG_SV

  class cfs_apb_agent_config extends uvm_component;

	//virtual interface
	local cfs_apb_vif vif;
	
	//active_passive
	local uvm_active_passive_enum active_passive;

	//Switch to enable checks
	local bit has_checks;

	//Switch to enable coverage
	local bit has_coverage;
	
	//Number of clock cycles after which an APB transfer is considered
    	local int unsigned stuck_threshold;

 	`uvm_component_utils(cfs_apb_agent_config)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);

		active_passive = UVM_ACTIVE;
		has_checks 	= 1;
		stuck_threshold = 1000;
		has_coverage 	= 1;
	endfunction

	//Getter for virutal interface
	virtual function cfs_apb_vif get_vif();
		return vif;
	endfunction

	//Setter for virutal interface
	virtual function void set_vif(cfs_apb_vif value);
		if(vif == null) begin
			vif = value;

			set_has_checks(get_has_checks());
		end else begin 
			`uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
		end
	endfunction

	//Getter for active_passive
	virtual function uvm_active_passive_enum get_active_passive();
		return active_passive;
	endfunction

	//Setter for active_passive
	virtual function void set_active_passive(uvm_active_passive_enum value);
		active_passive = value;
	endfunction

	//Getter for has_checks
	virtual function bit get_has_checks();
		return has_checks;
	endfunction

	//Getter for has_checks
	virtual function void set_has_checks(bit value);
		has_checks = value;

		if(vif != null) begin
			vif.has_checks = has_checks;
		end
	endfunction

	//Getter for has_coverage
	virtual function bit get_has_coverage();
		return has_coverage;
	endfunction

	//Setter for has_coverage
	virtual function void set_has_coverage(bit value);
		has_coverage = value;
	endfunction

	//Getter for stuck_threshold 
	virtual function int unsigned get_stuck_threshold();
		return stuck_threshold;
	endfunction

	//Setter for stuck_threshold
	virtual function void set_stuck_threshold(int unsigned value);
		if(value <= 2) begin
			`uvm_error("ALGORITHM ISSUE", $sformatf("Tried to set stuck_threshold to value %0d but the minimum length of APB transfer is 2", value))
		end
		stuck_threshold = value;
	endfunction

	//Start of simulation phase
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);

		if(get_vif() == null) begin
			`uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \" Start of simulation \" phase")
		end else begin
			`uvm_info("APB_CONFIG", "The APB virtual interface is configured at \" Start of simulation \" phase", UVM_DEBUG)
		end
	endfunction
	
	//Run phase
	virtual task run_phase(uvm_phase phase);
	 	forever begin
			@(vif.has_checks);
			if(vif.has_checks != get_has_checks()) begin
				`uvm_error("ALGORITHM_ISSUE", $sformatf("Can not change \"has_checks\" from APB interface directly - use %s.set_has_checks()", get_full_name()))
			end
		end
	endtask
	

	//Task for waiting the reset to start
	virtual task wait_reset_start();
		if(vif.preset_n !== 0) begin
			@(negedge vif.preset_n);
		end
	endtask

	//Task for waiting the reset to end 
	virtual task wait_reset_end();
		while(vif.preset_n === 0) begin
			@(posedge vif.pclk);
		end
	endtask

  endclass

`endif

