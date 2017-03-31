module control_fsm (
	input clk, reset_n,
	// Status inputs
	input br, brz, addi, subi, sr0, srh0, clr, mov, mova, movr, movrhs, pause,
	input delay_done,
	input temp_is_positive, temp_is_negative, temp_is_zero,
	input register0_is_zero,
	// Control signal outputs
	output reg write_reg_file,
	output reg result_mux_select,
	output reg [1:0] op1_mux_select, op2_mux_select,
	output reg start_delay_counter, enable_delay_counter,
	output reg commit_branch, increment_pc,
	output reg alu_add_sub, alu_set_low, alu_set_high,
	output reg load_temp_register, increment_temp_register, decrement_temp_register,
	output reg [1:0] select_immediate,
	output reg [1:0] select_write_address,
	output [4:0] _STATE
	);

	parameter RESET=5'd0, FETCH=5'd1, DECODE=5'd2,
			BR=5'd3, BRZ=5'd4, ADDI=5'd5, SUBI=5'd6, SR0=5'd7,
			SRH0=5'd8, CLR=5'd9, MOV=5'd10, MOVA=5'd11,
			MOVR=5'd12, MOVRHS=5'd13, PAUSE=5'd14, MOVR_STAGE2=5'd15,
			MOVR_DELAY=5'd16, MOVRHS_STAGE2=5'd17, MOVRHS_DELAY=5'd18,
			PAUSE_DELAY=5'd19;

	reg [5:0] state, next_state_logic;
	
	assign _STATE = state;
	
	always @ (posedge clk) begin
		if (!reset_n) begin
			state = RESET;
			next_state_logic <= RESET;
		end else begin
			case (state)
				RESET: begin
					// Reset PC and reset registers should happen automatically
					next_state_logic <= FETCH;
					increment_pc <= 0;
				end
				FETCH: begin
					// Fetching instruction should happen automatically
					next_state_logic <= DECODE;
					increment_pc <= 0;
				end
				DECODE: begin
					increment_pc <= 0;
					if (addi)
						next_state_logic <= ADDI;
					if (subi)
						next_state_logic <= SUBI;
					if (mov)
						next_state_logic <= MOV;
					if (sr0)
						next_state_logic <= SR0;
					if (srh0)
						next_state_logic <= SRH0;
					if (clr)
						next_state_logic <= CLR;
					if (br)
						next_state_logic <= BR;
					if (brz)
						next_state_logic <= BRZ;
					if (movr)
						next_state_logic <= MOVR;
					if (movrhs)
						next_state_logic <= MOVRHS;
					if (pause)
						next_state_logic <= PAUSE;
				end
				ADDI: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd1; // Write to first register
					select_immediate <= 2'd0; // 3-bit immediate value
					
					op1_mux_select <= 2'd1;
					op2_mux_select <= 2'd1;
					alu_add_sub <= 0; // Add
					alu_set_low <= 0;
					alu_set_high <= 0;
					
					result_mux_select <= 1; // Use ALU result
					
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				SUBI: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd1; // Write to first register
					select_immediate <= 2'd0; // 3-bit immediate value
					
					op1_mux_select <= 2'd1; 
					op2_mux_select <= 2'd1; // OP2 = immediate
					alu_add_sub <= 1; // Change ALU to subtract
					alu_set_low <= 0;
					alu_set_high <= 0;
					
					result_mux_select <= 1; // Use ALU result
					
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				MOV: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd2; // Writing to second register
					select_immediate <= 2'd3; // Zero out
					
					op1_mux_select <= 2'd1; // Selected 0
					op2_mux_select <= 2'd1; // Immediate (Which is zero)
					
					alu_add_sub <= 0; // Add
					alu_set_low <= 0;
					alu_set_high <= 0;
					
					result_mux_select <= 1; // Use ALU result
					
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				SR0: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd0; // Writing to R0
					select_immediate <= 2'd1; // 4-bit immediate
					
					op1_mux_select <= 2'd3; // Select R0 
					op2_mux_select <= 2'd1;
					
					alu_set_low <= 1;
					
					result_mux_select <= 1; // Use ALU result
				
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				SRH0: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd0; // Writing to R0
					select_immediate <= 2'd1; // 4-bit immediate
					
					op1_mux_select <= 2'd3; // Select R0 
					op2_mux_select <= 2'd1;
					
					alu_set_low <= 0;
					alu_set_high <= 1;
					
					result_mux_select <= 1; // Use ALU result
				
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				CLR: begin
					write_reg_file <= 1; // Write to register
					select_write_address <= 2'd1;
					
					result_mux_select <= 0; // Result is zero
				
					increment_pc <= 1;
					next_state_logic <= FETCH;
				end
				BR: begin
					op1_mux_select <= 2'd0; // Select PC
					op2_mux_select <= 2'd1; // Select immediate
					
					select_immediate <= 2'd2; // 5-bit immediate
					
					alu_add_sub <= 0; // Add
					alu_set_low <= 0;
					alu_set_high <= 0;
					
					increment_pc <= 0;
					next_state_logic <= FETCH;
				end
				BRZ: begin
					if (register0_is_zero) begin // Same as BR
						op1_mux_select <= 2'd0; // Select PC
						op2_mux_select <= 2'd1; // Select immediate
						
						select_immediate <= 2'd2; // 5-bit immediate
						
						alu_add_sub <= 0; // Add
						alu_set_low <= 0;
						alu_set_high <= 0;
						
						increment_pc <= 0;
					end else begin
						increment_pc <= 1;
					end
					next_state_logic <= FETCH;
				end
				MOVR: begin
					load_temp_register <= 1;
					increment_temp_register <= 0;
					decrement_temp_register <= 0;
					next_state_logic <= MOVR_STAGE2;
					increment_pc <= 0;
				end
				MOVR_STAGE2: begin
					if (temp_is_zero) begin
						increment_pc <= 1;
						next_state_logic <= FETCH;
					end else begin
						increment_pc <= 0;
						if (temp_is_positive) begin
							decrement_temp_register <= 1;
							
							write_reg_file <= 1; // Write to register
							
							op1_mux_select <= 2'd2; // Select R2
							op2_mux_select <= 2'd3; // Select '2'
							
							alu_add_sub <= 0; // Add
							alu_set_low <= 0;
							alu_set_high <= 0;
							
							result_mux_select <= 1; // Use ALU result
							select_write_address <= 2'd3; // Select R2						
						end else if (temp_is_negative) begin
							increment_temp_register <= 1;
							
							write_reg_file <= 1; // Write to register
							
							op1_mux_select <= 2'd2; // Select R2
							op2_mux_select <= 2'd3; // Select '2'
							
							alu_add_sub <= 1; // Subtract
							alu_set_low <= 0;
							alu_set_high <= 0;
							
							result_mux_select <= 1; // Use ALU result
							select_write_address <= 2'd3; // Select R2	
						end
						
						start_delay_counter <= 1;
						next_state_logic <= MOVR_DELAY;				
					end
				end
				MOVR_DELAY: begin
					increment_pc <= 0;
					if (delay_done) begin
						enable_delay_counter <= 1;
						next_state_logic <= MOVR_STAGE2; // Go back to MOVR_STAGE2 when done
					end else begin
						next_state_logic <= MOVR_DELAY; // Loop if delay is not done
					end
				end
				MOVRHS: begin
					load_temp_register <= 1;
					increment_temp_register <= 0;
					decrement_temp_register <= 0;
					next_state_logic <= MOVRHS_STAGE2;
					increment_pc <= 0;
				end
				MOVRHS_STAGE2: begin
					if (temp_is_zero) begin
						increment_pc <= 1;
						next_state_logic <= FETCH;
					end else begin
						increment_pc <= 0;
						if (temp_is_positive) begin
							decrement_temp_register <= 1;
							
							write_reg_file <= 1; // Write to register
							
							op1_mux_select <= 2'd2; // Select R2
							op2_mux_select <= 2'd2; // Select '1'
							
							alu_add_sub <= 0; // Add
							alu_set_low <= 0;
							alu_set_high <= 0;
							
							result_mux_select <= 1; // Use ALU result
							select_write_address <= 2'd3; // Select R2						
						end else if (temp_is_negative) begin
							increment_temp_register <= 1;
							
							write_reg_file <= 1; // Write to register
							
							op1_mux_select <= 2'd2; // Select R2
							op2_mux_select <= 2'd2; // Select '1'
							
							alu_add_sub <= 1; // Subtract
							alu_set_low <= 0;
							alu_set_high <= 0;
							
							result_mux_select <= 1; // Use ALU result
							select_write_address <= 2'd3; // Select R2	
						end
						
						start_delay_counter <= 1;
						next_state_logic <= MOVRHS_DELAY;				
					end
				end
				MOVRHS_DELAY: begin
					increment_pc <= 0;
					if (delay_done) begin
						enable_delay_counter <= 1;
						next_state_logic <= MOVRHS_STAGE2; // Go back to MOVR_STAGE2 when done
					end else begin
						next_state_logic <= MOVRHS_DELAY; // Loop if delay is not done
					end
				end
				PAUSE: begin
					increment_pc <= 0;
					start_delay_counter <= 1;
					next_state_logic <= PAUSE_DELAY;
				end
				PAUSE_DELAY: begin
					if (delay_done) begin
						enable_delay_counter <= 1;
						increment_pc <= 1;
						next_state_logic <= FETCH;
					end else begin
						increment_pc <= 0;
						next_state_logic <= PAUSE_DELAY; // Loop if delay is not done
					end
				end
			endcase
			
			state = next_state_logic;
		end
	end
endmodule
