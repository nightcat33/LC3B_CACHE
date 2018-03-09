import lc3b_types::*;

module cacheDatapath (
	input clk,    // Clock

	// signals communicate with lc3b
	input logic [11:0] mem_address,
	input [127:0] mem_wdata,
	input [15:0] sel_signal,
	output logic [127:0] mem_rdata,

	// signals communicate with actual memory
	// one cache line is 128 bits
	// address is 16 bits
	// byte addressable
	input logic [127:0] rdata,
	output logic [11:0] address,
	output logic [127:0] wdata,
	
	// cache control signals
	output logic hitA,
	output logic hitB,

	input loadLRU,

	input loadValidBitArrayA,
	input loadValidBitArrayB,

	input loadTagArrayA,
	input loadTagArrayB,

	input loadDirtyBitArrayA,
	input loadDirtyBitArrayB,

	input loadDataArrayA,
	input loadDataArrayB,

	input valid_bit,
	input dirty_bit,
	input lru_bit,

	output logic lru_out,

	output logic valid_bit_A,
	output logic valid_bit_B,
	output logic dirty_bit_A,
	output logic dirty_bit_B,

	input array_sel,
	input mem_address_sel,
	input cache_in_sel

);


// set index has three bits
logic [2:0] setIndex;
logic [8:0] tag;
logic [3:1] wordOffset;

logic [127:0] data_arrayA_out;
logic [127:0] data_arrayB_out;

logic [8:0] tagA_out;
logic [8:0] tagB_out;
logic [8:0] tagMuxOut;

logic tagCompareA;
logic tagCompareB;

assign setIndex = mem_address[2:0];
assign tag = mem_address[11:3];
// assign wordOffset = mem_address[3:1];

logic [127:0] cacheDataMuxOut;
logic [127:0] cache_in_mux_out;
logic [127:0] cacheReplaceDataIn;
logic [7:0] cacheReplaceOut1;
logic [7:0] cacheReplaceOut2;
logic [7:0] cacheReplaceOut3;
logic [7:0] cacheReplaceOut4;
logic [7:0] cacheReplaceOut5;
logic [7:0] cacheReplaceOut6;
logic [7:0] cacheReplaceOut7;
logic [7:0] cacheReplaceOut8;
logic [7:0] cacheReplaceOut9;
logic [7:0] cacheReplaceOut10;
logic [7:0] cacheReplaceOut11;
logic [7:0] cacheReplaceOut12;
logic [7:0] cacheReplaceOut13;
logic [7:0] cacheReplaceOut14;
logic [7:0] cacheReplaceOut15;
logic [7:0] cacheReplaceOut16;

assign cacheReplaceDataIn = {
		cacheReplaceOut16, cacheReplaceOut15, cacheReplaceOut14, cacheReplaceOut13, cacheReplaceOut12,
		cacheReplaceOut11, cacheReplaceOut10, cacheReplaceOut9, cacheReplaceOut8, cacheReplaceOut7,
		cacheReplaceOut6, cacheReplaceOut5, cacheReplaceOut4, cacheReplaceOut3, cacheReplaceOut2,
		cacheReplaceOut1
};

// mux

mux2 #(.width(128)) cacheDataOutMux (
	.sel(array_sel),
	.a(data_arrayA_out),
	.b(data_arrayB_out),
	.f(cacheDataMuxOut)
);

assign mem_rdata = cacheDataMuxOut;


mux2 #(.width(9)) tagMux (
	.sel(array_sel),
	.a(tagA_out),
	.b(tagB_out),
	.f(tagMuxOut)
);


// real memory address mux
// read data from physical memory into cache using mem_address[15:4]
// write back which write data back into memory
mux2 #(.width(12)) memAddressMux (
	.sel(mem_address_sel),
	.a( {mem_address } ),
	.b( {tagMuxOut, mem_address[2:0]} ),
	.f( address )
);

// data into cache from lc3b
// data choosen from physical memory or write from cpu
mux2 #(.width(128)) cache_in_mux
(
	.sel(cache_in_sel),
	.a(rdata),
	.b(cacheReplaceDataIn),
	.f(cache_in_mux_out)
);


// logic [127:0] cacheReplaceDataIn;


// replace data in the cache
// write back

