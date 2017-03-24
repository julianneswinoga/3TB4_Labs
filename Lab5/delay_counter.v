module delay_counter (
	input clk, start, enable,
	input [7:0] delay,
	output reg done
	);
	
	parameter CLK_HZ = 500000;
	parameter DELAY_HZ = 100;
	
	reg [7:0] delay_register, ms_counter;
	
	always @ (posedge clk) begin
		if (start)
			delay_register <= delay;
			ms_counter <= 0;
		if (enable) begin
			if (delay_register == 7'b0)
				done <= 1;
			else
				done <= 0;
			if (ms_counter == 7'b0) begin
				ms_counter <= CLK_HZ / DELAY_HZ;
				delay_register <= delay_register - 1;
			end else
				ms_counter <= ms_counter - 1;
		end
	end

endmodule
