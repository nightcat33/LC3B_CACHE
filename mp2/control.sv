import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* Input and output port declarations */
	output logic m_cyc,
	output logic m_stb,
	input clk,
	/* Datapath controls */
	input lc3b_opcode opcode,
	output logic load_pc,
	output logic load_ir,
	output logic load_regfile,
	output lc3b_aluop aluop,
	
	input mem_resp,
	//output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable,
	
	input logic branch_enable,
	output logic load_mdr,
	output logic load_mar,
	output logic load_cc,
	
	output logic [2:0] pcmux_sel,
	output logic storemux_sel,
	output logic [2:0] alumux_sel,
	output logic [2:0] regfilemux_sel,
	output logic [2:0] marmux_sel,
	output logic mdrmux_sel,
	
	input immCheck,
	output logic r7_sel,
	input jsrCheck,
	input lc3b_word mem_address,
	input shf_a,
	input shf_d
	
);

enum int unsigned {
    /* List of states */
	fetch1,
	fetch2,
	fetch3,
	decode,
	s_add,
	s_and,
	s_not,
	ldr1,
	ldr2,
	str1,
	str2,
	br,
	br_taken,
	calc_addr,
	s_jmp,
	s_lea,
	jsr,
	save_r7,
	s_ldb1,
	s_ldb2,
	s_ldb3,
	s_ldi1,
	s_ldi2,
	s_ldi3,
	s_ldi4,
	s_ldi5,
	s_stb1,
	s_stb2,
	s_stb3,
	sti1,
	sti2,
	sti3,
	sti4,
	sti5,
	shf,
	trap1,
	trap2,
	trap3,
	trap4
		 	 
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    /* Actions for each state */
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	
	aluop = alu_add;
	//mem_read = 1'b0;
	mem_write = 1'b0;
	m_cyc = 0;
	m_stb = 0;
	
	load_mar = 1'b0;
	load_mdr = 1'b0;
	load_cc = 1'b0;
	
	pcmux_sel = 3'b000;
	storemux_sel = 1'b0;
	alumux_sel = 3'b000;
	regfilemux_sel = 3'b000;
	marmux_sel = 3'b000;
	mdrmux_sel = 1'b0;
	
	mem_byte_enable = 2'b11;
	r7_sel = 1'b0;

	
	case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 1;
			load_mar = 1;
			/* PC <= PC + 2 */
			pcmux_sel = 0;
			load_pc = 1;
			
		end
		
		fetch2: begin
			/* Read memory */
			//mem_read = 1;
			m_cyc = 1;
			m_stb = 1;
			mdrmux_sel = 1;
			load_mdr = 1;
		end
		
		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end
		
		decode: /* Do nothing */;
		s_add: begin
			/* DR <= SRA + SRB */
			aluop = alu_add;
			load_regfile = 1;
			regfilemux_sel = 0;
			load_cc = 1;
			
			if (immCheck == 1)
				alumux_sel = 3'b010;
		end
		
		s_and: begin
			/* DR <= SRA & SRB */
			aluop = alu_and;
			load_regfile = 1;
			regfilemux_sel = 0;
			load_cc = 1;
			
			if (immCheck == 1)
				alumux_sel = 3'b010;
		end
		
		shf: begin
			load_regfile = 1;
			load_cc = 1;
			regfilemux_sel = 3'b000;
			alumux_sel = 3'b011;
			if (shf_d == 0)
				aluop = alu_sll;
			else
				if (shf_a == 0)
					aluop = alu_srl;
				else
					aluop = alu_sra;	
		end
		
		s_not: begin
			aluop = alu_not;
			load_regfile = 1;
			regfilemux_sel = 0;
			load_cc = 1;
		end
		
		s_jmp: begin
			pcmux_sel = 3'b010;
			load_pc = 1;
		end
		
		s_stb1: begin
			marmux_sel = 3'b100;
			load_mar = 1;
		end
		
