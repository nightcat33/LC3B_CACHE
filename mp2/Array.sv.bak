import lc3b_types::*;

module Array #(parameter width = 128) (
	input clk,    // Clock
	// total 8 entries, 8 sets
	input logic [2:0] address,
	input logic [width-1:0] datain,
	input writeEnable,

	output logic [width-1:0] dataout
);


logic [width-1:0] data [7:0];

// initialize the data array
initial
begin
	for (int i=0; i<$size(data); i++)
	begin
		data[i] = 1'b0;
	end 
end

assign dataout = data[address];

always_ff @(posedge clk)
begin
	if (writeEnable == 2'b1)
		data[address] = datain;
end

endmodule





