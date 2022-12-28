//UART TX and RX. Baud rate of 57600.
module UART	(rst,clk,RX,TX,start_TX,eoc_flag,tx_fifo_full,tx_fifo_empty,tx_wr_en,tx_rd_en,tx_busy,tx_fifo_data_in,rx_wr_en,rx_rd_en,rx_fifo_full,rx_fifo_empty,rx_fifo_data_out);

//Parameters 
parameter [9:0] clks_per_bit = 868; 


//Input signals
input logic rst;                                //RX reset signal
input logic clk;                                //FPGA 50MHz clock
input logic RX;                                 //Connects to the PC's TX terminal
input logic start_TX;                           //Initiates trasmission from TX 

input logic [7:0] tx_fifo_data_in;              //Input data of the TX FIFO memory from external logic
input logic rx_wr_en;                           //RX FIFO memory write enable signal
input logic rx_rd_en;                           //RX FIFO memory read enable signal
input logic tx_rd_en;                           //TX FIFO memory read enable signal
input logic tx_wr_en;                           //TX FIFO memory write enable signal


//Output signals
output logic eoc_flag;                         //End of communication flag - logic high for one clock cycle if recived correctly
output logic TX;                               //Connect to the PC's RX terminal
output logic tx_busy;                          //Logic high when TX is busy
output logic tx_fifo_full;                     //Logic high when TX FIFO memory is full
output logic tx_fifo_empty;                    //Logic high when RX FIFO memory is empty

output logic rx_fifo_full;                     //Logic high when RX FIFO memory is full
output logic rx_fifo_empty;                    //Logic high when RX FIFO memory is empty
output logic [7:0] rx_fifo_data_out;           //Output data of RX FIFO memory

//Internal signals
logic [7:0] tx_fifo_data_out;                  //Connect between TX FIFO memory and the input of the UART_TX module
logic [7:0] buffer_RX;                         //Data recieved (RX buffer) - connects the RX module and its FIFO memory


UART_TX TX_1 (	.rst(rst),
				.clks_per_bit(clks_per_bit),		//Operating with 50MHz clock
				.clk(clk),
				.data(tx_fifo_data_out),
				.TX(TX),
				.start(start_TX),
				.busy(tx_busy)
				);	


UART_RX RX_1 (	.rst(rst),
				.clks_per_bit(clks_per_bit),		//Operating with 50MHz clock
				.clk(clk),
				.buffer_RX(buffer_RX),
				.RX(RX),
				.eoc_flag(eoc_flag)
				);		
					
//FIFO instantiations 					
					
FIFO_mem tx_fifo(	.clk(clk),
					.rst(rst),
					.data_in(tx_fifo_data_in),
					.FIFO_empty(tx_fifo_empty),
					.FIFO_full(tx_fifo_full),
					.data_out(tx_fifo_data_out),
					.wr_en(tx_wr_en),
					.rd_en(tx_rd_en)
					);

FIFO_mem rx_fifo(	.clk(clk),
					.rst(rst),
					.data_in(buffer_RX),
					.FIFO_empty(rx_fifo_empty),
					.FIFO_full(rx_fifo_full),
					.data_out(rx_fifo_data_out),
					.wr_en(rx_wr_en),
					.rd_en(rx_rd_en)
					);
	
endmodule
