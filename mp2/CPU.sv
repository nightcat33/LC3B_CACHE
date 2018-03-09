import lc3b_types::*;

module CPU
(
	 wishbone.master wb2 
);

logic mem_resp;
logic mem_write;
logic [127:0] data;
logic [15:0] mem_wdata;
logic [1:0] mem_byte_enable;
logic [15:0] mem_address;

logic [15:0] mem_rdata;

logic [15:0] sel_signal;
logic [2:0] wordOffset;

assign mem_resp = wb2.ACK & (!wb2.RTY);
assign wb2.WE = mem_write;
assign data = wb2.DAT_S;
assign wb2.DAT_M = mem_wdata;
assign wb2.SEL = sel_signal;
assign wb2.ADR = mem_address[15:4];

assign wordOffset = mem_address[3:1]; 

always_ff @(posedge wb2.CLK)
begin
	for(int i=0; i<16; i++)
		sel_signal[i] = 1'b0;

	if (wordOffset == 3'b000)
	begin
		sel_signal[1:0] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b001)
	begin
		sel_signal[3:2] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b010)
	begin
		sel_signal[5:4] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b011)
	begin
		sel_signal[7:6] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b100)
	begin
		sel_signal[9:8] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b101)
	begin
		sel_signal[11:10] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b110)
	begin
		sel_signal[13:12] <= 2'b11 & mem_byte_enable;
	end
	else if (wordOffset == 3'b111)
	begin
		sel_signal[15:14] <= 2'b11 & mem_byte_enable;
	end
	
end


// data into cpu
mux8 #(.width(16)) mem_rdata_mux (
	.sel(mem_address[3:1]),
	.s1(data[15:0]),
	.s2(data[31:16]),
	.s3(data[47:32]),
	.s4(data[63:48]),
	.s5(data[79:64]),
	.s6(data[95:80]),
	.s7(data[111:96]),
	.s8(data[127:112]),
	.f(mem_rdata)
);

logic load_pc;
logic load_ir;
logic load_regfile;
logic load_mar;
logic load_mdr;
logic load_cc;

logic [2:0] pcmux_sel;
logic storemux_sel;
logic [2:0] alumux_sel;
logic [2:0] regfilemux_sel;
logic [2:0] marmux_sel;
logic mdrmux_sel;

lc3b_aluop aluop;
lc3b_opcode opcode;
logic branch_enable;

logic immCheck;
logic jsrCheck;
logic r7_sel;
logic shf_a;
logic shf_d;

control controller
(
	.clk(wb2.CLK),
	.opcode(opcode),
	.branch_enable(branch_enable),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.pcmux_sel(pcmux_sel),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	.regfilemux_sel(regfilemux_sel),
	.marmux_sel(marmux_sel),
	.mdrmux_sel(mdrmux_sel),
	.aluop(aluop),
	.mem_resp(mem_resp),
	//.mem_read(mem_read),
	.mem_write(mem_write),
	.mem_byte_enable(mem_byte_enable),
	.immCheck(immCheck),
	.jsrCheck(jsrCheck),
	.r7_sel(r7_sel),
	.mem_address(mem_address),
	.shf_a(shf_a),
	.shf_d(shf_d),
	.m_cyc(wb2.CYC),
	.m_stb(wb2.STB)
);

datapath lc3b
(
	.clk(wb2.CLK),
	.load_pc(load_pc),
   .load_ir(load_ir),
   .load_regfile(load_regfile),
   .load_mar(load_mar),
   .load_mdr(load_mdr),
   .load_cc(load_cc),
	.pcmux_sel(pcmux_sel),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
   .regfilemux_sel(regfilemux_sel),
   .marmux_sel(marmux_sel),
   .mdrmux_sel(mdrmux_sel),
   .aluop(aluop),
   .branch_enable(branch_enable),
   .mem_rdata(mem_rdata),
   .mem_address(mem_address),
   .mem_wdata(mem_wdata),
   .opcode(opcode),
	.immCheck(immCheck),
	.jsrCheck(jsrCheck),
	.r7_sel(r7_sel),
	.shf_a(shf_a),
	.shf_d(shf_d)
);


endmodule : CPU