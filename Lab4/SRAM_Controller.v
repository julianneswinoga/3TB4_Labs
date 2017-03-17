module SRAM_Controller (
	input clk, reset_n, chipselect, read, write,
	input [17:0] address,
	input [1:0]	byte_enable,
	input [15:0] write_data,
	inout reg [15:0] SRAM_DQ,
	output reg [15:0] read_data,
	output [17:0] SRAM_ADDR,
	output SRAM_CE_N, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N,SRAM_LB_N			
	);

	assign SRAM_ADDR = address;
	assign SRAM_UB_N = ~byte_enable[0];
	assign SRAM_LB_N = ~byte_enable[1];
	assign SRAM_CE_N = ~chipselect;
	assign SRAM_OE_N = ~read;
	assign SRAM_WE_N = ~write;
	
	always @ (posedge clk) begin
		if (chipselect) begin
			if (read)
				read_data <= SRAM_DQ;
			if (write)
				SRAM_DQ <= write_data;
		end
	end

endmodule

