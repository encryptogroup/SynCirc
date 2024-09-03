module compare_swap64(
		a1, a2,
		dir,
		o1, o2
	);

	input [63:0] a1, a2;
	input dir;              // dir = 1 -> ascending
	output [63:0] o1, o2;

	wire comp;
	wire isCorrect;

	COMP64 COMP_ (.x_a(a1), .x_b(a2), .wx(comp));

	assign isCorrect = (dir==1 & comp==1) ^ (dir==0 & comp==0);

	MUX64 MUX_o1 (.x_a(a2), .x_b(a1), .x_s(isCorrect), .wx(o1));
	MUX64 MUX_o2 (.x_a(a1), .x_b(a2), .x_s(isCorrect), .wx(o2));

endmodule

module bitonic_merge64
	#(
		parameter K = 16
	)
	(
		in_array,
		dir,
		out_array
	);

	input [64*K-1:0] in_array;
	input dir;
	output [64*K-1:0] out_array;

	wire [63:0] in_mat [K-1:0];

	wire [63:0] out_interm_mat [K-1:0];
	wire [64*K-1:0] out_interm_array;

	wire [64*K-1:0] out_merge;

	localparam lo = 0;

	genvar i;
	generate
		for (i=K-1; i>=0; i=i-1) begin
			assign in_mat[i] = in_array[(i+1)*64-1:i*64];
			assign out_interm_array[(i+1)*64-1:i*64] = out_interm_mat[i];
		end
	endgenerate

	generate
		if (K > 1) begin
			localparam k = K/2;

			for (i=lo; i<lo+k; i=i+1) begin
				compare_swap64 compare_swap_
							(.a1(in_mat[i]), .a2(in_mat[i+k]), .dir(dir), .o1(out_interm_mat[i]), .o2(out_interm_mat[i+k]));
			end

			bitonic_merge64 #(.K(k)) bitonic_merge_1
							(.in_array(out_interm_array[(lo+k)*64-1:lo*64]), .dir(dir), .out_array(out_merge[(lo+k)*64-1:lo*64]));
			bitonic_merge64 #(.K(k)) bitonic_merge_2
							(.in_array(out_interm_array[(lo+2*k)*64-1:(lo+k)*64]), .dir(dir), .out_array(out_merge[(lo+2*k)*64-1:(lo+k)*64]));
		end
	endgenerate

	assign out_array = (K > 1) ? out_merge : in_array;

endmodule

module bitonic_sort64
	#(
		parameter K = 16
	)
	(
		in_array,
		dir,
		out_array
	);

	input [64*K-1:0] in_array;
	input dir;
	output [64*K-1:0] out_array;

	wire [64*K-1:0] out_sort;
	wire [64*K-1:0] out_merge;

	localparam lo = 0;

	genvar i;
	generate
		if (K > 1) begin
			localparam k = K/2;

			bitonic_sort64 #(.K(k)) bitonic_sort_1
							(.in_array(in_array[(lo+k)*64-1:lo*64]), .dir(1'b1), .out_array(out_sort[(lo+k)*64-1:lo*64]));
			bitonic_sort64 #(.K(k)) bitonic_sort_2
							(.in_array(in_array[(lo+2*k)*64-1:(lo+k)*64]), .dir(1'b0), .out_array(out_sort[(lo+2*k)*64-1:(lo+k)*64]));
			bitonic_merge64 #(.K(K)) bitonic_merge_
							(.in_array(out_sort), .dir(dir), .out_array(out_merge));
		end
	endgenerate

	assign out_array = (K > 1) ? out_merge : in_array;

endmodule
