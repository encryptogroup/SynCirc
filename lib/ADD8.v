module ADD8 ( x_a, x_b, wx );
  input  [7:0] x_a, x_b;
  output [7:0] wx;
  wire G_1,G_2_1,G_3_1;
  wire G_5_1,P_5_1,G_6_1,P_6_1;
  wire G_4_4,G_5_4,G_6_4;
  wire [7:0] P;
  wire [7:0] G;
  genvar i;
  generate
	for (i=0;i<8;i=i+1)
	begin:PG
		assign P[i] = x_a[i] ^ x_b[i];
		assign G[i] = x_a[i] & x_b[i];
	end
  endgenerate
  assign wx[0] = P[0];
  assign wx[1] = G[0] ^ P[1];
  assign G_1 = G[1] ^ (P[1] & x_a[0] & x_b[0]);//Depth=1;
  assign wx[2] = G_1 ^ P[2];
  assign G_2_1 = G[2] ^ (P[2] & x_a[1] & x_b[1]) ^ (P[2] & P[1] & x_a[0] & x_b[0]); //Depth=1
  assign wx[3] = G_2_1 ^ P[3];
  assign G_3_1 = G[3] ^ (P[3] & G_2_1); //Depth=2
  assign wx[4] = G_3_1 ^ P[4];

  assign G_5_1 = G[5] ^ (P[5] & x_a[4] & x_b[4]);//Depth=1
  assign P_5_1 = P[5] & P[4];//depth=1
  assign G_6_1 = G[6] ^ (P[6] & x_a[5] & x_b[5]) ^ (P[6] & P[5] & x_a[4] & x_b[4]); //Depth=1
  assign P_6_1 = (P[6] & P[5] & P[4]); //depth=1
 //---------------------------------------------------------------------------------------------------------------------
 //---------------------------------------------------------------------------------------------------------------------
 assign G_4_4 = G[4] ^ (P[4] & G[3]) ^ (P[4] & P[3] & G_2_1);//Depth2
 assign wx[5] = G_4_4 ^ P[5];
 assign G_5_4 = G_5_1 ^ (P_5_1 & G[3]) ^ (P_5_1 & P[3] & G_2_1);//Depth2
 assign wx[6] = G_5_4 ^ P[6];
 assign G_6_4 = G_6_1 ^ (P_6_1 & G[3]) ^ (P_6_1 & P[3] & G_2_1);//Depth2
 assign wx[7] = G_6_4 ^ P[7];
 
endmodule



