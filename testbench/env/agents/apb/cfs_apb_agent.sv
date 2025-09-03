`ifndef CFS_APB_AGENT_SV
  `define CFS_APB_AGENT_SV

  class cfs_apb_agent extends uvm_agent;

	`uvm_component_utils(cfs_apb_agent)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction

  cfs_apb_agent_config agent_config;

  virtual function void build_phase(uvm_phase phase);
	build_phase(phase);

  	agent_config = cfs_apb_agent_config::type_id::create("agent_config", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
	cfs_apb_vif vif;

	super.connect_phase(phase);

	if(uvm_config_db#(cfs_apb_vif)::get(this, "", "vif", vif) == 0) begin 
		`uvm_fatal("APB_NO_VIF", "Could not get from the database the APB vitual interface")
	end else begin
		agent_config.set_vif(vif);
	end
  endfunction

  endclass
`endif
