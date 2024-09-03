module main(input wire [1:0] a, output wire b);
   foo foo_0(a, b);
endmodule // main

module foo(input wire [1:0] a, output wire b);
   bar bar_0(a, b);
endmodule // foo

module bar(input wire [1:0] a, output wire b);
   assign b = a[0] & a[1];
endmodule // bar
