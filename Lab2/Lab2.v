module Lab2 (
	input CLOCK_50,
	input [2:0] KEY,
	output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
	);
	reg [31:0] hex_number;
	wire clk, counting;
	wire [3:0] d0, d1, d2, d3, d4, d5, d6, d7;
	
	clock_divider clk_divider(
		.Clock(CLOCK_50),
		.Reset(KEY[0]),
		.Pulse_ms(clk)
	);
	
	control_ff c_ff(
		.Clock(clk),
		.Set(KEY[1]),
		.Clear(KEY[2]),
		.Q(counting)
	);
	
	hex_counter h_counter(
		.Clock(clk),
		.Reset(KEY[0]),
		.Enable(counting),
		.Stp(~counting),
		.Q(hex_number)
	);
	
	hex_to_bcd_converter converter(
		.clk(clk),
		.reset(KEY[0]),
		.hex_number(hex_number),
		.bcd_digit_0(d0),
		.bcd_digit_1(d1),
		.bcd_digit_2(d2),
		.bcd_digit_3(d3),
		.bcd_digit_4(d4),
		.bcd_digit_5(d5),
		.bcd_digit_6(d6),
		.bcd_digit_7(d7)
	);
	
	seven_seg_decoder leds0(
		.x(d0),
		.hex_LEDs(HEX0)
	);
	
	seven_seg_decoder leds1(
		.x(d1),
		.hex_LEDs(HEX1)
	);
	
	seven_seg_decoder leds2(
		.x(d2),
		.hex_LEDs(HEX2)
	);
	
	seven_seg_decoder leds3(
		.x(d3),
		.hex_LEDs(HEX3)
	);
	
	seven_seg_decoder leds4(
		.x(d4),
		.hex_LEDs(HEX4)
	);
	
	seven_seg_decoder leds5(
		.x(d5),
		.hex_LEDs(HEX5)
	);
	
	seven_seg_decoder leds6(
		.x(d6),
		.hex_LEDs(HEX6)
	);
	
	seven_seg_decoder leds7(
		.x(d7),
		.hex_LEDs(HEX7)
	);
	
	always @(posedge clk) begin
		hex_number <= hex_number + 1;
	end
	
	

endmodule

module control_ff (
	input Clock, Set, Clear,
	output reg Q
	);
	
	always @ (posedge Clock) begin
		if(Clear) begin
			Q <= 0;
		end else if (Set) begin
			Q <= 1;
		end
	end
endmodule

module clock_divider (
	input Clock, Reset,
	output reg Pulse_ms
	);

	reg [31:0] count;
	
	always @(posedge Clock) begin
		if (Reset) begin
			Pulse_ms <= 0;
			count <= 0;
		end else begin
			if (count == 50000) begin
				Pulse_ms <= ~Pulse_ms;
				count <= 0;
			end else begin
				count <= count + 1;
			end
		end
	end
endmodule

module hex_counter (
	input Clock, Reset, Enable, Stp,
	output reg [31:0]Q
	);
	
	always @(posedge Clock)
		if (Reset) begin
			Q <= 0;
		end else if (Stp) begin
		end else if (Enable) begin
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
      shift[63:32] = 0;
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
	output [6:0] hex_LEDs
	);
	
	reg [6:2] top_5_segments;

	assign hex_LEDs[0] = ~(x[0])&~(x[1])&(x[2]) | (x[1])&~(x[2])&(x[3]) | (x[1])&(x[2])&~(x[3]);
	assign hex_LEDs[1] = ~(x[0])&~(x[1])&(x[2]) | (x[1])&~(x[2])&~(x[3]) | (x[0])&(x[2])&~(x[3]);
	
	always @(*) begin
		case (x)
			4'd0 : top_5_segments = 7'b00001;
			4'd1 : top_5_segments = 7'b11111;
			4'd2 : top_5_segments = 7'b01101;
			4'd3 : top_5_segments = 7'b11001;
			4'd4 : top_5_segments = 7'b10011;
			4'd5 : top_5_segments = 7'b11011;
			4'd6 : top_5_segments = 7'b11111;
			4'd7 : top_5_segments = 7'b01111;
			4'd8 : top_5_segments = 7'b00000;
			4'd9 : top_5_segments = 7'b00100;
			4'd10 : top_5_segments = 7'b10001;
			4'd11 : top_5_segments = 7'b01000;
			4'd12 : top_5_segments = 7'b01011;
			4'd13 : top_5_segments = 7'b01111;
			4'd14 : top_5_segments = 7'b11010;
			4'd15 : top_5_segments = 7'b00001;
		endcase
	end
	
	assign hex_LEDs[2] = top_5_segments[2];
	assign hex_LEDs[3] = top_5_segments[3];
	assign hex_LEDs[4] = top_5_segments[4];
	assign hex_LEDs[5] = top_5_segments[5];
	assign hex_LEDs[6] = top_5_segments[6];
	
endmodule
