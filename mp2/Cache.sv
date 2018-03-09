import lc3b_types::*;

module Cache (
	wishbone.slave wb2,

	// signals communicate with actual memory
	// one cache line is 128 bits
	// address is 16 bits
	// byte addressable
	input logic [127:0] rdata,
	output logic [11:0] address,
	output logic [127:0] wdata,

    // actual memory signals
   output logic physocal_mem_write,
	input m_retry,
	input m_ack,
	output logic m_cyc,
	output logic m_stb,
	output logic [15:0] sel

);

logic mem_resp;
logic [11:0] mem_address;
logic mem_write;
logic mem_read;

logic [127:0] mem_rdata;
logic [127:0] mem_wdata;
logic [15:0] sel_signal;

assign wb2.ACK = mem_resp;
assign mem_address = wb2.ADR;
assign wb2.RTY = wb2.STB & wb2.CYC & (!mem_resp);
assign mem_write = wb2.WE;
assign mem_read = ~mem_write;
assign wb2.DAT_S = mem_rdata;

assign mem_wdata = wb2.DAT_M;

assign sel_signal = wb2.SEL;




// cache control signals
logic hitA;
logic hitB;

logic loadLRU;

logic loadValidBitArrayA;
logic loadValidBitArrayB;

logic loadTagArrayA;
logic loadTagArrayB;

logic loadDirtyBitArrayA;
logic loadDirtyBitArrayB;

logic loadDataArrayA;
logic loadDataArrayB;

logic valid_bit;
logic dirty_bit;
logic lru_bit;

logic lru_out;

logic valid_bit_A;
logic valid_bit_B;
logic dirty_bit_A;
logic dirty_bit_B;

logic array_sel;
logic mem_address_sel;
logic cache_in_sel;

cacheControl cacheController(
	.clk(wb2.CLK),    // Clock
	// cpu signals
	.s_cyc(wb2.CYC),
	.s_stb(wb2.STB),
	.mem_resp,
   .mem_read,
   .mem_write,
	.m_stb,
	.m_cyc,
	.m_ack,
	.m_retry,
    // actual memory signals
   .physocal_mem_write,
	
    // cache datapath signals
   .hitA,
	.hitB,
	.valid_bit_A,
	.valid_bit_B,
	.dirty_bit_A,
	.dirty_bit_B,
	.lru_out,
	.array_sel,
	.mem_address_sel,
	.cache_in_sel,
	.loadLRU,
	.loadValidBitArrayA,
	.loadValidBitArrayB,
	.loadTagArrayA,
	.loadTagArrayB,
	.loadDirtyBitArrayA,
	.loadDirtyBitArrayB,
	.loadDataArrayA,
	.loadDataArrayB,
	.valid_bit,
	.dirty_bit,
	.lru_bit,
	.sel,
	.sel_signal
);

cacheDatapath cacheDatapath(
	.clk(wb2.CLK),    // Clock

	// signals communicate with lc3b
	.mem_address,
	.mem_wdata,
	.sel_signal,
	.mem_rdata,

	// signals communicate with actual memory
	// one cache line is 128 bits
	// address is 16 bits
	// byte addressable
	.rdata,
	.address,
	.wdata,
	
	// cache control signals
	.hitA,
	.hitB,
	.loadLRU,
	.loadValidBitArrayA,
	.loadValidBitArrayB,
	.loadTagArrayA,
	.loadTagArrayB,
	.loadDirtyBitArrayA,
	.loadDirtyBitArrayB,
	.loadDataArrayA,
	.loadDataArrayB,
	.valid_bit,
	.dirty_bit,
	.lru_bit,
	.lru_out,
	.valid_bit_A,
	.valid_bit_B,
	.dirty_bit_A,
	.dirty_bit_B,
	.array_sel,
	.mem_address_sel,
	.cache_in_sel

);


endmodule : Cache

