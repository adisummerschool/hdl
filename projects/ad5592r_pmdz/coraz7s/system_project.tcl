source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ad5592r_coraz7s

adi_project_files ad5592r_coraz7s [list \
    "$ad_hdl_dir/library/common/ad_iobuf.v" \
    "$ad_hdl_dir/projects/common/coraz7s/coraz7s_system_constr.xdc" \
    "system_constr.xdc" \
    "system_top.v" \
]

adi_project_run ad5592r_coraz7s
