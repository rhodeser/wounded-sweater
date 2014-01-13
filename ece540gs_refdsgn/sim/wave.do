onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/FPGA/sysclk
add wave -noupdate -format Logic /tb/FPGA/sysreset
add wave -noupdate -format Literal -radix binary /tb/btn
add wave -noupdate -format Literal -radix binary /tb/FPGA/db_btns
add wave -noupdate -format Literal -radix ascii /tb/digits_out
add wave -noupdate -divider {Display Digits}
add wave -noupdate -format Literal -radix hexadecimal /tb/FPGA/dig3
add wave -noupdate -format Literal -radix hexadecimal /tb/FPGA/dig2
add wave -noupdate -format Literal -radix hexadecimal /tb/FPGA/dig1
add wave -noupdate -format Literal -radix hexadecimal /tb/FPGA/dig0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60970 ns} 0}
configure wave -namecolwidth 163
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {59882 ns} {62058 ns}
