`ifndef CFS_APB_SEQUENCE_RANDOM_SV
  `define CFS_APB_SEQUENCE_RANDOM_SV

  class cfs_apb_sequence_random extends cfs_apb_sequence_base;
	`uvm_object_utils(cfs_apb_sequence_random)

	function new(string name = "");
		super.new(name);
	endfunction

	rand int unsigned num_items;

	virtual task body();
		for(int i = 0; i < num_items; i++) begin
			cfs_apb_sequence_simple seq_simple;

			`uvm_do(seq_simple);
		end
	endtask

  endclass

`endif
