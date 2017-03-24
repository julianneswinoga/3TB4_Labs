module op1_mux (
	input [1:0] select,
	input [7:0] pc, register, register0, position,
	output reg [7:0] result
	);

	always @(*) begin
		case (select)
			0: result = pc;
			1: result = register;
			2: result = position;
			3: result = register0;
		endcase
	end
				
endmodule
