transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/ShuDian_Buildings/exp_five_timer {D:/ShuDian_Buildings/exp_five_timer/exp_five_timer.v}

vlog -vlog01compat -work work +incdir+D:/ShuDian_Buildings/exp_five_timer/simulation/modelsim {D:/ShuDian_Buildings/exp_five_timer/simulation/modelsim/exp_five_timer.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  exp_five_timer_vlg_tst

add wave *
view structure
view signals
run -all
