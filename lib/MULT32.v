module MULT32 
( 
	input  [31:0] A,
	input  [31:0] B,
	output [63:0] O
);	

	wire [63:0] w[31:0];
	wire [63:0] AA[31:0];
	wire [63:0] B_;

	
	assign w[0] = (A[0])?B_:0;
	assign B_ = {{32{1'b0}}, B};
	assign O = w[31];
	
	genvar g;
	
	generate
	for(g=1;g<32;g=g+1)
	begin:MULT_UNIT
			MUX64 _MUX(
				.x_a({(64){1'b0}}),
				.x_b({B_[63-g:0], {g{1'b0}}}),
				.x_s(A[g]),
				.wx(AA[g])
			);
			ADD64 ADD_(
				.x_a(AA[g]),
				.x_b(w[g-1]), 
				.wx(w[g])
			);
	end
	endgenerate
	
endmodule


