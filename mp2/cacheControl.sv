import lc3b_types::*;

module cacheControl (
	input clk,    // Clock
	input s_cyc,
	input s_stb,
	// cpu signals
	output logic mem_resp,
    input mem_read,
    input mem_write,

    // actual memory signals
    output logic physocal_mem_write,
	 output logic m_cyc,
	 output logic m_stb,
	 input m_ack,
	 input m_retry,

    // cache datapath signals
    input hitA,
	 input hitB,

	input valid_bit_A,
	input valid_bit_B,
	input dirty_bit_A,
	input dirty_bit_B,

	input lru_out,

	output logic array_sel,
	output logic mem_address_sel,
	output logic cache_in_sel,

	output logic loadLRU,

	output logic loadValidBitArrayA,
	output logic loadValidBitArrayB,

	output logic loadTagArrayA,
	output logic loadTagArrayB,

	output logic loadDirtyBitArrayA,
	output logic loadDirtyBitArrayB,

	output logic loadDataArrayA,
	output logic loadDataArrayB,

	output logic valid_bit,
	output logic dirty_bit,

	output logic lru_bit,
	output logic [15:0] sel,
	input logic [15:0] sel_signal
);


logic [15:0] sel_from_cpu;

assign sel_from_cpu = sel_signal;

enum int unsigned { /* list of states */
	read_physical_mem,
	read_write,
	write_back
} state, next_state;


always_comb
begin : state_actions /* Output assignments */
	// control signals to cpu
	mem_resp = 0;

	// control signals to physical memory
	physocal_mem_write = 0;
	m_cyc = 0;
	m_stb = 0;
	

	// control signals to cache datapath
	// load signals
	loadLRU = 0;
	loadDataArrayA = 0;
	loadDataArrayB = 0;
	loadTagArrayA = 0;
	loadTagArrayB = 0;
	loadDirtyBitArrayA = 0;
	loadDirtyBitArrayB = 0;
	loadValidBitArrayA = 0;
	loadValidBitArrayB = 0;

	// mux signals
	// select A or B
	array_sel = 0;
	cache_in_sel = 0;
	mem_address_sel = 0;

	// lru, valid bit, dirty bit
	valid_bit = 0;
	dirty_bit = 0;
	lru_bit = 0;
	sel = 16'b0000000000000000;
	
	case (state)
		//cache read write
		read_write:
		begin
			// read signal from cpu
			if (mem_read == 1 && s_cyc == 1 && s_stb == 1)
			begin
				if (hitA)
				begin
					mem_resp = 1;
					array_sel = 0;
					lru_bit = 1;
					loadLRU = 1;
				end

				else if (hitB)
				begin
					mem_resp = 1;
					array_sel = 1;
					lru_bit = 0;
					loadLRU = 1;
				end
				// miss
				else
				begin
				end

			end
			else if (mem_write == 1 && s_cyc == 1 && s_stb == 1)
			begin
				if (hitA)
				begin
					array_sel = 0;
					loadDataArrayA = 1;
					lru_bit = 1;
					loadLRU = 1;
					// data from cpu
					cache_in_sel = 1;
					dirty_bit = 1;
					loadDirtyBitArrayA = 1;
					mem_resp = 1;
				end
				else if (hitB)
				begin
					array_sel = 1;
					loadDataArrayB = 1;
					lru_bit = 0;
					loadLRU = 1;
					// data from cpu
					cache_in_sel = 1;
					dirty_bit = 1;
					loadDirtyBitArrayB = 1;
					mem_resp = 1;
				end
				else
				// write miss
				begin
					// nothing
					// maybe we need to write into physical memory directly
				end
			end
		end

		write_back:
		begin
			if (lru_out == 0)
			begin
				array_sel = 0;
				mem_address_sel = 1;
				physocal_mem_write = 1;
				dirty_bit = 0;
				loadDirtyBitArrayA = 1;
				m_stb = 1;
				m_cyc = 1;
				sel = 16'b1111111111111111;
			end

			else 
			begin
				array_sel = 1;
				mem_address_sel = 1;
				physocal_mem_write = 1;
				dirty_bit = 0;
				loadDirtyBitArrayB = 1;
				m_stb = 1;
				m_cyc = 1;
				sel = 16'b1111111111111111;
			end
			
		end

		read_physical_mem:
		begin
			// hit A, lru bit being 1
			// hit B, lru bit being 0
			m_stb = 1;
			m_cyc = 1;
			sel = 16'b1111111111111111;
			if (lru_out == 0)
			begin
				array_sel = 0;
				loadDataArrayA = 1;
				valid_bit = 1;
				loadValidBitArrayA = 1;
				loadTagArrayA = 1;
			end
			else
			begin
				array_sel = 1;
				loadDataArrayB = 1;
				valid_bit = 1;
				loadValidBitArrayB = 1;
				loadTagArrayB = 1;
			end
		end
		

		default:
		begin
			// do nothing
		end

	endcase

end



always_comb
begin : next_state_logic

	next_state = state;

	case (state)

		read_write:
		begin
			// data found inside the cache, return data to cpu
			if (hitA || hitB)
				next_state = read_write;
			// miss
			// both cache lines are occupied, need to replace one
			else if (valid_bit_A && valid_bit_B)
			begin
				// the recent access data array is B, and A is dirty, so we replace A
				if (lru_out == 0 && dirty_bit_A)
					next_state = write_back;
				else if (lru_out == 1 && dirty_bit_B)
					next_state = write_back;
				else
					// just read from physical memory to replace the least used one
					next_state = read_physical_mem;
			end
			else
			begin
			// maybe need to add support for writing to physical memory
				if (s_cyc == 1 && s_stb == 1) 
					next_state = read_physical_mem;
				else
					next_state = read_write;
				
			end
		end

		write_back:
		begin
			if (m_ack !== 1'b1 || m_retry === 1'b1)
				next_state = write_back;
			else
				next_state = read_write;
		end

		read_physical_mem:
		begin
			if (m_ack !== 1'b1 || m_retry === 1'b1)
				next_state = read_physical_mem;
			else
				next_state = read_write;
		end


		default:
		begin
			next_state = read_write;
		end
	
	endcase
end



always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule





