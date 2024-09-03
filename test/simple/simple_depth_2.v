module main(input wire a, output wire b);
   wire tmp;
   foo foo_0(a, tmp);
   foo foo_1(tmp, b);
endmodule // main

module foo(input wire a, output wire b);
   assign b = a;
endmodule // foo
