module main(input wire a, output wire b);
   invert invert_0(a, b);
endmodule // main

module invert(input wire a, output wire b);
   assign b = ~a;
endmodule // invert
