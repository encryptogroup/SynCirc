module main(input wire [31:0] a, input wire [31:0] b, output wire c);
   cmp cmp_0({ b, a }, c);
endmodule // main

module cmp(input wire [63:0] a, output wire c);
   assign c = a[31:0] > a[63:32];
endmodule // cmp
