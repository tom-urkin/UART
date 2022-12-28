//Synchronous FIFO memory

module Synchronous_FIFO(clk,rst,data_in,FIFO_empty,FIFO_full,data_out,wr_en,rd_en);

//Parameters
parameter DATA_WIDTH = 8;                                     //Word width - 8-bit word in deafualt settings
parameter ADDR_WIDTH = 5;                                     //FIFO memory depth - 32 words in default settings

//Inputs
input logic clk;                                              //FIFO memory inout clock
input logic rst;                                              //Active high logic
input logic [(DATA_WIDTH-1):0] data_in;                       //input data with DATA_WIDTH length
input logic wr_en;                                            //Write request from external logic - writing to FIFO memory when logic high for one cycle
input logic rd_en;                                            //Read request from external logic - reading from FIFO memory when logic high for one cycle
//Outputs
output logic FIFO_empty;                                      //Logic high when the FIFO memory is empty - do not read from memory
output logic FIFO_full;                                       //Logic high when the FIFO memory is full - do not write to memory
output logic [(DATA_WIDTH-1):0] data_out;                     //FIFO memory output

//Internal signals
logic [ADDR_WIDTH:0] rptr;                                   //Read pointer
logic [ADDR_WIDTH:0] wptr;                                   //Write pointer
logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH-1):0];            //FIFO memory registers (32 8-bit words in defaults settings)


integer i;                                                   //Used for reseting the FIFO memory

//HDL code


always @(posedge clk or negedge rst)
    if (!rst)                                                //Reseting the FIFO memory
        begin
            for (i=0; i<(2**ADDR_WIDTH); i=i+1)
                mem[i]='d0;
                wptr<=0;
        end
    else
        if ((~FIFO_full)&&(wr_en))                            //Write operation
        begin
            mem[wptr[ADDR_WIDTH-1:0]]<=data_in;
            wptr<=wptr+1;
        end

always @(posedge clk or negedge rst)
    if (!rst)
        begin
            rptr<=0;
            data_out<='d0;
        end
    else
        if ((~FIFO_empty)&&rd_en)                            //Read operation
            begin
                data_out<=mem[rptr[ADDR_WIDTH-1:0]];
                rptr<=rptr+1;
            end

assign FIFO_empty = (wptr==rptr) ? 1'b1 : 1'b0;                                       //If the pointers are equal there is no new data to be read
assign FIFO_full = ({~wptr[ADDR_WIDTH],wptr[ADDR_WIDTH-1:0]}==rptr) ? 1'b1 : 1'b0;    //If the (ADDR_WIDTH-1) LSB bits are equal and the MSB is with reversed polarity, the FIFO memory is full


endmodule
