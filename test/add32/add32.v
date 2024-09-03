module main(input wire [31:0] a, input wire [31:0] b, output wire [31:0] c);
   add add_0({ a, b }, c);
endmodule // main

module add(input wire [63:0] a, output wire [31:0] c);
   assign c = a[31:0] + a[63:32];
endmodule // add
