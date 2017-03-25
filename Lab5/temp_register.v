module temp_register (
	input clk, reset_n, load, increment, decrement,
	input [7:0] data,
	output reg negative, positive, zero
	);

	reg [7:0] internal_register;
	
	always @ (posedge clk) begin
		if (load)
			internal_register = data;
		if (increment)
			internal_register = internal_register + 1;
		if (decrement)
			internal_register = internal_register - 1;
		zero = (internal_register == 7'b0);
		positive = (internal_register[7] == 0);
		negative = (internal_register[7] == 1);
	end

endmodule
