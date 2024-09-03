module main(input wire [3:0] a, output wire [3:0] y);
   assign y = {a[0], a[1], a[2], a[3]};
endmodule // main
