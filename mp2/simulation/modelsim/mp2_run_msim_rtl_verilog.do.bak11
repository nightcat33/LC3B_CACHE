transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/wishbone.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/lc3b_types.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/plus2.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/register.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/mux2.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/mux4.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/cacheControl.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/cacheDatapath.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/Array.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/Comparator.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/mux8.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/adj.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/alu.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/control.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/datapath.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/gencc.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/ir.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/regfile.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/adder.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/nzp.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/sign_extend.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/unadj.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/unsign_extend.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/CPU.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/Cache.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/mp2.sv}

vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/mp2_tb.sv}
vlog -sv -work work +incdir+/home/ketian2/ece411/mp2 {/home/ketian2/ece411/mp2/physical_memory.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L stratixiii_ver -L rtl_work -L work -voptargs="+acc"  mp2_tb

add wave *
view structure
view signals
run 200 ns
