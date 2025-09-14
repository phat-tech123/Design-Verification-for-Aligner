`ifndef CFS_APB_MONITOR_SV
  `define CFS_APB_MONITOR_SV

  class cfs_apb_monitor extends uvm_monitor implements cfs_apb_reset_handler;

	//Pointer to agent config
	cfs_apb_agent_config agent_config;

	//output port
	uvm_analysis_port#(cfs_apb_item_mon) output_port;

	//Process for collect_transactions() task
	protected process process_collect_transactions;

	`uvm_component_utils(cfs_apb_monitor)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);

		output_port = new("output_port", this);
	endfunction

	//Task for waiting the reset to end 
	virtual task wait_reset_end();
		agent_config.wait_reset_end();
	endtask

	virtual task run_phase(uvm_phase phase);
		forever begin 
			fork
				begin
					wait_reset_end();
					collect_transactions();
					
					disable fork;
				end
			join
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

	protected virtual task collect_transactions();
		fork 
			begin
			process_collect_transactions = process::self();
				forever begin
					collect_transaction();
				end
			end
		join
	endtask

	//Function to handle the reset
	virtual function void handle_reset(uvm_phase phase);
		if(process_collect_transactions != null) begin
			process_collect_transactions.kill();

			process_collect_transactions = null;
		end
	endfunction
  endclass

`endif
