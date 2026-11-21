onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mem_top/DUT/clk
add wave -noupdate /mem_top/DUT/rst_n
add wave -noupdate /mem_top/DUT/write_en
add wave -noupdate /mem_top/DUT/read_en
add wave -noupdate /mem_top/DUT/address
add wave -noupdate /mem_top/DUT/data_in
add wave -noupdate /mem_top/DUT/data_out
add wave -noupdate /mem_top/DUT/valid_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2529 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
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
WaveRestoreZoom {502 ns} {2105 ns}