		s_stb2: begin
			storemux_sel = 1;
			aluop = alu_pass;
			mdrmux_sel = 0;
			load_mdr = 1;
		end
		
		s_stb3: begin
			if (mem_address[0] == 0)
			begin
				mem_byte_enable = 2'b01;
			end
			else
			begin
				mem_byte_enable = 2'b10;
			end
			mem_write = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		s_lea: begin
			regfilemux_sel = 3'b010;
			load_regfile = 1;
			load_cc = 1;
		end
		
		trap1: begin
			r7_sel = 1;
			load_regfile = 1;
			regfilemux_sel = 3'b011;
		end
		
		trap2: begin
			marmux_sel = 3'b011;
			load_mar = 1;
		end
		
		trap3: begin
			load_mdr = 1;
			mdrmux_sel = 1;
			//mem_read = 1;
			m_cyc = 1;
			m_stb = 1;
		end
		
		trap4: begin
			load_pc = 1;
			pcmux_sel = 3'b011;
		end
		
		save_r7: begin
			r7_sel = 1;
			load_regfile = 1;
			regfilemux_sel = 3'b011;
		end
		
		jsr: begin
			if (jsrCheck == 1)
			begin
				load_pc = 1;
				pcmux_sel = 3'b100;
			end
			else
			begin
				pcmux_sel = 3'b010;
				load_pc = 1;
			end
		end
				
		s_ldb1: begin
			load_mar = 1;
			marmux_sel = 3'b100;
		end
		
		s_ldb2: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			// mem_byte_enable = 2'b01;
			//mem_read = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		s_ldb3: begin
			regfilemux_sel = 3'b100;
			load_regfile = 1;
			load_cc = 1;
		end
		
		sti1: begin
			marmux_sel = 0;
			alumux_sel = 3'b001;
			load_mar = 1;
			aluop = alu_add;
		end
		
		sti2: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			//mem_read = 1;	
			m_stb = 1;
			m_cyc = 1;
		end
		
		sti3: begin
			marmux_sel = 3'b010;
			load_mar = 1;
		end
		
		sti4: begin
			storemux_sel = 1;
			aluop = alu_pass;
			mdrmux_sel = 0;
			load_mdr = 1;
		end
		
		sti5: begin
			mem_write = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		s_ldi1: begin
			marmux_sel = 0;
			alumux_sel = 3'b001;
			load_mar = 1;
			aluop = alu_add; 
		end
		
		s_ldi2: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			//mem_read = 1;
			m_stb = 1;
			m_cyc = 1;
			
		end
		
		s_ldi3: begin
			marmux_sel = 3'b010;
			load_mar = 1;
		end
			
		s_ldi4: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			//mem_read = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		s_ldi5: begin
			regfilemux_sel = 1;
			load_regfile = 1;
			load_cc = 1;
		end
			
		br: begin
			/* Do nothing */
		end
		
		br_taken: begin
			pcmux_sel = 1;
			load_pc = 1;
		end
		
		calc_addr: begin
			alumux_sel = 1;
			load_mar = 1;
			aluop = alu_add;
		end
		
		ldr1: begin
			mdrmux_sel = 1;
			load_mdr = 1;
			//mem_read = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		ldr2: begin
			regfilemux_sel = 1;
			load_regfile = 1;
			load_cc = 1;
		end
		
		str1: begin
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end
		
		str2: begin
			mem_write = 1;
			m_stb = 1;
			m_cyc = 1;
		end
		
		default: /* Do nothing */;
	endcase
	
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	next_state = state;
	
	case(state)
	
		fetch1: begin
			next_state = fetch2;
		end
		
		fetch2: begin
			if(mem_resp === 0)
				next_state = fetch2;
			else
				next_state = fetch3;
		end
		
		fetch3: begin
			next_state = decode;
		end
		
		decode: begin
		
			case(opcode)
				op_add: begin
					next_state = s_add;
				end
				
				op_and: begin
					next_state = s_and;
				end
			
				op_not: begin
					next_state = s_not;
				end
				
