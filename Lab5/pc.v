module pc(
	input clock, reset_n, branch, increment,
	input [7:0] newpc,
	output reg [7:0] pc
	);
	
	always @ (posedge clock) begin
		if (!reset_n)
			pc = 8'h00;
		else if (branch)
			pc = newpc;
		else if (increment)
			pc = pc + 1;
	end
endmodule