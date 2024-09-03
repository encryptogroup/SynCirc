module main(input wire a, output wire b);
   foo foo_0(a, b);
endmodule // main

module foo(input wire a, output wire b);
   bar bar_0(a, b);
endmodule // foo

module bar(input wire a, output wire b);
   assign b = ~a;
endmodule // bar
