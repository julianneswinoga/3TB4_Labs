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
	
	parameter N = 15;
	reg signed[15:0] coeffs[N-1:0];	
	reg [15:0] registers[N-1:0];
	wire [31:0] toAdd[N-1:0];
	
	always @ (*) begin
coeffs[0]=0;
coeffs[1]=-437;
coeffs[2]=0;
coeffs[3]=0;
coeffs[4]=0;
coeffs[5]=8626;
coeffs[6]=0;
coeffs[7]=16389;
coeffs[8]=0;
coeffs[9]=8626;
coeffs[10]=0;
coeffs[11]=0;
coeffs[12]=0;
coeffs[13]=-437;
coeffs[14]=0;
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
			output_sample = output_sample + (toAdd[j] >> 14);
		end
	end
endmodule

module echoMachine(
	input clock,
	input wire[15:0] input_sample,
	output reg [15:0] output_sample
	);
	
	wire[15:0] delayed_samp;
	reg[15:0] delay_samp;
	reg[15:0] attenuated;
	
	always @ (posedge clock) begin
		delay_samp <= output_sample;
		attenuated <= {{2{delayed_samp[15]}}, delayed_samp[15:2]};
		output_sample = input_sample + attenuated;
	end
	
	shiftregister shift(
	.clock(clock),
	.shiftin(delay_samp),
	.shiftout(delayed_samp)
	);	
endmodule
