module dsp_subsystem (
	input sample_clock, reset,
	input [1:0] selector,
	input [15:0] input_sample,
	output [15:0] output_sample
	);
	
	wire [15:0] filter_output, echo_output, straight_output;
	
	mux3to1 mux(
		.select(selector),
		.input1(filter_output),
		.input2(echo_output),
		.input3(straight_output),
		.out(output_sample)
		);
	
	assign straight_output = input_sample;
	
	FIRfilter fir(
		.clock(sample_clock),
		.input_sample(input_sample),
		.output_sample(filter_output)
		);
		
	echoMachine echo(
		.clock(sample_clock),
		.input_sample(input_sample),
		.output_sample(echo_output)
		);
endmodule

module mux3to1(
	input [1:0] select,
	input [15:0] input1, input2, input3,
	output reg [15:0] out
	);
	
	always @(*) begin
		case (select) 
			0: out = input1;
			1: out = input2;
			2: out = input3;
			3: out = input3;
		endcase
	end
endmodule

module FIRfilter(
	input clock,
	input wire[15:0] input_sample,
	output reg[15:0] output_sample
	);
	
	parameter N = 14;
	parameter scalar = 1024;
	reg signed[15:0] coeffs[N-1:0];	
	reg [15:0] registers[N-1:0];
	wire [15:0] toAdd[N-1:0];
	
	always @ (*) begin
		coeffs[0]=2;
		coeffs[1]=-3816;
		coeffs[2]=10;
		coeffs[3]=-22894;
		coeffs[4]=25;
		coeffs[5]=-57235;
		coeffs[6]=33;
		coeffs[7]=-76313;
		coeffs[8]=25;
		coeffs[9]=-57235;
		coeffs[10]=10;
		coeffs[11]=-22894;
		coeffs[12]=2;
		coeffs[13]=-3816;
	end
	
	genvar i;
	generate
		for (i = 0;i < N;i = i + 1) begin: mult
			multiplier mult1(
				.dataa(coeffs[i]),
				.datab(registers[i]),
				.result(toAdd[i])
				);
		end
	endgenerate
	
	integer j;
	always @ (posedge clock) begin
		output_sample = input_sample;
		for (j = 0; j < N; j = j + 1) begin
         if (j + 1 < N)
            registers[j] <= registers[j + 1];
         else
            registers[j] <= input_sample;
			output_sample = output_sample + toAdd[j];
		end
	end
endmodule

module echoMachine(
	input clock,
	input wire[15:0] input_sample,
	output reg[15:0] output_sample
	);
	
	wire[15:0] delay;
	
	shiftregister shift(
	.clock(clock),
	.shiftin(output_sample),
	.shiftout(delay)
	);
	
	always @ (posedge clock) begin
		output_sample = input_sample + ($signed(delay) >> 2);
	end
endmodule
