# Makefile for ModelSim

all: cmp run wave
	@echo "Verification based on ModelSim"

lint:
	vlib work
	vmap work work
	vlog -mfcu -lint -sv -timescale 1ns/1ps -f ../rtl/filelist.f tb_top.sv

cmp:
	vlib work
	vmap work work
	vlog -mfcu -sv -timescale 1ns/1ps -f ../rtl/filelist.f tb_top.sv

run:
	vsim -c -voptargs=+acc work.tb_top -wlf wave.wlf -do run.do

wave:
	vsim -view wave.wlf -do wave.do

clean:
	@rm -rf work wave.vcd wave.wlf transcript modelsim.ini

