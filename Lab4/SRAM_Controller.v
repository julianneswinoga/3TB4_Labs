module SRAM_Controller (
	input clk, reset_n, chipselect, read, write,
	input	[17:0] address,
	input	[1:0]	byte_enable,
	input	[15:0] write_data,
	inout	[15:0] SRAM_DQ,
	output [15:0] read_data,
	output [17:0] SRAM_ADDR,
	output SRAM_CE_N, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N,SRAM_LB_N			
	);


endmodule

