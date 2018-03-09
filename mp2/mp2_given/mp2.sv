module mp2(wishbone.master mem);

wishbone cpu_cache(mem.CLK);

cpu cpu(cpu_cache);

cache cache
(
	 .cpu(cpu_cache),
	 .mem
);

//comment out the above and connect cpu directly to memory
//to test if your CPU adheres to Wishbone spec
//(not a rigorous test, but will catch some obvious errors)
//cpu cpu(mem);

endmodule : mp2