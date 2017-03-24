module op2_mux (
	input [1:0] select,
	input [7:0] register, immediate,
	output reg [7:0] result
	);
				
	always @(*) begin
		case (select)
			0: result = register;
			1: result = immediate;
			2: result = 7'd1;
			3: result = 7'd2;
		endcase
	end

endmodule
