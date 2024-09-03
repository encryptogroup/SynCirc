module argmax
#(
  parameter N=10, // number of inputs
  parameter M=32  // input bit-width
)
(
  in,
  max,
  ind
);

  function integer log2;
    input [31:0] value;
    reg [31:0] temp;
  begin
    temp = value;
    for (log2=0; temp>0; log2=log2+1)
      temp = temp>>1;
  end
  endfunction

  localparam S = 4;

  input [511:0] in;
  output[31:0] max;
  output[3:0] ind;

  wire [31:0] max_i [15:0];
  wire [3:0] ind_i[15:0];
  wire greater [16-1:0];

  assign greater[0] = 0;
  assign max_i[0] = in[31:0];
  assign ind_i[0] = 0;

  genvar g;
  generate
  for (g=1;g<16;g=g+1) begin:S1
					COMP32 COMP_(
					.x_a(max_i[g-1]),
					.x_b(in[(g+1)*32-1:g*32]),
					.wx(greater[g])
				);
					MUX32 MUX32_(
					.x_a(in[(g+1)*32-1:g*32]),
					.x_b(max_i[g-1]),
					.x_s(greater[g]),
					.wx(max_i[g])
				);
					MUX4 MUX4_(
					.x_a(g),
					.x_b(ind_i[g-1]),
					.x_s(greater[g]),
					.wx(ind_i[g])
				);
  end
  endgenerate

  assign max = max_i[15];
  assign ind = ind_i[15];

endmodule
