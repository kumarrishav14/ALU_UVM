vlog tb_top.sv

vsim -novopt top +UVM_VERBOSITY=UVM_LOW

add wave -position insertpoint sim:/top/intf/*
run -all