onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /UART_TB_RX/rst_RX
add wave -noupdate -height 30 -expand -group Clocks /UART_TB_RX/clk_RX
add wave -noupdate -height 30 -expand -group Clocks /UART_TB_RX/clk_TX
add wave -noupdate /UART_TB_RX/UART_line
add wave -noupdate -height 30 -expand -group {RX Signals} /UART_TB_RX/UART/RX_1/RX_in_internal
add wave -noupdate -height 30 -expand -group {RX Signals} -radix binary /UART_TB_RX/UART/RX_1/STATE
add wave -noupdate -height 30 -expand -group {RX Signals} -radix binary /UART_TB_RX/UART/RX_1/buffer_RX
add wave -noupdate -height 30 -expand -group {RX Signals} -radix binary /UART_TB_RX/UART/RX_1/eoc_flag
add wave -noupdate -height 30 -expand -group {RX Signals} /UART_TB_RX/UART/RX_1/parity_bit
add wave -noupdate -height 30 -expand -group {RX Signals} -radix unsigned /UART_TB_RX/UART/RX_1/count
add wave -noupdate -height 30 -expand -group {RX Signals} /UART_TB_RX/UART/RX_1/parity_ok
add wave -noupdate -height 30 -expand -group {RX Signals} -radix unsigned /UART_TB_RX/UART/RX_1/count_middle
add wave -noupdate -height 30 -expand -group {TB Signals} -radix binary /UART_TB_RX/data_rand
add wave -noupdate /UART_TB_RX/kaka
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {437640000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
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
WaveRestoreZoom {0 ps} {3699392192 ps}
