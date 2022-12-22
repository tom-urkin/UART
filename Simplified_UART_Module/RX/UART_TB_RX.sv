`timescale 1ns/100ps

module UART_TB_RX();
//For the RX TB the UART model instantiates only the UART_RX module.
//The relevant TB should be chosen in the project settings in Quartus environment along with the relevant .do file.

logic clk_RX;							//RX internal clock - not shared with TX module
logic rst_RX;							

//Internal signals declarations
logic UART_line;						//Wire connecting the TX and RX
logic clk_TX;							//TX clock - 25MHz in this example
logic [8:0] data_rand;					//Randomly generated data to be transmitted
integer k;								//Used in the verification loop

//Parameter declarations
parameter TX_bit_period = 17360;		//TX operates at 25MHz, baud rate of 57600 --> 434 TX clock cycles --> time-per-bit equals 434*40 ns


//UART modules instantiation - For the RX TB the UART module instantiates only the RX unit
UART UART(
				.rst_RX(rst_RX),
				.clk_RX(clk_RX),
				.UART_line(UART_line)
				);
			

//Serializing the parity bit followed by 8-bit data 
task Serial_TX;
	input logic [8:0] data;
	integer j;
	begin
			UART_line<=1'b0;					//UART initiation bit
			#(TX_bit_period);
			for (j=0; j<9; j++)
				begin
					UART_line<=data[j];			//Sending LSB first
					#(TX_bit_period);
				end
			UART_line<=1'b1;					//Sending Termination bit					
			#(TX_bit_period);

	end
endtask

//Initial blocks
initial 
begin
	rst_RX<=1'b0;	
	clk_RX<=1'b0;
	clk_TX<=1'b0;
	UART_line<=1'b1;			//IDLE STATE
	#1000
	rst_RX<=1'b1;
	#20000
	
	for(k=0; k<10; k++)			
		begin
		#(TX_bit_period)
		data_rand= $random%9;				//To verify the parity check, the parity bit is randomly generated
		Serial_TX(data_rand);				//Execute UART communication
		#(1000)								//Make sure the outcome is sampled after eoc_flag is calculated
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


