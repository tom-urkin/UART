onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /UART_TB/clk_RX
add wave -noupdate /UART_TB/rst_RX
add wave -noupdate /UART_TB/clk_TX
add wave -noupdate /UART_TB/rst_TX
add wave -noupdate /UART_TB/start_TX
add wave -noupdate -radix binary /UART_TB/data_rand
add wave -noupdate -radix unsigned /UART_TB/k
add wave -noupdate -height 30 -expand -group {RX Signals} -radix binary /UART_TB/UART/RX_1/buffer_RX
add wave -noupdate /UART_TB/UART/UART_line
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3134586611 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 231
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
WaveRestoreZoom {2030822400 ps} {9842624587 ps}
