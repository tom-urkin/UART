//UART RX
//Receives 8-bit data package and a single parity bit
//Parameter clks_per_bit is calculated by dividing the communication frequency (baud rate) and the UART_RX clk
//For a baud rate of 57600 and  clk=50Mhz the clks_per_bit equals 868 


module UART_RX(rst,RX_in,clk,buffer_RX,eoc_flag,clks_per_bit,parity_ok);

//Input declarations
input logic rst; 						//Active high logic
input logic RX_in;					//UART communication line from UART_TX. logic high during IDLE state
input logic clk;						//UART_RX clock (not shared with the UART_TX)
input logic [9:0] clks_per_bit;

//Output declarations
output logic [7:0] buffer_RX;				//The received 8-bit
output logic eoc_flag;						//End of communication flag. Rises to logic high after all 8 bits are received after parity check
output logic parity_ok; 					//Checks parity condition

//Internal logic signals 
logic RX_in_tmp;						//Used in the double-flopping of the input signal
logic RX_in_internal;				//Internal RX_in signal used in the RX logic (after double-flopping)
logic [4:0] STATE;					//FSM state
logic [9:0] count;					//Counts from 0 to 868 (according to the baud rate and the RX clock frequency)		
logic [3:0] count_middle;			//Updated at the middle of a bit-period for stable sampling operation
logic [9:0] half_count;				//Half bit-period with respect to the RX clock
logic parity_bit;						//Sampled parity bit
logic flag_initiate;					//Used to determine if the start bit is stable
logic flag_terminate;				//Used to determine if the end bit is stable

//Parameter declarations
parameter IDLE = 5'b00001;				//IDLE state
parameter INITIATE= 5'b00010;			//Initiation bit (1'b0)
parameter ACTIVE = 5'b00100;			//Receiving 8+1 bits
parameter PARITY=5'b01000;				//Termination bit (1'b1)
parameter TERMINATE=5'b10000;
//HDL code

//UART_TX and UART_RX operate in different clock domains. Double-flopping is employed to resolve any metastability issues.
always @(posedge clk or negedge rst)
	if (!rst)
		begin
			RX_in_tmp<=1'b1;
			RX_in_internal<=1'b1;
		end
	else
		begin
			RX_in_tmp<=RX_in;
			RX_in_internal<=RX_in_tmp;
		end

assign half_count = clks_per_bit>>1;		
		
always @(posedge clk or negedge rst)
	if (!rst)
		begin
			count<=10'd0;
			count_middle<=4'd0;
			eoc_flag<=1'b0;
			STATE<=IDLE;
			parity_bit<=1'b0;	
			flag_initiate<=1'b0;
		end
	else
			case (STATE)
				IDLE: 
					begin
						if (RX_in_internal==1'b1)
							STATE<=IDLE;
						else
							STATE<=INITIATE;
							
						count<=10'd0;
						count_middle<=4'd0;
						flag_initiate<=1'b0;
					end
	
				INITIATE:
					begin
						if (count==half_count)
							if (RX_in_internal==1'b0)
								flag_initiate<=1'b1;
							else
								flag_initiate<=1'b0;
						
						if (count==clks_per_bit)
							if (flag_initiate==1'b1)
								STATE<=ACTIVE;
						else 
								STATE<=IDLE;
						
						if (count==clks_per_bit)
							count<=10'd0;
						else 
							count<=count+10'd1;						
					end
	
				ACTIVE:
					begin
						if (count==half_count)
							begin
								buffer_RX<={RX_in_internal,buffer_RX[7:1]};
								count_middle<=count_middle+4'd1;
								count<=count+10'd1;
							end
						else if (count==clks_per_bit)
							count<=10'd0;
						else 
							count<=count+10'd1;
							
						if ((count_middle==4'd8)&&(count==clks_per_bit))
							STATE<=PARITY;
							
					end

				
				PARITY:
					begin
						if (count==half_count)
							begin
								parity_bit<=RX_in_internal;
								count_middle<=count_middle+4'd1;
								count<=count+10'd1;
							end
						else if (count==clks_per_bit)
							count<=10'd0;
						else 
							count<=count+10'd1;
							
						if ((count_middle==4'd9)&&(count==clks_per_bit))
							STATE<=TERMINATE;
					end
				
				TERMINATE: 	
					begin
						if (count==half_count)
							begin
								count<=count+10'd1;
								if (RX_in_internal==1'b1)
										flag_terminate<=1'b1;
								else
										flag_terminate<=1'b0;
							end
						else if (count==clks_per_bit)
							begin
								count<=10'd0;
								count_middle<=4'd0;
								eoc_flag<=(flag_terminate&&parity_ok);	//Rises to logic high only if parity check is OK
								STATE<=IDLE;
							end
						else 
							count<=count+10'd1;
					end
	endcase

	
assign parity_ok = ~(^{buffer_RX,parity_bit}) ? 1'b1 : 1'b0;	//Parity check is integrated in the eoc_flag calculation

endmodule