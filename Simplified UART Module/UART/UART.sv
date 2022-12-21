//UART TX and RX. Baud rate of 57600.
module UART	(rst_RX,rst_TX,clk_RX,clk_TX,data_TX,start_TX);

input logic rst_RX;				//RX reset signal
input logic rst_TX;				//TX reset signal
input logic clk_RX;				//RX clock - 50MHz
input logic clk_TX;				//TX clock - 25MHz
input logic start_TX;			//Begin communication signal
input logic [7:0] data_TX;		//Random data to be sent (TX buffer)

logic eoc_flag;					//End of communication flag
logic [7:0] buffer_RX;			//Data recieved (RX buffer)


UART_TX TX_1 (		.rst(rst_TX),
					.clks_per_bit(10'd434),		//Operating with 25MHz clock
					.clk(clk_TX),
					.data(data_TX),
					.UART_line(UART_line),
					.start(start_TX)
					);	


UART_RX RX_1 (	.rst(rst_RX),
					.clks_per_bit(10'd868),		//Operating with 50MHz clock
					.clk(clk_RX),
					.buffer_RX(buffer_RX),
					.RX_in(UART_line),
					.eoc_flag(eoc_flag)
					);		
	
endmodule






