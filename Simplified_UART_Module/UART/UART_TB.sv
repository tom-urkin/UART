`timescale 1ns/100ps

module UART_TB();
//The relevant TB should be chosen in the project settings in Quartus environment along with the relevant .do file.


logic clk_RX;							//RX clock 50MHz
logic rst_RX;							//RX reset - active high
logic clk_TX;							//TX clock - 25MHz
logic rst_TX;							//TX reset - active high
logic start_TX;							//Begin communication signal
logic [7:0] data_rand;					//Random data to be transmitted
integer k;

//Parameter declarations
parameter TX_bit_period = 17360;		//TX operates at 25MHz, baud rate of 57600 --> 434 TX clock cycles --> time-per-bit equals 434*40 

//UART modules instantiation - For the RX TB the UART module instantiates only the RX unit
UART UART(
				.rst_RX(rst_RX),
				.rst_TX(rst_TX),
				.clk_RX(clk_RX),
				.clk_TX(clk_TX),
				.data_TX(data_rand),
				.start_TX(start_TX)
				);
			
//Initial blocks
initial 
begin
	rst_TX<=1'b0;	
	clk_TX<=1'b0;
	rst_RX<=1'b0;	
	clk_RX<=1'b0;
	
	start_TX<=1'b0;
	data_rand<=8'd0;
	
	#(TX_bit_period)			//Release from reset mode
	rst_TX<=1'b1;
	rst_RX<=1'b1;
	#(TX_bit_period)
	
	for(k=0; k<10; k++)
		begin
		#(40*TX_bit_period)
		data_rand= $random%8;
		start_TX<=1'b1;
		#(TX_bit_period)	
		start_TX<=1'b0;
		#(20*TX_bit_period)	//Wait for transmission to be over
		if (UART.RX_1.buffer_RX == data_rand[7:0])
			begin
			$display("Data sent is %b data received is %b - successfully received",data_rand[7:0] ,UART.RX_1.buffer_RX);
			$display("Parity bit is %b", UART.RX_1.parity_bit);
			if (UART.RX_1.eoc_flag==1'b1)		
			$display("Parity check is OK");
			else
			$display("Parity check is NOT OK");			
			end
		else
			$display("Test failed");
				
		
		end
end


//50MHz clock generation - UART_RX and 25MHz clock generation - UART_TX
always	
begin
#10; 
clk_RX=~clk_RX;	
#10
clk_RX=~clk_RX;
clk_TX=~clk_TX;
end		


endmodule


