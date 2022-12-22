onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /UART_TB_TX/rst_TX
add wave -noupdate /UART_TB_TX/clk_TX
add wave -noupdate -height 30 -expand -group UART_Line /UART_TB_TX/UART_line
add wave -noupdate -height 30 -expand -group {Initialization commands} /UART_TB_TX/start_TX
add wave -noupdate -height 30 -expand -group {Initialization commands} /UART_TB_TX/UART/TX_1/start_TX
add wave -noupdate -height 30 -expand -group {TB signals} -radix binary /UART_TB_TX/data_rand
add wave -noupdate -height 30 -expand -group {TB signals} -radix unsigned /UART_TB_TX/k
add wave -noupdate -height 30 -expand -group {RX Signals} -radix unsigned /UART_TB_TX/UART/TX_1/count
add wave -noupdate -height 30 -expand -group {RX Signals} -radix unsigned /UART_TB_TX/UART/TX_1/count_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1059660000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 228
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
WaveRestoreZoom {1036803262 ps} {1097999806 ps}
