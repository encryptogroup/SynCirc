module main(input wire [3:0] a, output wire b);
   and4 and4_0(a, b);
endmodule // main

module and4(input wire [3:0] a, output wire b);
   assign b = a[0] & a[1] & a[2] & a[3];
endmodule // and
