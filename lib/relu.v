(* techmap_celltype = "relu" *)
module relu(A, Y);
   parameter A_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == Y_WIDTH)
        assign Y = (A[A_WIDTH-1]) ? 0 : A;
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // relu
