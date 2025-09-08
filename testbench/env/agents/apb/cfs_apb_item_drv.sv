`ifndef CFS_APB_ITEM_DRV_SV
  `define CFS_APB_ITEM_DRV_SV

  class cfs_apb_item_drv extends cfs_apb_item_base;

	`uvm_object_utils(cfs_apb_item_drv)

	function new(string name = "");
		super.new(name);
	endfunction

	rand int unsigned pre_drive_delay;
	constraint pre_drive_delay_default{
		soft pre_drive_delay <= 5;
	}

	rand int unsigned post_drive_delay;
	constraint post_drive_delay_default{
		soft post_drive_delay <= 5;
	}
	//
	
	virtual function string convert2string();
		string result = super.convert2string();

		if(dir == CFS_APB_WRITE) begin
			result = $sformatf("%0s, data: %0x", result, data);
		end

		result = $sformatf("%0s, pre_drive_delay:%0d, post_drive_delay:%0d",
				   	result, pre_drive_delay, post_drive_delay);

		return result;
	endfunction

  endclass

`endif
