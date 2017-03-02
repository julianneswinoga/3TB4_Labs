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
	
	parameter N = 21;
	reg signed[15:0] coeffs[N-1:0];	
	reg [15:0] registers[N-1:0];
	wire [31:0] toAdd[N-1:0];
	
	always @ (*) begin
coeffs[0]=-118;
coeffs[1]=0;
coeffs[2]=418;
coeffs[3]=0;
coeffs[4]=-217;
coeffs[5]=0;
coeffs[6]=-2888;
coeffs[7]=0;
coeffs[8]=8505;
coeffs[9]=0;
coeffs[10]=21369;
coeffs[11]=0;
coeffs[12]=8505;
coeffs[13]=0;
coeffs[14]=-2888;
coeffs[15]=0;
coeffs[16]=-217;
coeffs[17]=0;
coeffs[18]=418;
coeffs[19]=0;
coeffs[20]=-118;
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
		for (j = N - 1; j > 0; j = j - 1) begin
           registers[j] = registers[j - 1];
		end
      registers[0] = input_sample;
		
		output_sample = 0;
		for (j = 0; j < N; j = j + 1) begin
			output_sample = output_sample + (toAdd[j] >> 15);
		end
	end
endmodule

module echoMachine(
	input clock,
	input wire[15:0] input_sample,
	output [15:0] output_sample
	);
	
	wire[15:0] delay;
	
	assign output_sample = input_sample + ($signed(delay) >> 5);
	
	shiftregister shift(
	.clock(clock),
	.shiftin(output_sample),
	.shiftout(delay)
	);	
endmodule
