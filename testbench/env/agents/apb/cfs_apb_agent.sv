`ifndef CFS_APB_AGENT_SV
  `define CFS_APB_AGENT_SV

  class cfs_apb_agent extends uvm_agent implements cfs_apb_reset_handler;

	`uvm_component_utils(cfs_apb_agent)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction

	//Agent configuration handler  
	cfs_apb_agent_config agent_config;

	//Sequencer handler  
	cfs_apb_sequencer sequencer;

	//Driver handler  
	cfs_apb_driver driver;

	//Monitor handler
	cfs_apb_monitor monitor;

	//Coverage handler
	cfs_apb_coverage coverage;

	//Build phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_config 	= cfs_apb_agent_config::type_id::create("agent_config", this);
		monitor      	= cfs_apb_monitor::type_id::create("monitor", this);	

		coverage    	= cfs_apb_coverage::type_id::create("coverage", this);

		if(agent_config.get_active_passive() == UVM_ACTIVE) begin
			sequencer = cfs_apb_sequencer::type_id::create("sequencer", this);
			driver 	  = cfs_apb_driver::type_id::create("driver", this);
		end
	endfunction

	//Connect phase
	virtual function void connect_phase(uvm_phase phase);
		cfs_apb_vif vif;

		super.connect_phase(phase);

		// Connect virtual interface
		if(uvm_config_db#(cfs_apb_vif)::get(this, "", "vif", vif) == 0) begin 
			`uvm_fatal("APB_NO_VIF", "Could not get from the database the APB virtual interface")
		end else begin
			agent_config.set_vif(vif);
		end

		monitor.agent_config = agent_config;

		// Connect monitor to coverage
		if(agent_config.get_has_coverage()) begin
			coverage.agent_config = agent_config;
			monitor.output_port.connect(coverage.port_item);
		end

		// Connect sequencer to driver
		if(agent_config.get_active_passive() == UVM_ACTIVE) begin
			driver.agent_config = agent_config;
			driver.seq_item_port.connect(sequencer.seq_item_export);
		end
	endfunction


	//Function to handle the reset
	virtual function void handle_reset(uvm_phase phase);
		uvm_component children[$];

		get_children(children);

		foreach(children[idx]) begin
			cfs_apb_reset_handler reset_handler;

			if($cast(reset_handler, children[idx])) begin
				reset_handler.handle_reset(phase);
			end
		end
	endfunction

	//Task for waiting the reset to start
	virtual task wait_reset_start();
		agent_config.wait_reset_start();
	endtask

	//Task for waiting the reset to end 
	virtual task wait_reset_end();
		agent_config.wait_reset_end();
	endtask


	virtual task run_phase(uvm_phase phase);
		forever begin
			wait_reset_start();
			handle_reset(phase);
			wait_reset_end();
		end
	endtask

  endclass
`endif
