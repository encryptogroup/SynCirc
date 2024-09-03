module MULT8 
( 
	input  [7:0] A,
	input  [7:0] B,
	output [15:0] O
);	

	wire [15:0] w[7:0];
	wire [15:0] AA[7:0];
	wire [15:0] B_;

	
	assign w[0] = (A[0])?B_:0;
	assign B_ = {{8{1'b0}}, B};
	assign O = w[7];
	
	genvar g;
	
	generate
	for(g=1;g<8;g=g+1)
	begin:MULT_UNIT
			MUX16 _MUX(
				.x_a({(16){1'b0}}),
				.x_b({B_[15-g:0], {g{1'b0}}}),
				.x_s(A[g]),
				.wx(AA[g])
			);
			ADD16 ADD_(
				.x_a(AA[g]),
				.x_b(w[g-1]), 
				.wx(w[g])
			);
	end
	endgenerate
	
endmodule


