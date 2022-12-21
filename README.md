# UART

> SystemVerilog UART implementation  

Implementention in SystemVerilog of __UART__.  
UART trasmitter (TX) and receiver (RX) modules operating in independent clock domains with parity bit for error-checking. Communication sequence as follows: 

		![UART communication sequence](./docs/UART_sequence.JPG) 

Each sub-module is designed and tested as a standalone unit. A complete UART system is then implemented by instantiating the two sub-modules as well as the TX and RX FIFO memory modules.

**Note: 
A simplified model of a UART system can be found in the 'Simplified UART Module' folder used for educational purposes.
The complete UART module is located in the 'Full UART module' folder.**
## Get Started

The source files  are located at the :
Simplified UART module files:
>RX module and TB
- [RX](./Simplified UART Module/RX)
>TX module and TB
- [TX](./Simplified UART Module/TX)
>Simplified UART module and TB
- [UART](./Simplified UART Module/UART)

Complete UART module: 
- [Synchronous_FIFO](./Synchronous_FIFO.sv)

## Testbench

The testbench comprises three tests for a 32 8-bit word FIFO memory:
1.	Writing random data to the FIFO memory until it is full  

	a.	Verify correctness of written data  
	b.	Verify correctness of the FIFO memory full signal

	**QuestaSim terminal window:**
		![QuestaSim terminal window](./docs/Write_test.JPG) 

	**QuestaSim wave window:**
		![QuestaSim wave window](./docs/Write_test_wave.JPG)  
	
	
2.	Reading from the FIFO memory until it is empty  

	a.	Verify correctness of the read data  
	b.	Verify correctness of the FIFO memory empty signal
	
	**QuestaSim terminal window:**
		![QuestaSim terminal window](./docs/Read_test.JPG) 

	**QuestaSim wave window:**
		![QuestaSim wave window](./docs/Read_test_wave.JPG)  
	
3.	Continuous read-write operation with same frequency 

	**QuestaSim terminal window:**
		![QuestaSim terminal window](./docs/continious_test.JPG) 

	**QuestaSim wave window:**
		![QuestaSim wave window](./docs/continious_test_wave.JPG)  
	



### Possible Applications

Implementation of the synchronous FIFO memory in a complete UART module can be found in the [following repository]((./Synchronous_FIFO.sv))

## Support

I will be happy to answer any questions.  
Approach me here using GitHub Issues or at tom.urkin@gmail.com