always_comb
begin

	if (sel_signal[0])
		cacheReplaceOut1 = mem_wdata[7:0];
	else
		cacheReplaceOut1 = cacheDataMuxOut[7:0];

	if (sel_signal[1])
		cacheReplaceOut2 = mem_wdata[15:8];
	else
		cacheReplaceOut2 = cacheDataMuxOut[15:8];
		

	if (sel_signal[2])
		cacheReplaceOut3 = mem_wdata[7:0];
	else
		cacheReplaceOut3 = cacheDataMuxOut[23:16];

	if (sel_signal[3])
		cacheReplaceOut4 = mem_wdata[15:8];
	else
		cacheReplaceOut4 = cacheDataMuxOut[31:24];



	if (sel_signal[4])
		cacheReplaceOut5 = mem_wdata[7:0];
	else
		cacheReplaceOut5 = cacheDataMuxOut[39:32];

	if (sel_signal[5])
		cacheReplaceOut6 = mem_wdata[15:8];
	else
		cacheReplaceOut6 = cacheDataMuxOut[47:40];
		

	if (sel_signal[6])
		cacheReplaceOut7 = mem_wdata[7:0];
	else
		cacheReplaceOut7 = cacheDataMuxOut[55:48];

	if (sel_signal[7])
		cacheReplaceOut8 = mem_wdata[15:8];
	else
		cacheReplaceOut8 = cacheDataMuxOut[63:56];

	if (sel_signal[8])
		cacheReplaceOut9 = mem_wdata[7:0];
	else
		cacheReplaceOut9 = cacheDataMuxOut[71:64];
		

	if (sel_signal[9])
		cacheReplaceOut10 = mem_wdata[15:8];
	else
		cacheReplaceOut10 = cacheDataMuxOut[79:72];


	if (sel_signal[10])
		cacheReplaceOut11 = mem_wdata[7:0];
	else
		cacheReplaceOut11 = cacheDataMuxOut[87:80];
		

	if (sel_signal[11])
		cacheReplaceOut12 = mem_wdata[15:8];
	else
		cacheReplaceOut12 = cacheDataMuxOut[95:88];


	if (sel_signal[12])
		cacheReplaceOut13 = mem_wdata[7:0];
	else
		cacheReplaceOut13 = cacheDataMuxOut[103:96];

	if (sel_signal[13])
		cacheReplaceOut14 = mem_wdata[15:8];
	else
		cacheReplaceOut14 = cacheDataMuxOut[111:104];

	if (sel_signal[14])
		cacheReplaceOut15 = mem_wdata[7:0];
	else
		cacheReplaceOut15 = cacheDataMuxOut[119:112];

	if (sel_signal[15])
		cacheReplaceOut16 = mem_wdata[15:8];
	else
		cacheReplaceOut16 = cacheDataMuxOut[127:120];
end


	




// declare modules of arrays

// lru bits array
Array #(.width(1)) LRU (
	.clk(clk),
	.writeEnable(loadLRU),
	.address(setIndex),
	.datain(lru_bit),
	.dataout(lru_out)
);

Array dataStoreA (
	.clk(clk),
	.writeEnable(loadDataArrayA),
	.address(setIndex),
	.datain(cache_in_mux_out),
	.dataout(data_arrayA_out)
);

Array dataStoreB (
	.clk(clk),
	.writeEnable(loadDataArrayB),
	.address(setIndex),
	.datain(cache_in_mux_out),
	.dataout(data_arrayB_out)
);

Array #(.width(1)) validBitArrayA (
	.clk(clk),
	.writeEnable(loadValidBitArrayA),
	.address(setIndex),
	.datain(valid_bit),
	.dataout(valid_bit_A)
);


Array #(.width(1)) validBitArrayB (
	.clk(clk),
	.writeEnable(loadValidBitArrayB),
	.address(setIndex),
	.datain(valid_bit),
	.dataout(valid_bit_B)
);

Array #(.width(1)) dirtyBitArrayA (
	.clk(clk),
	.writeEnable(loadDirtyBitArrayA),
	.address(setIndex),
	.datain(dirty_bit),
	.dataout(dirty_bit_A)
);


Array #(.width(1)) dirtyBitArrayB (
	.clk(clk),
	.writeEnable(loadDirtyBitArrayB),
	.address(setIndex),
	.datain(dirty_bit),
	.dataout(dirty_bit_B)
);

Array #(.width(9)) tagArrayA (
	.clk(clk),
	.writeEnable(loadTagArrayA),
	.address(setIndex),
	.datain(tag),
	.dataout(tagA_out)
);

Array #(.width(9)) tagArrayB (
	.clk(clk),
	.writeEnable(loadTagArrayB),
	.address(setIndex),
	.datain(tag),
	.dataout(tagB_out)
);


Comparator tagAComparator (
	.a(tag),
	.b(tagA_out),
	.result(tagCompareA)
);

Comparator tagBComparator (
	.a(tag),
	.b(tagB_out),
	.result(tagCompareB)
);


// only one can be 1'b1
assign hitA = valid_bit_A & tagCompareA;
assign hitB = valid_bit_B & tagCompareB;

// send data from cache to actual memory
assign wdata = cacheDataMuxOut;




endmodule



