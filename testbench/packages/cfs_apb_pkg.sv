`ifndef CFS_APB_PKG_SV
  `define CFS_APB_PKG_SV

  `include "uvm_macros.svh"

  `include "./../env/agents/apb/cfs_apb_if.sv"

  package cfs_apb_pkg;
	import uvm_pkg::*;

	`include "./../env/agents/apb/cfs_apb_types.sv"
	`include "./../env/agents/apb/cfs_apb_item_base.sv"
	`include "./../env/agents/apb/cfs_apb_item_drv.sv"
	`include "./../env/agents/apb/cfs_apb_agent_config.sv"
	`include "./../env/agents/apb/cfs_apb_agent.sv"
  endpackage

`endif
