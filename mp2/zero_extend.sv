import lc3b_types::*;

module zero_extend #(parameter width = 16)
(
	input [width-1:0] in,
	output lc3b_word out
);

assign out = $unsigned(in);

endmodule : zero_extend