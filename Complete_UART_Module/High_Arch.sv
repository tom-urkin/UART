//UART module (TX,RX and FIFO memories) Baud rate of 57600 and 50MHz internal clock.
module High_Arch(rst,clk,RX,TX);

//Inputs
input logic rst;                                         //Active high logic	
input logic clk;                                         //UART input clock, 50MHz
input logic RX;                                          //UART RX signal - connects to the PC's TX line

//Outputs
output logic TX;                                         //UART TX signal - connects to the PC's RX line


//Internal signals
logic rst_samp;                                         //Used to filter 'rst' switch glitches
logic [9:0] count_rst;                                  //Used to filter 'rst' switch glitches

logic start_TX;                                         //TX initiation signal 
logic eoc_flag;                                         //Rises to logic high if a byte is recieved correctly (end-bit and partiy bit)	
logic eoc_flag_delayed;                                 //One clock cycle delayed eox_flag						
logic tx_busy;                                          //Logic high when TX module is activated

logic [4:0] tx_fifo_data_in;                            //TX FIFO memory input data
logic tx_fifo_full;                                     //Logic high if the TX FIFO memory is full (do not write condition)
logic tx_fifo_empty;                                    //Logic high if the TX FIFO memory is empty (do not read condition)
logic tx_wr_en;                                         //TX FIFO memory write enable
logic tx_rd_en;                                         //TX FIFO memory read enable
logic tx_rd_en_tmp;                                     //Used to generate the tx_rd signal					
logic tx_rd_en_tmp_delayed;                             //Used to generate the tx_rd signal

logic rx_fifo_full;                                     //Logic high if RX FIFO memory is full (do not write condition)
logic rx_fifo_empty;                                    //Logic high if RX FIFO memory is empty (do not read condition )
logic rx_wr_en;                                         //RX FIFO memory write enable
logic rx_rd_en;                                         //RX FIFO memory read enable
logic [7:0] rx_fifo_data_out;                           //RX FIFO mermoy output data


logic [4:0] count_load_TX;                             //USed to load the TX FIFO memory with data to be sent 

//HDL code

//Filtering the rst signal (the switches on the FPGA have lots of glitches)
always @(posedge clk or negedge rst)
  if (!rst) begin
    count_rst<=10'd0;
    rst_samp<=1'b0;
  end
  else
  if (count_rst<10'd1000) begin
    count_rst<=count_rst+10'd1;
    rst_samp<=1'b0;
  end
  else 
    rst_samp<=rst;

//UART instantiation 
UART #(.clks_per_bit(868)) UART1 (.rst(rst_samp),
                                  .clk(clk),
                                  .RX(RX),
                                  .TX(TX),
                                  .start_TX(start_TX),
                                  .tx_busy(tx_busy),
                                  .eoc_flag(eoc_flag),

                                  .tx_fifo_data_in(tx_fifo_data_in),
                                  .tx_fifo_full(tx_fifo_full),
                                  .tx_fifo_empty(tx_fifo_empty),
                                  .tx_wr_en(tx_wr_en),
                                  .tx_rd_en(tx_rd_en),

                                  .rx_fifo_full(rx_fifo_full),
                                  .rx_fifo_empty(rx_fifo_empty),
                                  .rx_wr_en(rx_wr_en),
                                  .rx_rd_en(1'b0),                             //RX FIFO is observed throuth Signaltap
                                  .rx_fifo_data_out(rx_fifo_data_out)
                                 );

//Loading data into the TX FIFO at 50MHz clock domain
always @(posedge clk or negedge rst_samp)
  if (!rst_samp) begin
    count_load_TX<=5'd0;
      tx_wr_en<=1'b0;
  end
  else
    if ((~tx_fifo_full)&&(count_load_TX<5'd16)) begin //If the TX FIFO is not full --> load it with new data if there it is available unless other condition exists (<16 in this case)
      tx_wr_en<=1'b1;
      tx_fifo_data_in<=count_load_TX;
      count_load_TX<=count_load_TX+5'd1;
    end 
    else
      tx_wr_en<=1'b0;

//Generating the start_TX signal and the rd_en for the TX FIFO : first a byte is read and in the following period the tranmission is initiated (start_TX goes high)
always @(posedge clk or negedge rst_samp)
  if (!rst_samp) begin
    tx_rd_en_tmp<=1'b0;
  end
  else
    if ((~tx_fifo_empty)&&(~tx_busy)) begin                  //If the TX is not busy and the TX FIFO memory is not empty --> start another byte transmission
      tx_rd_en_tmp<=1'b1;
    end
    else begin                                              //After one clock cycle the tx_busy signal goes to logic high
      tx_rd_en_tmp<=1'b0;
    end

always @(posedge clk or negedge rst_samp)
  if (!rst_samp) begin
    tx_rd_en_tmp_delayed<=1'b0;
    tx_rd_en<=1'b0;
    start_TX<=1'b0;
  end
  else begin
    tx_rd_en_tmp_delayed<=tx_rd_en_tmp;
    tx_rd_en<=~tx_rd_en_tmp_delayed&tx_rd_en_tmp;
    start_TX<=tx_rd_en;
  end

//RX FIFO signals
always @(posedge clk or negedge rst_samp)
  if (!rst_samp)
    eoc_flag_delayed<=1'b0;
  else begin
    eoc_flag_delayed<=eoc_flag;
    rx_wr_en<=(~eoc_flag_delayed)&(eoc_flag)&(~rx_fifo_full);    //Load recieved byte into the RX FIFO memory
  end
endmodule






