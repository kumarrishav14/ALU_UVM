vlog tb_top.sv

vsim -novopt top +UVM_VERBOSITY=UVM_DEBUG

add wave -position insertpoint sim:/top/intf/*
run -all