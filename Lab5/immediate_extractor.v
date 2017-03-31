module immediate_extractor (
	input [7:0] instruction,
	input [1:0] select,
	output reg [7:0] immediate
	);

	always @ (*) begin
		case (select)
			0: immediate = {5'b0, instruction[4:2]}; // 3­bit immediate operand
			1: immediate = {4'b0, instruction[3:0]}; // 4­bit immediate operand
			2: immediate = {{3{instruction[4]}}, instruction[4:0]}; // 5­bit immediate operan, sign padding
			3: immediate = 7'b0; // MOV instruction
		endcase
	end

endmodule
