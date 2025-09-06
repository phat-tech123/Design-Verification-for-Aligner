`ifndef CFS_APB_AGENT_CONFIG_SV
  `define CFS_APB_AGENT_CONFIG_SV

  class cfs_apb_agent_config extends uvm_component;

	//virtual interface
	local cfs_apb_vif vif;
	
	//active_passive
	local uvm_active_passive_enum active_passive;

 	`uvm_component_utils(cfs_apb_agent_config)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);

		active_passive = UVM_ACTIVE;
	endfunction

	//Getter for virutal interface
	virtual function cfs_apb_vif get_vif();
		return vif;
	endfunction

	//Setter for virutal interface
	virtual function void set_vif(cfs_apb_vif value);
		if(vif == null) begin
			vif = value;
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

	//Start of simulation phase
	virtual function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);

		if(get_vif() == null) begin
			`uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \" Start of simulation \" phase")
		end else begin
			`uvm_info("APB_CONFIG", "The APB virtual interface is configured at \" Start of simulation \" phase", UVM_LOW)
		end
	endfunction

  endclass

`endif
