(* techmap_celltype = "relu_bitext" *)
module relu_bitext(A, Y);
   parameter A_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   wire                 negative;
   assign Y = negative ? 0 : A;

   generate
      if (A_WIDTH == 8 && Y_WIDTH == 8)
        BitExtADD8 cmp (.x_a(A), .x_b(0), .wx(negative));
      else if (A_WIDTH == 16 && Y_WIDTH == 16)
        BitExtADD16 cmp (.x_a(A), .x_b(0), .wx(negative));
      else if (A_WIDTH == 32 && Y_WIDTH == 32)
        BitExtADD32 cmp (.x_a(A), .x_b(0), .wx(negative));
      else if (A_WIDTH == 64 && Y_WIDTH == 64)
        BitExtADD64 cmp (.x_a(A), .x_b(0), .wx(negative));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // relu_bitext
