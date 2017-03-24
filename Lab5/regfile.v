module regfile(
	input clock, reset_n, write,
	input [7:0] data,
	input [1:0] select0, select1, wr_select,
	output reg [7:0] selected0, selected1, register0, position/*R2*/, delay/*R3*/
	);
	
	reg [7:0] registers[3:0];
	
	always @ (posedge clock) begin
		if (!reset_n) begin
			registers[0] = 7'b0;
			registers[1] = 7'b0;
			registers[2] = 7'b0;
		end else if (write) begin
			registers[wr_select] = data;
		end
		selected0 <= registers[select0];
		selected1 <= registers[select1];
		register0 <= registers[0];
		position <= registers[2];
		delay <= registers[3];
	end
endmodule