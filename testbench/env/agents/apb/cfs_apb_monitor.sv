`ifndef CFS_APB_MONITOR_SV
  `define CFS_APB_MONITOR_SV

  class cfs_apb_monitor extends uvm_monitor;

	//Pointer to agent config
	cfs_apb_agent_config agent_config;

	//output port
	uvm_analysis_port#(cfs_apb_item_mon) output_port;

	`uvm_component_utils(cfs_apb_monitor)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);

		output_port = new("output_port", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		collect_transactions();
	endtask

	protected virtual task collect_transactions();
		forever begin
			collect_transaction();
		end
	endtask

	protected virtual task collect_transaction();
		cfs_apb_vif vif = agent_config.get_vif();
		cfs_apb_item_mon item = cfs_apb_item_mon::type_id::create("item");
				
		while(vif.psel !== 1) begin
			@(posedge vif.pclk);
			item.prev_item_delay++;
		end

		item.addr = vif.paddr;
		item.dir  = cfs_apb_dir'(vif.pwrite);

		if(item.dir == CFS_APB_WRITE) begin
			item.data = vif.pwdata;
		end

		item.length = 1;

		@(posedge vif.pclk);
		item.length++;

		while(vif.pready !== 1) begin
			@(posedge vif.pclk);
			item.length++;

			if(agent_config.get_has_checks()) begin
				if(item.length >= agent_config.get_stuck_threshold()) begin
					`uvm_error("PROTOCOL ERROR", $sformatf("The APB transfer reached stuck threshold of %0d clock cycles", item.length))
				end
			end
		end

		item.response = cfs_apb_response'(vif.pslverr);

		if(item.dir == CFS_APB_READ) begin
			item.data = vif.prdata;
		end

		output_port.write(item);

		`uvm_info("DEBUG", $sformatf("Monitored item: %0s", item.convert2string()), UVM_NONE);
		
		@(posedge vif.pclk);

	endtask

  endclass

`endif
