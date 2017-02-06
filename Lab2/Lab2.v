module Lab2 (
	input CLOCK_50,
	input [2:0] KEY,
	output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
	);

endmodule

module control_ff (
	input Clock, ff_in, Set, Clear,
	output reg Q
	);

	always @ (posedge Clock & Set)
		if(Clear) begin
			Q <= 1;
		end
		else if (ff_in) begin
			Q <= ~Q;
		end
endmodule

module clock_divider (
	input Clock, Reset,
	output reg Pulse_ms
	);

	always @(posedge Clock)
		if (Reset)
			  Pulse_ms <= 0;
		else
			Pulse_ms <= ~Pulse_ms;
endmodule

module hex_counter (
	input Clock, Reset, Enable, Stp,
	output reg [31:0]Q
	);
	
	always @(posedge Clock)
		if (Reset) begin
			Q <= 0;
		end 
		else if (Stp)begin end
		else if (Enable) begin
			Q <= Q + 1;
		end
endmodule

module hex_to_bcd_converter(
	input wire clk, Reset,
	input [31:0] hex_number,
	output reg [3:0] bcd_digit_0,bcd_digit_1,bcd_digit_2,bcd_digit_3,bcd_digit_4,bcd_digit_5, bcd_digit_6, bcd_digit_7
	);
	
   // Internal variable for storing bits
   reg [63:0] shift;
   integer i;
   
   always @(posedge clk) begin
      // Clear previous number and store new number in shift register
      if (Reset == 1'b1) begin
			shift[63:32] = 0;
		end
		shift[31:0] = hex_number;
      // Loop 32 times
      for (i = 0; i < 32; i = i + 1) begin         
			if (shift[35:32] >= 5)
            shift[35:32] = shift[35:32] + 3;
			if (shift[39:36] >= 5)
            shift[39:36] = shift[39:36] + 3;
			if (shift[43:40] >= 5)
            shift[43:40] = shift[43:40] + 3;
			if (shift[47:44] >= 5)
            shift[47:44] = shift[47:44] + 3;
			if (shift[51:48] >= 5)
            shift[51:48] = shift[51:48] + 3;
			if (shift[55:52] >= 5)
            shift[55:52] = shift[55:52] + 3;
			if (shift[59:56] >= 5)
            shift[59:56] = shift[59:56] + 3;
         if (shift[63:60] >= 5)
            shift[63:60] = shift[63:60] + 3;
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
		bcd_digit_7 = shift[63:60];
		bcd_digit_6 = shift[59:56];
		bcd_digit_5 = shift[55:52];
		bcd_digit_4 = shift[51:48];
		bcd_digit_3 = shift[47:44];
		bcd_digit_2 = shift[43:40];
		bcd_digit_1 = shift[39:36];
		bcd_digit_0 = shift[35:32];
   end
endmodule

module seven_seg_decoder (
	input [3:0] x,
	output[6:0] hex_LEDs
	);
	
	reg [6:2] top_5_segments;

	assign hex_LEDs[0] = 1'b1/* Insert expression for segment 0 here */;
	assign hex_LEDs[1] = 1'b1/* Insert expression for segment 1 here */;

	/*always at (*) begin
	if (1)
		hex_LEDs[2] = 0;
	else
		hex_LEDs[3] = 1;
	end*/
endmodule
