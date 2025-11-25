# T01 Ternary ALU (VHDL)

A VHDL implementation of a ternary Arithmetic Logic Unit (ALU) based on the **T01 balanced-ternary number system**.  
The project provides modular components for ternary encoding, decoding, arithmetic operations and basic logic functions, enabling experimentation with non-binary computing architectures.

## Features (not all yet fully implemented)
- Balanced-ternary (**T01**) number representation  
- Ternary encoders and decoders  
- Arithmetic operations: addition, subtraction, increment/decrement  
- Basic ternary logic operations  
- Modular and synthesizable VHDL design  
- Suitable for FPGA exploration or research in ternary computing


## Requirements
- VHDL-2008 compatible toolchain  
- Simulator such as GHDL

## Usage
1. Add the source file folder to your VHDL project.  
2. Compile using your preferred simulator or FPGA toolchain.  
3. Run the testbench using the provided bash script to verify operation.  

## T01 Balanced Ternary
The T01 system represents each trit as:
- **T (–1)**
- **0**
- **1**

This encoding simplifies arithmetic and supports compact ternary logic circuits.

## License
Provided for experimental research purposes only. You use it on your own risk :-).
