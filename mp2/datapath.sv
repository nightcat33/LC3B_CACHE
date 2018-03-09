import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
    input logic [2:0] pcmux_sel,
    input load_pc,
	 input load_mdr,
	 input load_mar,
	 input load_ir,
	 input load_cc,
	 input load_regfile,
	 
	 output lc3b_opcode opcode,
	 input lc3b_aluop aluop,
	 input storemux_sel,
	
	 input logic [2:0] marmux_sel,
	 input mdrmux_sel,
	 
	 input logic [2:0] alumux_sel,
	 input logic [2:0] regfilemux_sel,

	 input lc3b_word mem_rdata,
	 output lc3b_word mem_wdata,
	 output lc3b_word mem_address,
	 
	 output branch_enable,
	 output immCheck,
	 input logic r7_sel,
	 output jsrCheck,
	 output shf_a,
	 output shf_d
    /* declare more ports here */
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_9_out;
lc3b_word pc_plus2_out;
lc3b_word adj9_out;
lc3b_word adj6_out;
lc3b_word adj11_out;
lc3b_word alu_out;
lc3b_word br_add_11_out;

lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word sr1_out;
lc3b_word sr2_out;

lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;

lc3b_reg storemux_out;

lc3b_offset9 offset9;
lc3b_offset6 offset6;
logic [10:0] offset11;
lc3b_nzp cc_out;
lc3b_nzp gencc_out;

lc3b_word unadj8_out;

logic [4:0] imm5;

lc3b_word sext5_out;
lc3b_word sext6_out;

logic [2:0] dest_reg_mux_out;

logic [3:0] imm4;

logic [7:0] trapvect;

lc3b_word stb_ldb_adder_out;

lc3b_word memw_zext_out;

sign_extend #(.width(5)) sext5
(
	.in(imm5),
	.out(sext5_out)
);

sign_extend #(.width(6)) sext6
(
	.in(offset6),
	.out(sext6_out)
);

unsign_extend #(.width(8)) memw_unsign
(
	.in(mem_wdata),
	.out(memw_zext_out)
);

adder stb_ldb_adder 
(
	.a(sext6_out),
	.b(sr1_out),
	.f(stb_ldb_adder_out)
);

mux2 #(.width(3)) dest_reg_mux
( 
	.sel(r7_sel),
	.a(dest),
	.b(3'b111),
	.f(dest_reg_mux_out)
);


mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_9_out),
	 .c(sr1_out),
	 .d(mem_wdata),
	 .e(br_add_11_out),
    .f(pcmux_out)
);

mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

mux4 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(pc_out),
	 .c(mem_wdata),
	 .d(unadj8_out),
	 .e(stb_ldb_adder_out),
    .f(marmux_out)
);

mux4 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
	 .c(br_add_9_out),
	 .d(pc_out),
	 .e(memw_zext_out),
    .f(regfilemux_out)
);

mux4 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6_out),
	 .c(sext5_out),
	 .d(imm4),
    .f(alumux_out)
);

mux2 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);

adder br_add_9
(
	.a(adj9_out),
	.b(pc_out),
	.f(br_add_9_out)
);

adder br_add_11
(
	.a(adj11_out),
	.b(pc_out),
	.f(br_add_11_out)
);

nzp cccomp
(
	.a(dest),
	.b(cc_out),
	.f(branch_enable)
);


gencc GENCC
(
    .in(regfilemux_out),
    .out(gencc_out)
);

/*
 * PC Register
 */
register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);


ir IR
(
    .clk(clk),
    .load(load_ir),
    .in(mem_wdata),
    .opcode(opcode),
    .dest(dest),
    .src1(sr1),
    .src2(sr2),
    .offset6(offset6),
    .offset9(offset9),
	 .offset11(offset11),
	 .jsrCheck(jsrCheck),
	 .imm5(imm5),
	 .immCheck(immCheck),
	 .shf_a(shf_a),
	 .shf_d(shf_d),
	 .imm4(imm4),
	 .trapvect(trapvect)
);


adj #(.width(11)) adj11
(
    .in(offset11),
    .out(adj11_out)
);

adj #(.width(9)) adj9
(
    .in(offset9),
    .out(adj9_out)
);

adj #(.width(6)) adj6
(
    .in(offset6),
    .out(adj6_out)
);

unadj #(.width(8)) unadj8
(
    .in(trapvect),
    .out(unadj8_out)
);

regfile REGFILE
(
    .clk(clk),
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(sr2),
    .dest(dest_reg_mux_out),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);


register mdr
(
    .clk(clk),
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);


register mar
(
    .clk(clk),
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);


register #(.width(3)) cc
(
    .clk(clk),
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);

plus2 plus_2
(
    .in(pc_out),
    .out(pc_plus2_out)
);

alu ALU
(
    .aluop(aluop),
    .a(sr1_out),
    .b(alumux_out),
    .f(alu_out)
);

endmodule : datapath



