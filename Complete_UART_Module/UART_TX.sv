//UART TX
//Receives 8-bit data to be sent in a UART frame followed by a parity bit and a stop-bit
//Parameter clks_per_bit is calculated by dividing the communication frequency (baud rate) and the UART_TX clk
//For a baud rate of 57600 and clk=50Mhz the clks_per_bit equals 868 

module UART_TX(rst,data,clk,clks_per_bit,TX,start,busy);

//Input declarations
input logic rst;                             //Active high logic
input logic [7:0] data;                      //Data to be sent (8-bit)
input logic clk;                             //UART_TX clock (not shared with the UART_RX)
input logic [9:0] clks_per_bit;              //Number of TX clk cycles per bit
input logic start;                           //Data is transmitted upon positive-edge of the start signal

//Output declarations
output logic TX;                             //TX line
output logic busy;                           //Logic high when the TX module is busy

//Internal logic signals 
logic start_tmp;                             //Used to sample the start signal
logic start_internal;                        //Rises to logic high at the beginning of a communication cycle
logic [9:0] count;                           //Counts from 0 to clks_per_bit : single bit transmission interval
logic [3:0] count_bit;                       //Holds TX status, i.e. number of bits already sent 

//HDL code

always @(posedge clk or negedge rst)         //start signal is asynchronous to the clk signal - double flopping is employed
  if (!rst) begin
    start_tmp<=1'b0;
    start_internal<=1'b0; 
  end
  else begin
    start_tmp<=start;
    start_internal<=start_tmp; 
  end

//TX Logic

always @(posedge clk or negedge rst)
  if (!rst) begin
    count_bit<=4'd12;              //FSM is in 'default' until a start signal is recieved
    count<=10'd0; 
    busy<=1'b0;
    TX<=1'b1;
  end
  else begin
    case (count_bit)
    4'd0: begin                         //Send initiation bit (1'b0)
    TX<=1'b0;
    count<=10'd0;
    count_bit<=count_bit+4'd1;
    busy<=1'b1;
    end

    4'd1: begin                       //Send LSB
    if (count==clks_per_bit) begin
      TX<=data[0];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      ount<=count+10'd1;
    end

    4'd2: begin
    if (count==clks_per_bit) begin
      TX<=data[1];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd3: begin
    if (count==clks_per_bit) begin
      TX<=data[2];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd4: begin
    if (count==clks_per_bit) begin
      TX<=data[3];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd5: begin
    if (count==clks_per_bit) begin
      TX<=data[4];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd6: begin
    if (count==clks_per_bit) begin
      TX<=data[5];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd7: begin
    if (count==clks_per_bit) begin
      TX<=data[6];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd8: begin                                //Send MSB
    if (count==clks_per_bit) begin
      TX<=data[7];
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd9: begin                               //Send parity bit
    if (count==clks_per_bit) begin
      TX<=^data;               //Parity bit calculation
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd10: begin                              //Send Termination bit
    if (count==clks_per_bit) begin
      TX<=1'b1;
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end

    4'd11: begin
    if (count==clks_per_bit) begin
      count<=10'd0;
      count_bit<=count_bit+4'd1;
    end
    else
      count<=count+10'd1;
    end 

    default: begin
    if (start_internal==1'b1)
      count_bit<=4'd0;
    TX<=1'b1;                   //The TX line is logic high when the TX does not trasmit
    busy<=1'b0;	
    end
    endcase

  end
endmodule