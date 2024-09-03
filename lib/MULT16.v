module MULT16 
( 
	input  [15:0] A,
	input  [15:0] B,
	output [31:0] O
);	

	wire [31:0] w[15:0];
	wire [31:0] AA[15:0];
	wire [31:0] B_;

	
	assign w[0] = (A[0])?B_:0;
	assign B_ = {{16{1'b0}}, B};
	assign O = w[15];
	
	genvar g;
	
	generate
	for(g=1;g<16;g=g+1)
	begin:MULT_UNIT
			MUX32 _MUX(
				.x_a({(32){1'b0}}),
				.x_b({B_[31-g:0], {g{1'b0}}}),
				.x_s(A[g]),
				.wx(AA[g])
			);
			ADD32 ADD_(
				.x_a(AA[g]),
				.x_b(w[g-1]), 
				.wx(w[g])
			);
	end
	endgenerate
	
endmodule


