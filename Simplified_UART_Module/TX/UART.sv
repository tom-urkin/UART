//UART TX and RX. Baud rate of 57600.
module UART	(rst_TX,clk_TX,UART_line,data_TX,start_TX);

input logic rst_TX;
input logic clk_TX;
input logic [7:0] data_TX;
input logic start_TX;

output logic UART_line; 


UART_TX TX_1 (		.rst(rst_TX),
					.clks_per_bit(10'd434),		//Operating with 25MHz clock
					.clk(clk_TX),
					.data(data_TX),
					.UART_line(UART_line),
					.start(start_TX)
					);		
	
endmodule