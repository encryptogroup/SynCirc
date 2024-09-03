module square_root_comb64(  //N=64,M=128
	input 			[63:0]		A,
	output			[31:0]	O
	);

	wire	[31:0]	Y[0:128];
	wire	[31:0]	Y0[0:128];

	assign Y[0] = {1'b1,{(31){1'b0}}};
	assign Y0[0] = {1'b1,{(31){1'b0}}};

	assign O = Y[128];

	genvar gv;
	generate
	for (gv = 0; gv < 128; gv = gv + 1)
	begin: sqr_rt
		squar_root_unit64 squar_root_unit64(
			.x(A),
			.y_in(Y[gv]),
			.y0_in(Y0[gv]),
			.y(Y[gv+1]),
			.y0(Y0[gv+1])
);
	end
	endgenerate


endmodule


module squar_root_unit64(
	input		[63:0]		x,
	input	[31:0]	y_in, y0_in,
	output	[31:0]	y, y0
);

	wire 						t;
	wire		[31:0]	y_min_y0, y_mid;
	wire		[63:0]		y_sqr;
	wire		[1:0]		temp;

	//assign	y_sqr = y_in * y_in;
	MULT32 MULT1(.A(y_in), .B(y_in), .O(y_sqr));
	//assign 	t = (y_sqr > x) ? 1 : 0;
	COMP64 COMP1(.x_a(x), .x_b(y_sqr), .wx(t));
	//assign	y_min_y0 = y_in - y0_in;
	SUB32 SUB1 (.x_a(y_in), .x_b(y0_in), .wx(y_min_y0), .cout(temp[0]));
	//assign 	y_mid = t? y_min_y0 : y_in;
	MUX32 MUX1 (.x_a(y_min_y0), .x_b(y_in), .x_s(t), .wx(y_mid));
	assign 	y0 = y0_in >> 1;
	//assign 	y = y_mid + y0;
	ADD32 ADD1 (.x_a(y_mid), .x_b(y0), .wx(y));

endmodule
