module write_address_select (
	input [1:0] select, reg_field0, reg_field1,
	output reg [1:0] write_address
	);

	always @(*) begin
		case (select)
			0: write_address = 2'b0;
			1: write_address = reg_field0;
			2: write_address = reg_field1;
			3: write_address = 2'b0;
		endcase
	end

endmodule
