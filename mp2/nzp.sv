import lc3b_types::*;

module nzp #(parameter width = 16)
(
	input lc3b_nzp a, 
	input lc3b_nzp b,
	output logic f
);

always_comb
begin
	if (a[0] && b[0] || a[1] && b[1] || a[2] && b[2])
		f = 1;
	else
		f = 0;
end
	
endmodule : nzp