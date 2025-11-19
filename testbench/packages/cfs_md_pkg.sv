`ifndef CSF_MD_PKG_SV
  `define CSF_MD_PKG_SV

  `include "uvm_macros.svh"

  `include "./../env/agents/md/cfs_md_if.sv"

  package cfs_md_pkg;
	import uvm_pkg::*;

	`include "./../env/agents/md/cfs_md_agent_config.sv"
	`include "./../env/agents/md/cfs_md_agent_config_slave.sv"
	`include "./../env/agents/md/cfs_md_agent_config_master.sv"
	`include "./../env/agents/md/cfs_md_reset_handler.sv"
	`include "./../env/agents/md/cfs_md_agent.sv"
	`include "./../env/agents/md/cfs_md_agent_slave.sv"
	`include "./../env/agents/md/cfs_md_agent_master.sv"
  endpackage	

`endif
