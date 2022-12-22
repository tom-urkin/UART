//UART TX and RX. Baud rate of 57600.
module UART	(rst_RX,clk_RX,UART_line);

input logic rst_RX;
input logic clk_RX;
input logic UART_line; 

logic eoc_flag;
logic [7:0] buffer_RX;


UART_RX RX_1 (		.rst(rst_RX),
					.clks_per_bit(10'd868),		//Operating with 50MHz clock
					.clk(clk_RX),
					.buffer_RX(buffer_RX),
					.RX_in(UART_line),
					.eoc_flag(eoc_flag)
					);		
	
endmodule