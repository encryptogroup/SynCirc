module main(input wire a, output wire b);
   foo foo_0(a, b);
endmodule // main

module foo(input wire a, output wire b);
   assign b = a;
endmodule // foo
