module mux8 #(parameter width = 16)
(
	input [2:0] sel,
	input [width-1:0] s1, s2, s3, s4, s5, s6, s7, s8,
	output logic [width-1:0] f
);

always_comb
begin
	if (sel == 3'b000)
		f = s1;
	else if (sel == 3'b001)
		f = s2;
	else if(sel == 3'b010)
		f = s3;
	else if(sel == 3'b011)
		f = s4;
	else if(sel == 3'b100)
		f = s5;
	else if(sel == 3'b101)
		f = s6;
	else if(sel == 3'b110)
		f = s7;
	else 
		f = s8;
end

endmodule : mux8