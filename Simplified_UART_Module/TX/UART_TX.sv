//UART TX
//Receives 8-bit data to be sent in a UART frame followed by a parity bit
//Parameter clks_per_bit is calculated by dividing the communication frequency (baud rate) and the UART_TX clk
//For a baud rate of 57600 and clk=25Mhz the clks_per_bit equals 434 

module UART_TX(rst,data,clk,clks_per_bit,UART_line,start);

//Input declarations
input logic rst; 							//Active high logic
input logic [7:0] data;						//Data to be sent (8-bit)
input logic clk;							//UART_TX clock (not shared with the UART_RX), 25MHz in this example.
input logic [9:0] clks_per_bit;				//Number of TX clk cycles per bit
input logic start;							//Data is transmitted upon positive-edge of the start input

//Output declarations
output logic UART_line;						//Output of the TX module - connect to the RX line of the secondary device			

//Internal logic signals 
logic start_tmp;							//Used to sample the start signal
logic start_internal;						//Rises to logic high at the beginning of a communication cycle
logic [9:0] count;							//Counts from 0 to clks_per_bit -single bit transmission interval
logic [3:0] count_bit;						//Holds TX status, i.e. number of bits already sent 

//HDL code

always @(posedge clk or negedge rst)		//start signal is asynchronous to the clk signal - double flopping is employed
	if (!rst)
		begin
			start_tmp<=1'b0;
			start_internal<=1'b0; 
		end
	else
		begin
			start_tmp<=start;
			start_internal<=start_tmp; 
		end

	
always @(posedge clk or negedge rst)		//TX logic
	if (!rst)
		begin
			count_bit<=4'd11;				//FSM is in 'default' until a start signal is recieved
			count<=10'd0; 
		end
	else
		begin	
			case (count_bit)
			4'd0: 												//Send initiation bit (1'b0)
			begin
					begin
						UART_line<=1'b0;
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
			end
			
			4'd1:												//Send LSB
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[0];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end
			
			4'd2:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[1];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end	
			
			4'd3:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[2];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end			
		
			4'd4:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[3];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end

			4'd5:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[4];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end			
			

			4'd6:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[5];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end

			4'd7:
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[6];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end

			
			4'd8:											//Send MSB
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=data[7];
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end			
			
			4'd9:											//Send parity bit
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=^data;					//Parity bit calculation
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end			

			4'd10:											//Send Termination bit
			begin
				if (count==clks_per_bit)
					begin
						UART_line<=1'b1;
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
				else
					count<=count+10'd1;
			end	
			
			default: 
				begin
					if (start_internal==1'b1)
						count_bit<=4'd0;
				end
			
			endcase
			
		end

		
endmodule