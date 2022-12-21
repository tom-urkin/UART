# UART

> SystemVerilog UART implementation  

Implementention in SystemVerilog of __UART__.  
UART trasmitter (TX) and receiver (RX) modules operating in independent clock domains with parity bit for error-checking. Communication sequence as follows: 

		![UART communication sequence](./Simplified UART Module/docs/UART_sequence.JPG) 

Each sub-module is designed and tested as a standalone unit. A complete UART system is then implemented by instantiating the two sub-modules as well as the TX and RX FIFO memory modules.

**Note: 
A simplified model of a UART system can be found in the 'Simplified UART Module' folder used for educational purposes.
The complete UART module is located in the 'Full UART module' folder.**
## Get Started

The source files  are located in the following folders :

Simplified UART module files:
>RX module and TB
- [RX](./Simplified UART Module/RX/)
>TX module and TB
- [TX](./Simplified UART Module/TX/)
>Simplified UART module and TB
- [UART](./Simplified UART Module/UART/)

Complete UART module: 

## Simplified UART module

**UART RX**
The testbench includes a task that mimics the TX operation. In each iteration a 9-bit random number is generated (1-parity bit and 8-data bits). The Received data is compared with the sent data along with parity check. Please note that the parity bit is a random number.  
	
In the following example the sent data is in the bottom of the figure while the received data is in the buffer_RX row. The comparison and parity check are shown in the terminal. 

		![QuestaSim waveforms](./Simplified UART Module/docs/Simplified_UART_RX_TB_wave.JPG) 
		![QuestaSim terminal](./Simplified UART Module/docs/Simplified_UART_RX_TB_terminal.JPG) 


**UART RX**
The TB is rather simple: an 8-bit random number is generated in a loop and passed to the UART_TX. The correct bit stream is observed on the UART_line:
		![QuestaSim waveforms](./Simplified UART Module/docs/Simplified_UART_TX_TB_wave_1.JPG) 
A zoom-in:
		![QuestaSim waveforms](./Simplified UART Module/docs/Simplified_UART_TX_TB_wave_2.JPG) 

As can be seen, upon initiation a logic-low value is imposed followed by 8 bits (LSB first), a parity bit (which in this case is zero) and a stop bit (logic high).

Note: In this module there is no stop-bit (it is added in the complete UART module).


**UART (TX and RX)**
The complete UART system comprises an instantiation of the RX and TX module. Again, an 8-bit random number is generated and transmitted along with an additional parity bit. The communication line is shown in the bottom waveform (UART_line) – as can be seen it follows the UART protocol.
The Sent data is compared with the received along with parity check and printed to the terminal. As can be seen, the received data (buffer_RX) equals the sent data (data_rand).

		![QuestaSim waveforms](./Simplified UART Module/docs/Simplified_UART_TB_wave.JPG) 

An exemplary test result:

		![QuestaSim waveforms](./Simplified UART Module/docs/Simplified_UART_TB_terminal.JPG) 


## Complete UART module


### Possible Applications

Implementation of the synchronous FIFO memory in a complete UART module can be found in the [following repository]((./Synchronous_FIFO.sv))

## Support

I will be happy to answer any questions.  
Approach me here using GitHub Issues or at tom.urkin@gmail.com