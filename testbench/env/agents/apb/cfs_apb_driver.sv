`ifndef CFS_APB_DRIVER_SV
  `define CFS_APB_DRIVER_SV

  class cfs_apb_driver extends uvm_driver#(.REQ(cfs_apb_item_drv));

	//Pointer to agent configuration
	cfs_apb_agent_config agent_config;

	`uvm_component_utils(cfs_apb_driver)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		drive_transactions();
	endtask

	//Task for driving all transactions
	protected virtual task drive_transactions();
		cfs_apb_vif vif = agent_config.get_vif();

		// Initialize configured signals
		vif.psel 	<= 0;
		vif.penable 	<= 0;
		vif.pwrite 	<= 0;
		vif.paddr 	<= 0;
		vif.pwdata 	<= 0;

		forever begin
		cfs_apb_item_drv item;

		seq_item_port.get_next_item(item);

		drive_transaction(item);

		seq_item_port.item_done();
		end

	endtask

	//Task which drives one single item on the bus
	protected virtual task drive_transaction(cfs_apb_item_drv item);

		cfs_apb_vif vif = agent_config.get_vif();

		`uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)

		for(int i = 0; i < item.pre_drive_delay; i++) begin
			@(posedge vif.pclk);
		end

		vif.psel 	<= 1;
		vif.pwrite 	<= bit'(item.dir);
		vif.paddr 	<= item.addr;

		if(item.dir == CFS_APB_WRITE) begin
			vif.pwdata = item.data;
		end

		@(posedge vif.pclk);
		vif.penable 	<= 1;
		@(posedge vif.pclk);

		while(vif.pready !== 1) begin
			@(posedge vif.pclk);
		end
		vif.psel 	<= 0;
		vif.penable 	<= 0;
		vif.pwrite 	<= 0;
		vif.paddr 	<= 0;
		vif.pwdata 	<= 0;

		for(int i = 0; i < item.post_drive_delay; i++) begin
			@(posedge vif.pclk);
		end

	endtask

  endclass

`endif
