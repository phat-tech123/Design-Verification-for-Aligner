`ifndef CFS_ALGN_PKG_SV
  `define CFS_ALGN_PKG_SV

  `include "uvm_macros.svh"
  `include "cfs_apb_pkg.sv"
  
  package cfs_algn_pkg;
	import uvm_pkg::*;
	import cfs_apb_pkg::*;

 	`include "./../env/cfs_algn_env.sv"
  endpackage

`endif
