(* techmap_celltype = "bitext" *)
module bitext (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;

   localparam SUM_WIDTH = (A_WIDTH > B_WIDTH) ? A_WIDTH : B_WIDTH;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   output Y;

   wire [SUM_WIDTH-1:0] sum;

   assign sum = A + B;
   assign Y = sum[SUM_WIDTH-1];
endmodule // bitext
