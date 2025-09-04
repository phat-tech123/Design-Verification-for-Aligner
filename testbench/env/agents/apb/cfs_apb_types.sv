`ifndef CFS_APB_TYPES_SV
  `define CFS_APB_TYPES_SV

  //Virtual interface
  typedef virtual cfs_apb_if cfs_apb_vif;

  //APB direction
  typedef enum bit {CFS_APB_READ = 0, CFS_APB_WRITE = 1} cfs_apb_dir;

  //APB address
  typedef bit [`CFS_APB_MAX_ADDR_WIDTH-1:0] cfs_apb_addr;

  //APB data
  typedef bit [`CFS_APB_MAX_DATA_WIDTH-1:0] cfs_apb_data;

`endif
