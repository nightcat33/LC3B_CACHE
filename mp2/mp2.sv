module mp2(wishbone.master mem);


wishbone cpu_cache(mem.CLK);

CPU lc3(.wb2(cpu_cache));

Cache cache
(
	 .wb2(cpu_cache),
	 
	 .rdata(mem.DAT_S),
	 .address(mem.ADR),
	 .wdata(mem.DAT_M),

    .physocal_mem_write(mem.WE),
	 .m_retry(mem.RTY),
	 .m_ack(mem.ACK),
	 .m_cyc(mem.CYC),
	 .m_stb(mem.STB),
	 .sel(mem.SEL)
);

//comment out the above and connect cpu directly to memory
//to test if your CPU adheres to Wishbone spec
//(not a rigorous test, but will catch some obvious errors)
//CPU cpu(.wb2(mem));

endmodule : mp2