module main(input wire [1:0] a, output wire [3:0] b);
   assign b = {a[0] & a[1], a[0] & a[1], a};
endmodule // main
