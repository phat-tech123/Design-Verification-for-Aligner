`ifndef CFS_MD_AGENT_CONFIG_SV
  `define CFS_MD_AGENT_CONFIG_SV

  class cfs_md_agent_config#(int unsigned DATA_WIDTH = 32) extends uvm_component;
	
    typedef virtual cfs_md_if#(DATA_WIDTH) cfs_md_vif;

    //Virtual interface
    local cfs_md_vif vif;

    //Active/Passive control
    local uvm_active_passive_enum active_passive;

    //Switch to enable coverage
    local bit has_coverage;

    //Switch to enable checks
    local bit has_checks;
     
	
    `uvm_component_param_utils(cfs_md_agent_config#(DATA_WIDTH))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      active_passive  = UVM_ACTIVE;
      has_coverage    = 1;
      has_checks      = 1;
      
    endfunction
    
    //Getter for the MD virtual interface
    virtual function cfs_md_vif get_vif();
      return vif;
    endfunction

    //Setter for the MD virtual interface
    virtual function void set_vif(cfs_md_vif value);
      if(vif == null) begin
        vif = value;

        set_has_checks(get_has_checks());
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the MD virtual interface more than once")
      end
    endfunction

    //Getter for the MD Active/Passive control
    virtual function uvm_active_passive_enum get_active_passive();
      return active_passive;
    endfunction

    //Setter for the MD Active/Passive control
    virtual function void set_active_passive(uvm_active_passive_enum value);
      active_passive = value;
    endfunction

    //Getter for the has_coverage control field
    virtual function bit get_has_coverage();
      return has_coverage;
    endfunction

    //Setter for the has_coverage control field
    virtual function void set_has_coverage(bit value);
      has_coverage = value;
    endfunction

    //Getter for the has_checks control field
    virtual function bit get_has_checks();
      return has_checks;
    endfunction

    //Setter for the has_checks control field
    virtual function void set_has_checks(bit value);
      has_checks = value;

      if(vif != null) begin
        vif.has_checks = has_checks;
      end
    endfunction
    
    //Task for waiting the reset to start
    virtual task wait_reset_start();
      if(vif.reset_n !== 0) begin
        @(negedge vif.reset_n);
      end
    endtask

    //Task for waiting the reset to be finished
    virtual task wait_reset_end();
      while(vif.reset_n == 0) begin
        @(posedge vif.clk);
      end
    endtask

    
  endclass
`endif
