module DIV32(
	input  [31:0] A,
	input  [31:0] B,
	output [31:0] O
);

	wire	[63:0] A_[32:0];
	wire	[63:0] D[31:0];

	assign	A_[32] = {{32{1'b0}}, A};

	genvar g;

	generate
	for(g = 31; g >= 0;g = g - 1)
	begin:DIV_UNIT
		if (g > 0)
		SUBC64 _SUB(
			.x_a(A_[g+1]),
			.x_b({{(32-g){1'b0}}, B, {g{1'b0}}}),
			.wx(D[g]),
			.cout(O[g])
		);
		else
		SUBC64 _SUB(
			.x_a(A_[g+1]),
			.x_b({{(32-g){1'b0}}, B}),
			.wx(D[g]),
			.cout(O[g])
		);
		MUX64 _MUX(
			.x_a(A_[g+1]),
			.x_b(D[g]),
			.x_s(O[g]),
			.wx(A_[g])
		);
	end
	endgenerate

endmodule
