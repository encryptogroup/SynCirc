module DIV8 (//(parameter N = 16, 16 = 16 )
	input  [7:0] A,
	input  [7:0] B,
	output [7:0] O
);

	wire	[15:0] A_[8:0];
	wire	[15:0] D[7:0];

	assign	A_[8] = {{8{1'b0}}, A};

	genvar g;

	generate
	for(g = 7; g >= 0;g = g - 1)
	begin:DIV_UNIT
		if (g > 0)
		SUBC16 _SUB(
			.x_a(A_[g+1]),
			.x_b({{(8-g){1'b0}}, B, {g{1'b0}}}),
			.wx(D[g]),
			.cout(O[g])
		);
		else
		SUBC16 _SUB(
			.x_a(A_[g+1]),
			.x_b({{(8-g){1'b0}}, B}),
			.wx(D[g]),
			.cout(O[g])
		);
		MUX16 _MUX(
			.x_a(A_[g+1]),
			.x_b(D[g]),
			.x_s(O[g]),
			.wx(A_[g])
		);
	end
	endgenerate

endmodule
