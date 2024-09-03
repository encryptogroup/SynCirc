module main(input wire [1:0] a, output wire [1:0] b);
   foo foo_0(a, b);
endmodule // main

module foo(input wire [1:0] a, output wire [1:0] b);
   assign b = {a[0] & a[1], a[0] & a[1]};
endmodule // foo
