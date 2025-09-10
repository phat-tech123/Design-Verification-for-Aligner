`ifndef CFS_APB_IF_SV
  `define CFS_APB_IF_SV

  `ifndef CFS_APB_MAX_DATA_WIDTH
    `define CFS_APB_MAX_DATA_WIDTH 32
  `endif

  `ifndef CFS_APB_MAX_ADDR_WIDTH
    `define CFS_APB_MAX_ADDR_WIDTH 16
  `endif

  interface cfs_apb_if(input pclk);

	logic preset_n;

	logic psel;

	logic penable;

	logic pwrite;

	logic [`CFS_APB_MAX_ADDR_WIDTH-1:0] paddr;

	logic [`CFS_APB_MAX_DATA_WIDTH-1:0] pwdata;

	logic pready;

	logic [`CFS_APB_MAX_DATA_WIDTH-1:0] prdata;

	logic pslverr;

	bit has_checks;
	initial begin
		has_checks = 1;
	end

//------------------------ APB Protocol Checks -----------------------//
    
//     Rule #1
//     PENABLE must be asserted in the second cycle of the transfer
    
//     Rule #2
//     PENABLE must be deasserted at the of the transfer
    
//     Rule #3
//     Master driven signals must remain constant throughout the transfer
    
//     Rule #4
//     APB signals can not have unknown values (e.g. x, z)
    
//     Rule #5
//     APB transfer can not have an infinite length
    

	//------------------ SEQUENCE --------------------//
	sequence setup_phase_s;
		(psel == 1) && (($past(psel) == 0) || (($past(psel) == 1) && ($past(pready) == 1)));
	endsequence

	sequence access_phase_s;
		(psel == 1) && (penable == 1);
	endsequence
	//------------------ SEQUENCE --------------------//
	

	//---------------- BEGIN RULE 1 ------------------//
	property penable_at_setup_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		setup_phase_s |-> penable == 0;
	endproperty

	PENABLE_AT_SETUP_PHASE_A : assert property(penable_at_setup_phase_p) else
		$error("PENABLE at \"Setup Phase\" is not equal to 0");

	property penable_entering_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		setup_phase_s |=> penable == 1;
	endproperty

	PENABLE_ENTERING_ACCESS_PHASE_A : assert property(penable_entering_access_phase_p) else
		$error("PENABLE when entering \"Access Phase\" is not equal to 1");
	//----------------- END RULE 1 -------------------//


	//---------------- BEGIN RULE 2 ------------------//
	property penable_exiting_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		access_phase_s and (pready == 1) |=> penable == 0;
	endproperty

	PENABLE_EXITING_ACCESS_PHASE_A : assert property(penable_exiting_access_phase_p) else
		$error("PENABLE when exiting \"Access Phase\" is not equal to 0");
	//----------------- END RULE 2 -------------------//


	//---------------- BEGIN RULE 3 ------------------//
	property penable_stable_at_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		access_phase_s |-> penable == 1;
	endproperty

	PENABLE_STABLE_AT_ACCESS_PHASE_A : assert property(penable_stable_at_access_phase_p) else
		$error("PENABLE was not stable at \"Access Phase\"");

	property pwrite_stable_at_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		access_phase_s |-> $stable(pwrite);
	endproperty

	PWRITE_STABLE_AT_ACCESS_PHASE_A : assert property(pwrite_stable_at_access_phase_p) else
		$error("PWRITE was not stable at \"Access Phase\"");

	property paddr_stable_at_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		access_phase_s |-> $stable(paddr);
	endproperty

	PADDR_STABLE_AT_ACCESS_PHASE_A : assert property(paddr_stable_at_access_phase_p) else
		$error("PADDR was not stable at \"Access Phase\"");

	property pwdata_stable_at_access_phase_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		access_phase_s and (pwrite == 1) |-> $stable(pwdata);
	endproperty

	PWDATA_STABLE_AT_ACCESS_PHASE_A : assert property(pwdata_stable_at_access_phase_p) else
		$error("PWDATA was not stable at \"Access Phase\"");
	//----------------- END RULE 3 -------------------//


	//---------------- BEGIN RULE 4 ------------------//
	property unknown_value_psel_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		$isunknown(psel) == 0;
	endproperty

	UNKNOWN_VALUE_PSEL_A : assert property(unknown_value_psel_p) else
		$error("Detected unknown value for APB signal PSEL");

	property unknown_value_penable_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		psel == 1 |-> $isunknown(penable) == 0;
	endproperty

	UNKNOWN_VALUE_PENABLE_A : assert property(unknown_value_penable_p) else
		$error("Detected unknown value for APB signal PENABLE");

	property unknown_value_paddr_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		psel == 1 |-> $isunknown(paddr) == 0;
	endproperty

	UNKNOWN_VALUE_PADDR_A : assert property(unknown_value_paddr_p) else
		$error("Detected unknown value for APB signal PADDR");

	property unknown_value_pwrite_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		psel == 1 |-> $isunknown(pwrite) == 0;
	endproperty

	UNKNOWN_VALUE_PWRITE_A : assert property(unknown_value_pwrite_p) else
		$error("Detected unknown value for APB signal PWRITE");

	property unknown_value_pwdata_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		(psel == 1) && (pwrite == 1)|-> $isunknown(pwdata) == 0;
	endproperty

	UNKNOWN_VALUE_PWDATA_A : assert property(unknown_value_pwdata_p) else
		$error("Detected unknown value for APB signal PWDATA");

	property unknown_value_prdata_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		(psel == 1) && (pwrite == 0) && (pready == 1) && (pslverr == 0)|-> $isunknown(prdata) == 0;
	endproperty

	UNKNOWN_VALUE_PRDATA_A : assert property(unknown_value_prdata_p) else
		$error("Detected unknown value for APB signal PRDATA");

	property unknown_value_pready_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		(psel == 1) |-> $isunknown(pready) == 0;
	endproperty

	UNKNOWN_VALUE_PREADY_A : assert property(unknown_value_pready_p) else
		$error("Detected unknown value for APB signal PREADY");

	property unknown_value_pslverr_p;
		@(posedge pclk) disable iff(!preset_n || !has_checks)
		(psel == 1) && (pready == 1) |-> $isunknown(pslverr) == 0;
	endproperty

	UNKNOWN_VALUE_PSLVERR_A : assert property(unknown_value_pslverr_p) else
		$error("Detected unknown value for APB signal PSLVERR");
	//----------------- END RULE 4 -------------------//

//------------------------ APB Protocol Checks -----------------------//
  endinterface

`endif
