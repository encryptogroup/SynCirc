module main(input wire [31:0] a, output wire [31:0] b);
   wire over_threshold;
   wire [31:0] incremented;

   compare cmp(a, over_threshold);
   increment inc(a, incremented);
   assign b = over_threshold ? a : incremented;
endmodule // main

module compare(input wire [31:0] a, output wire b);
   assign b = a > 4096;
endmodule // foo

module increment(input wire [31:0] a, output wire [31:0] c);
   assign c = a + 1;
endmodule // foo
