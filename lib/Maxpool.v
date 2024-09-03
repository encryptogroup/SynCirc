module Maxpool ( //b = W=16, n = 2^(N=4)
	input [16*16-1:0] bid,
	output [15:0] winning_bid
	);
	
	genvar i;
	wire [15:0] B [15:0];
	generate
		for (i = 0; i < 16; i = i + 1) begin
			assign B[i] = bid[(i+1)*15:i*16]; 
		end
	endgenerate
	
	genvar j, k;
	
	wire [15:0] WV[4:0][15:0];
	wire [7:0] WID [3:0];
		
	generate
		for (k = 0; k < 16; k = k + 1) begin
			assign WV[0][k] = B[k];
		end
	endgenerate
	
	generate
		for (j = 0; j < 4; j = j + 1) begin: col
			for (k = 0; k < 2**(4-1-j); k = k + 1) 
			begin: row
				COMP16 COMP_(
					.x_a(WV[j][2*k+1]),
					.x_b(WV[j][2*k]),
					.wx(WID[j][k])
				);
				MUX16 MUX_(
					.x_a(WV[j][2*k]),
					.x_b(WV[j][2*k+1]),
					.x_s(WID[j][k]),
					.wx(WV[j+1][k])
				);
			end	
		end
	endgenerate
	
	assign winning_bid = WV[4][0];
	
endmodule



