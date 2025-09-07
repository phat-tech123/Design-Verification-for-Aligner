`ifndef CFS_ALGN_TEST_REG_ACCESS_SV
  `define CFS_ALGN_TEST_REG_ACCESS_SV
  
  class cfs_algn_test_reg_access extends cfs_algn_test_base;
	`uvm_component_utils(cfs_algn_test_reg_access)

	function new(string name = "", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this, "TEST DONE");
		
		#100ns;

		//
		fork	
		begin
			cfs_apb_sequence_simple seq_simple = cfs_apb_sequence_simple::type_id::create("seq_simple");

			void'(seq_simple.randomize() with {
				item.addr == 'h0;
				item.dir  == CFS_APB_WRITE;
				item.data == 'h11;
			});

			seq_simple.start(env.apb_agent.sequencer);
		end

		begin
			cfs_apb_sequence_rw req_rw = cfs_apb_sequence_rw::type_id::create("req_rw");

			void'(req_rw.randomize() with{
				req_rw.addr == 'hC;
			});
			req_rw.start(env.apb_agent.sequencer);
		end

		begin
			cfs_apb_sequence_random req_random = cfs_apb_sequence_random::type_id::create("req_random");

			void'(req_random.randomize() with{
				req_random.num_items == 3;
			});
			req_random.start(env.apb_agent.sequencer);
		end
		join
		//

		`uvm_info("DEBUG", "End of test", UVM_LOW);

		phase.drop_objection(this, "TEST DONE");
	endtask
  endclass

`endif