				op_ldr: begin
     				next_state = calc_addr;
				end
			
				op_str: begin
					next_state = calc_addr;
				end
				
				op_br: begin
     				next_state = br;
				end
				
				op_jmp: begin
					next_state = s_jmp;
				end
				
				op_lea: begin
					next_state = s_lea;
				end
				
				op_jsr: begin
					next_state = save_r7;
				end
				
				op_ldb: begin
					next_state = s_ldb1;
				end
				
				op_ldi: begin
					next_state = s_ldi1;
				end
				
				op_stb: begin
					next_state = s_stb1;
				end
				
				op_sti: begin
					next_state = sti1;
				end
				
				op_shf: begin
					next_state = shf;
				end
				
				op_trap: begin
					next_state = trap1;
				end
				
				
				default:;
				
			endcase
			
		end
		
		trap1: begin
			next_state = trap2;
		end
		
		trap2: begin
			next_state = trap3;
		end
		
		trap3: begin
			if(mem_resp === 0)
				next_state = trap3;
			else
				next_state = trap4;
		end
		
		trap4: begin
			next_state = fetch1;
		end
		
		shf: begin
			next_state = fetch1;
		end
		
		sti1: begin
			next_state = sti2;
		end
		
		sti2: begin
			if(mem_resp === 0)
				next_state = sti2;
			else
				next_state = sti3;
		end
		
		sti3: begin
			next_state = sti4;
		end
		
		sti4: begin
			next_state = sti5;
		end
		
		sti5: begin
			if(mem_resp === 0)
				next_state = sti5;
			else
				next_state = fetch1;
		end
		
		s_stb1: begin
			next_state = s_stb2;
		end
		
		s_stb2: begin
			next_state = s_stb3;
		end
		
		s_stb3: begin
			if(mem_resp === 0)
				next_state = s_stb3;
			else
				next_state = fetch1;
		end
		
		s_ldi1: begin
			next_state = s_ldi2;
		end
		
		s_ldi2: begin
			if(mem_resp === 0)
				next_state = s_ldi2;
			else
				next_state = s_ldi3;
		end
		
		s_ldi3: begin
			next_state = s_ldi4;
		end
		
		s_ldi4: begin
			if(mem_resp === 0)
				next_state = s_ldi4;
			else
				next_state = s_ldi5;
		end
		
		s_ldi5: begin
			next_state = fetch1;
		end
		
		s_ldb1: begin
			next_state = s_ldb2;
		end
		
		s_ldb2: begin
			if(mem_resp === 0)
				next_state = s_ldb2;
			else
				next_state = s_ldb3;
		end
		
		s_ldb3: begin
			next_state = fetch1;
		end
	
		s_add: begin
			next_state = fetch1;
     	end

     	s_and: begin
     		next_state = fetch1;
     	end

     	s_not: begin
     		next_state = fetch1;
		end
		
		s_jmp: begin
			next_state = fetch1;
		end
		
		s_lea: begin
			next_state = fetch1;
		end
		
		calc_addr: begin 
		
			case(opcode)
			
				op_ldr: begin
     				next_state = ldr1;
				end
			
				op_str: begin
					next_state = str1;
				end
			
				default:;
				
			endcase
			
		end
		
		ldr1: begin
     		if(mem_resp === 0)
     			next_state = ldr1;
     		else
     			next_state = ldr2;
     	end

     	ldr2: begin
     		next_state = fetch1;
     	end

     	str1: begin
     		next_state = str2;
     	end

     	str2: begin
     		if(mem_resp === 0)
     			next_state = str2;
     		else
     			next_state = fetch1;
		end
		
		save_r7: begin
			next_state = jsr;
		end
		
		jsr: begin
			next_state = fetch1;
		end
		
		br: begin
     		if(branch_enable == 1)
     			next_state = br_taken;
     		else
     			next_state = fetch1;
     	end

     	br_taken: begin
     		next_state = fetch1;
		end
		
		
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : control




