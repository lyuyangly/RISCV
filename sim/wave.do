onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/u_dut/clk
add wave -noupdate -radix hexadecimal /tb_top/u_dut/intr_i
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_arlen
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_arsize
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_arburst
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_araddr
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_arready
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_arvalid
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awlen
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awsize
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awburst
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awaddr
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awready
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_awvalid
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_rlast
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_rready
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_rvalid
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_rdata
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_rresp
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_wready
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_wvalid
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_wstrb
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_wdata
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_wlast
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_bvalid
add wave -noupdate -radix hexadecimal /tb_top/u_dut/cpu_bready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {4287754 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {357546 ps} {4929860 ps}
