module DIV16 (//(parameter N = 16, 16 = 16 )
	input  [15:0] A,
	input  [15:0] B,
	output [15:0] O
);

	wire	[31:0] temp1[16:0];
	wire	[31:0] temp2[15:0];

	assign	temp1[16] = {{16{1'b0}}, A};

	genvar g;

	generate
	for(g = 15; g >= 0;g = g - 1)
	begin:DIV_UNIT
		if (g > 0)
		SUBC32 _SUB(
			.x_a(temp1[g+1]),
			.x_b({{(16-g){1'b0}}, B, {g{1'b0}}}),
			.wx(temp2[g]),
			.cout(O[g])
		);
		else
		SUBC32 _SUB(
			.x_a(temp1[g+1]),
			.x_b({{(16-g){1'b0}}, B}),
			.wx(temp2[g]),
			.cout(O[g])
		);
		MUX32 _MUX(
			.x_a(temp1[g+1]),
			.x_b(temp2[g]),
			.x_s(O[g]),
			.wx(temp1[g])
		);
	end
	endgenerate

endmodule
