module Lab2 (
	input CLOCK_50,
	input [3:0] KEY,
	output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
	);
	reg [31:0] hex_number;
	wire [31:0] numbah;
	wire clk, counting;
	wire [3:0] d0, d1, d2, d3, d4, d5, d6, d7;
	
	clock_divider clk_divider(
		.Clock(CLOCK_50),
		.Reset(~KEY[0]),
		.Pulse_ms(clk)
	);
	
	control_ff c_ff(
		//.Clock(clk),
		.Set(~KEY[1]),
		.Clear(~KEY[2]),
		.Q(counting)
	);
	
	hex_counter h_counter(
		.Clock(clk),
		.Reset(~KEY[0]),
		.Enable(counting),
		.Stp(~counting),
		.Q(numbah)
	);
	
	always @(posedge clk) begin
		hex_number <= numbah;
	end
	
	hex_to_bcd_converter converter(
		.clk(clk),
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

endmodule

/*module control_ff (
	input Clock, Set, Clear,
	output reg Q
	);
	
	wire QQ;
	
	assign QQ = Q;
	always @ (posedge Clock or posedge Set or posedge Clear) begin
		if(Clear & QQ) begin
			Q <= 0;
		end else if (Set & ~QQ) begin
			Q <= 1;
		end
	end
endmodule*/

module control_ff (
	input Set, Clear,
	output Q
	);
	
	wire Qbar;
	nor (Q, Clear, Qbar);
	nor (Qbar, Set, Q);
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
	
	always @(posedge Clock or posedge Reset) begin
		if (Reset) begin
			Q <= 0;
		end else if (Stp) begin
		end else if (Enable) begin
			Q <= Q + 1;
		end
	end
endmodule

module hex_to_bcd_converter(
	input wire clk,
	input [31:0] hex_number,
	output reg [3:0] bcd_digit_0,bcd_digit_1,bcd_digit_2,bcd_digit_3,bcd_digit_4,bcd_digit_5, bcd_digit_6, bcd_digit_7
	);
	
   // Internal variable for storing bits
   reg [63:0] shift;
   integer i;
   
   always @(*) begin
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
	output reg [6:0] hex_LEDs
	);
	
	always @(*) begin
		case (x)
			4'd0 : hex_LEDs = 7'b1000000;
			4'd1 : hex_LEDs = 7'b1111001;
			4'd2 : hex_LEDs = 7'b0100100;
			4'd3 : hex_LEDs = 7'b0110000;
			4'd4 : hex_LEDs = 7'b0011001;
			4'd5 : hex_LEDs = 7'b0010010;
			4'd6 : hex_LEDs = 7'b0000010;
			4'd7 : hex_LEDs = 7'b1111000;
			4'd8 : hex_LEDs = 7'b0000000;
			4'd9 : hex_LEDs = 7'b0010000;
			4'd10 : hex_LEDs = 7'b0001000;
			4'd11 : hex_LEDs = 7'b0000011;
			4'd12 : hex_LEDs = 7'b1000110;
			4'd13 : hex_LEDs = 7'b0100001;
			4'd14 : hex_LEDs = 7'b0000110;
			4'd15 : hex_LEDs = 7'b0001110;
		endcase
	end
	
endmodule
