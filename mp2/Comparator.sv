module Comparator (

	input logic [8:0] a,
	input logic [8:0] b,
	output logic result
	// if a == b, result = 1, else result = 0
);

always_comb
begin

	if (a == b)
		result = 1'b1;
	else
		result = 1'b0;
end

endmodule