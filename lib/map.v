(* techmap_celltype = "$add" *)
module ADD (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH <= 8 && B_WIDTH <= 8 && Y_WIDTH <= 8)
        ADD8 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH <= 16 && B_WIDTH <= 16 && Y_WIDTH <= 16)
        ADD16 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH <= 32 && B_WIDTH <= 32 && Y_WIDTH <= 32)
        ADD32 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH <= 64 && B_WIDTH <= 64 && Y_WIDTH <= 64)
        ADD64 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // ADD

(* techmap_celltype = "$sub" *)
module SUB (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   wire [Y_WIDTH:0]     Y_full;

   generate
      if (A_WIDTH == 64 && B_WIDTH == 64 && Y_WIDTH == 64) begin
         wire [63:0] add_a;
         wire [63:0] add_b;
         wire [63:0] add_y;
         wire        cout;
         wire        msb;

         assign add_a = {A[62:0], 1'b1};
         assign add_b = {~B[62:0], 1'b1};

         ADDC64 ADDC64(add_a, add_b, add_y, cout);

         assign msb = a[63] ^ ~b[63] ^ cout;
         assign Y = {msb, add_y[63:1]};
      end else begin
         assign Y_full = {A, 1'b1} + {~B, 1'b1};
         assign Y = Y_full[Y_WIDTH:1];
      end
   endgenerate
endmodule // SUB

(* techmap_celltype = "$mul" *)
module MULT (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 8 && B_WIDTH == 8 && Y_WIDTH == 16)
        MULT8 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else if (A_WIDTH == 16 && B_WIDTH == 16 && Y_WIDTH == 32)
        MULT16 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 64)
        MULT32 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // MULT

(* techmap_celltype = "$div" *)
module DIV (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 8 && B_WIDTH == 8 && Y_WIDTH == 8)
        DIV8 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else if (A_WIDTH == 16 && B_WIDTH == 16 && Y_WIDTH == 16)
        DIV16 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 32)
        DIV32 _TECHMAP_REPLACE_ (.A(A), .B(B), .O(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // DIV

(* techmap_celltype = "$gt" *)
module GT (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 8 && B_WIDTH == 8 && Y_WIDTH == 1)
        COMP8 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH == 16 && B_WIDTH == 16 && Y_WIDTH == 1)
        COMP16 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 1)
        COMP32 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else if (A_WIDTH == 64 && B_WIDTH == 64 && Y_WIDTH == 1)
        COMP64 _TECHMAP_REPLACE_ (.x_a(A), .x_b(B), .wx(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // GT

(* techmap_celltype = "$ge" *)
module GE (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   wire                 LT;

   assign Y = ~LT;

   \$gt #(
     .A_SIGNED(B_SIGNED),
     .B_SIGNED(A_SIGNED),
     .A_WIDTH(B_WIDTH),
     .B_WIDTH(A_WIDTH),
     .Y_WIDTH(Y_WIDTH)
   ) _TECHMAP_REPLACE_ (.A(B), .B(A), .Y(LT));
endmodule // GE

(* techmap_celltype = "$lt" *)
module LT (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   \$gt #(
     .A_SIGNED(B_SIGNED),
     .B_SIGNED(A_SIGNED),
     .A_WIDTH(B_WIDTH),
     .B_WIDTH(A_WIDTH),
     .Y_WIDTH(Y_WIDTH)
   ) _TECHMAP_REPLACE_ (.A(B), .B(A), .Y(Y));
endmodule // LT

(* techmap_celltype = "$le" *)
module LE (A, B, Y);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   wire                 GT;

   assign Y = ~GT;

   \$gt #(
     .A_SIGNED(A_SIGNED),
     .B_SIGNED(B_SIGNED),
     .A_WIDTH(A_WIDTH),
     .B_WIDTH(B_WIDTH),
     .Y_WIDTH(Y_WIDTH)
   ) _TECHMAP_REPLACE_ (.A(A), .B(B), .Y(GT));
endmodule // LE

(* techmap_celltype = "f32add" *)
module f32add (A, B, Y);
   parameter A_WIDTH = 32;
   parameter B_WIDTH = 32;
   parameter Y_WIDTH = 32;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 32)
        __f32add__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f32add

(* techmap_celltype = "f32sub" *)
module f32sub (A, B, Y);
   parameter A_WIDTH = 32;
   parameter B_WIDTH = 32;
   parameter Y_WIDTH = 32;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 32)
        __f32sub__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f32sub

(* techmap_celltype = "f32mul" *)
module f32mul (A, B, Y);
   parameter A_WIDTH = 32;
   parameter B_WIDTH = 32;
   parameter Y_WIDTH = 32;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 32 && B_WIDTH == 32 && Y_WIDTH == 32)
        __f32mul__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f32mul

(* techmap_celltype = "f64add" *)
module f64add (A, B, Y);
   parameter A_WIDTH = 64;
   parameter B_WIDTH = 64;
   parameter Y_WIDTH = 64;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 64 && B_WIDTH == 64 && Y_WIDTH == 64)
        __f64add__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f64add

(* techmap_celltype = "f64sub" *)
module f64sub (A, B, Y);
   parameter A_WIDTH = 64;
   parameter B_WIDTH = 64;
   parameter Y_WIDTH = 64;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 64 && B_WIDTH == 64 && Y_WIDTH == 64)
        __f64sub__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f64sub

(* techmap_celltype = "f64mul" *)
module f64mul (A, B, Y);
   parameter A_WIDTH = 64;
   parameter B_WIDTH = 64;
   parameter Y_WIDTH = 64;

   (* force_downto *)
   input [A_WIDTH-1:0] A;
   (* force_downto *)
   input [B_WIDTH-1:0] B;
   (* force_downto *)
   output [Y_WIDTH-1:0] Y;

   generate
      if (A_WIDTH == 64 && B_WIDTH == 64 && Y_WIDTH == 64)
        __f64mul__main _TECHMAP_REPLACE_ (.x(A), .y(B), .out(Y));
      else
           wire              _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule // $f64mul
