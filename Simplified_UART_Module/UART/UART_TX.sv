//UART TX
//Receives 8-bit data to be sent in a UART frame followed by a parity bit
//Parameter clks_per_bit is calculated by dividing the communication frequency (baud rate) and the UART_RX clk
//For a baud rate of 57600 and  clk=25Mhz the clks_per_bit equals 434 

module UART_TX(rst,data,clk,clks_per_bit,UART_line,start);

//Input declarations
input logic rst; 							//Active high logic
input logic [7:0] data;						//Data to be sent
input logic clk;							//UART_TX clock (not shared with the UART_RX)
input logic [9:0] clks_per_bit;
input logic start;							//Data is transmitted upon positive-edge of the start input

//Output declarations
output logic UART_line;						//Connected to the RX module

//Internal logic signals 
logic start_internal_1;
logic start_internal_2;
logic start_TX;
logic [9:0] count;
logic [3:0] count_bit;

//HDL code

always @(posedge clk or negedge rst)	//Using two registers since the 'start' signal is assumed to be asynchronous to 'clk'
	if (!rst)
		begin
			start_internal_1<=1'b0;
			start_internal_2<=1'b0; 
		end
	else
		begin
			start_internal_1<=start;
			start_internal_2<=start_internal_1; 
		end

assign start_TX = start_internal_1&&(~start_internal_2);		//Rises to logic high at the beginning of a communication cycle

		
always @(posedge clk or negedge rst)
	if (!rst)
		begin
			count_bit<=4'd0;
			count<=10'd0; 
		end
	else
		begin	
			case (count_bit)
			4'd0: 												//Send initiation bit
			begin
					begin
						UART_line<=1'b0;
						count<=10'd0;
						count_bit<=count_bit+4'd1;
					end
			end
			
			4'd1:												//Send LSB. The transmitter can also be written using a shift register 
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
					if (start_TX==1'b1)
						count_bit<=4'd0;
				end
			
			endcase
		end

		
endmodule