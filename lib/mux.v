(* techmap_celltype = "$mux" *)
module mux(A, B, S, Y);
   parameter WIDTH = 1;

   (* force_downto *)
   input [WIDTH-1:0] A;
   (* force_downto *)
   input [WIDTH-1:0] B;
   (* force_downto *)
   input             S;
   (* force_downto *)
   output [WIDTH-1:0] Y;

   genvar             i;
   generate begin
      for (i = 0; i < WIDTH; i = i + 1) begin:bits
	 assign Y[i] = (((A[i] ^ B[i]) & S) ^ A[i]);
      end
   end endgenerate
endmodule // mux
