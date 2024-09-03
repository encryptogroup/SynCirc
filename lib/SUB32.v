module SUB32 ( x_a, x_b, wx );
  input  [31:0] x_a, x_b;
  output [31:0] wx;
  wire G_1,G_2_1,G_3_1;
  wire G_5_1,P_5_1,G_6_1,P_6_1,G_7_1,P_7_1;
  wire G_9_1,P_9_1,G_10_1,P_10_1,G_11_1,P_11_1;
  wire G_13_1,P_13_1,G_14_1,P_14_1,G_15_1,P_15_1;
  wire G_17_1,P_17_1,G_18_1,P_18_1,G_19_1,P_19_1;
  wire G_21_1,P_21_1,G_22_1,P_22_1,G_23_1,P_23_1;
  wire G_25_1,P_25_1,G_26_1,P_26_1,G_27_1,P_27_1;
  wire G_29_1,P_29_1,G_30_1,P_30_1,G_31_1,P_31_1;
  wire G_33_1,P_33_1,G_34_1,P_34_1,G_35_1,P_35_1;
  wire G_37_1,P_37_1,G_38_1,P_38_1,G_39_1,P_39_1;
  wire G_41_1,P_41_1,G_42_1,P_42_1,G_43_1,P_43_1;
  wire G_45_1,P_45_1,G_46_1,P_46_1,G_47_1,P_47_1;
  wire G_49_1,P_49_1,G_50_1,P_50_1,G_51_1,P_51_1;
  wire G_53_1,P_53_1,G_54_1,P_54_1,G_55_1,P_55_1;
  wire G_57_1,P_57_1,G_58_1,P_58_1,G_59_1,P_59_1;
  wire G_61_1,P_61_1,G_62_1,P_62_1;
  wire G_7_2,G_11_2,G_15_2;
  wire temp1,G_19_2,P_19_2;
  wire temp2,G_23_2,P_23_2;
  wire temp3,G_27_2,P_27_2;
  wire temp4,G_31_2,P_31_2;
  wire temp5,G_35_2,P_35_2;
  wire temp6,G_39_2,P_39_2;
  wire temp7,G_43_2,P_43_2;
  wire temp8,G_47_2,P_47_2;
  wire temp9,G_51_2,P_51_2;
  wire temp10,G_55_2,P_55_2;
  wire temp11,G_59_2,P_59_2;
  wire G_19_3,G_23_3,G_27_3;
  wire G_31_3,G_35_3,G_39_3;
  wire G_43_3,G_47_3,G_51_3;
  wire G_55_3,G_59_3;
  wire G_4_4,G_5_4,G_6_4;
  wire G_8_4,G_9_4,G_10_4;
  wire G_12_4,G_13_4,G_14_4;
  wire G_16_4,G_17_4,G_18_4;
  wire G_20_4,G_21_4,G_22_4;
  wire G_24_4,G_25_4,G_26_4;
  wire G_28_4,G_29_4,G_30_4;
  wire G_32_4,G_33_4,G_34_4;
  wire G_36_4,G_37_4,G_38_4;
  wire G_40_4,G_41_4,G_42_4;
  wire G_44_4,G_45_4,G_46_4;
  wire P_48v3,P_49_1vs3,P_50_1vs3,temp1_G_11_2,temp2_G_11_2,temp3_G_11_2;
  wire G_48_4,G_49_4,G_50_4;
  wire P_52v7,P_53_1vs7,P_54_1vs7,temp_temp1,temp2_temp1,temp3_temp1,temp_G_3_1,temp2_G_3_1,temp3_G_3_1;
  wire G_52_4,G_53_4,G_54_4;
  wire P_56v11,P_57_1vs11,P_58_1vs11,temp_temp2,temp2_temp2,temp3_temp2,temp_G_7_2,temp2_G_7_2,temp3_G_7_2;
  wire G_56_4,G_57_4,G_58_3;
  wire P_60v15,P_60v3,P_61_1_vs_15,P_61_1vs3,P_62_1_vs_15,P_62_1vs3,temp_temp3,temp2_temp3,temp3_temp3,temp_G_11_2,temp2__G_11_2,temp3__G_11_2;
  wire G_60_4,G_61_4,G_62_4;
  wire _G_25_4,_G_26_4,_G_28_4,_G_29_4,_G_30_4;
  wire _G_4_4,_G_5_4,_G_6_4,_G_8_4,_G_9_4,_G_10_4,_G_12_4,_G_13_4,_G_14_4,_G_16_4,_G_17_4,_G_18_4,_G_20_4,_G_21_4,_G_22_4;
  wire _G_19_3,_G_23_3,_G_27_3;
  wire _P_19_2,_P_23_2,_P_27_2,_P_31_2;
  wire _G_7_2,_G_11_2,_G_15_2;
  wire _P_5_1,_P_6_1,_P_7_1,_P_9_1,_P_10_1,_P_11_1,_P_13_1,_P_14_1,_P_15_1,_P_17_1,_P_18_1,_P_19_1;
  wire _G_1,_G_2_1,_G_3_1,_G_24_4,_P_31_1,_P_30_1,_P_29_1,_P_27_1,_P_26_1,_P_25_1,_P_23_1,_P_22_1,_P_21_1;


  wire [31:0] P;
  wire [31:0] G;
  wire [32:0] _x_b;
  wire [31:0] _x_a;
  wire [31:0] One;
  assign One = 32'b00000000000000000000000000000001;
  assign _x_b[0] = 1'b0;
  
  genvar j;
  generate
	for (j=0;j<32;j=j+1)
	begin:PG
		assign _x_a[j] = x_a[j] ^ ~x_b[j]^One[j];
		assign _x_b[j+1] = x_a[j] & ~x_b[j];
	end
  endgenerate
  
  genvar i;
  generate
	for (i=0;i<32;i=i+1)
	begin:PG
		assign P[i] = _x_a[i] ^ _x_b[i];
		assign G[i] = _x_a[i] & _x_b[i];
	end
  endgenerate
  assign wx[0] = P[0];
  assign wx[1] = G[0] ^ P[1];
  assign G_1 = G[1] ^ (P[1] & G[0]); //Depth=2;
  assign wx[2] = G_1 ^ P[2];
  assign G_2_1 = G[2] ^ (P[2] & _x_a[1] & _x_b[1]) ^ (P[2] & P[1] & _x_a[0] & _x_b[0]); //Depth=1
  assign wx[3] = G_2_1 ^ P[3];
  assign G_3_1 = G[3] ^ (P[3] & G_2_1); //Depth=2
  assign wx[4] = G_3_1 ^ P[4];

  assign G_5_1 = G[5] ^ (P[5] & G[4]);//Depth=2
  assign P_5_1 = P[5] & P[4];//depth=1
  assign G_6_1 = G[6] ^ (P[6] & _x_a[5] & _x_b[5]) ^ (P[6] & P[5] & _x_a[4] & _x_b[4]); //Depth=1
  assign P_6_1 = (P[6] & P[5] & P[4]); //depth=1
  assign G_7_1 = G[7] ^ (P[7] & G_6_1); //Depth=2
  assign P_7_1 = (P[7] & P[6] & P[5] & P[4]);//Depth1
	
  assign G_9_1 = G[9] ^ (P[9] & G[8]); //Depth=2
  assign P_9_1 = P[9] & P[8];//depth=1
  assign G_10_1= G[10] ^ (P[10] & _x_a[9] &_x_b[9]) ^ (P[10] & P[9] & _x_a[8] & _x_b[8]); //Depth=1
  assign P_10_1= (P[10] & P[9] & P[8]); //depth=1
  assign G_11_1= G[11] ^ (P[11] & G_10_1); //Depth=2
  assign P_11_1= (P[11] & P[10] & P[9] & P[8]);//Depth1
  
  assign G_13_1 = G[13] ^ (P[13] & G[12]); //Depth=2
  assign P_13_1 = P[13] & P[12];//depth=1
  assign G_14_1 = G[14] ^ (P[14] & _x_a[13] & _x_b[13]) ^ (P[14] & P[13] & _x_a[12] & _x_b[12]); //Depth=1
  assign P_14_1 = (P[14] & P[13] & P[12]); //depth=1
  assign G_15_1 = G[15] ^ (P[15] & G_14_1); //Depth=2
  assign P_15_1 = (P[15] & P[14] & P[13] & P[12]);//Depth1

  assign G_17_1 = G[17] ^ (P[17] & G[16]); //Depth=2
  assign P_17_1 = P[17] & P[16];//depth=1
  assign G_18_1 = G[18] ^ (P[18] & _x_a[17] & _x_b[17]) ^ (P[18] & P[17] & _x_a[16] & _x_b[16]); //Depth=1
  assign P_18_1 = (P[18] & P[17] & P[16]); //depth=1
  assign G_19_1 = G[19] ^ (P[19] & G_18_1); //Depth=2
  assign P_19_1 = (P[19] & P[18] & P[17] & P[16]);//Depth1
  
  assign G_21_1 = G[21] ^ (P[21] & G[20]); //Depth=2
  assign P_21_1 = P[21] & P[20];//depth=1
  assign G_22_1 = G[22] ^ (P[22] & _x_a[21] & _x_b[21]) ^ (P[22] & P[21] & _x_a[20] & _x_b[20]); //Depth=1
  assign P_22_1 = (P[22] & P[21] & P[20]); //depth=1
  assign G_23_1 = G[23] ^ (P[23] & G_22_1); //Depth=2
  assign P_23_1 = (P[23] & P[22] & P[21] & P[20]);//Depth1

  assign G_25_1 = G[25] ^ (P[25] & G[24]); //Depth=2
  assign P_25_1 = P[25] & P[24];//depth=1
  assign G_26_1 = G[26] ^ (P[26] & _x_a[25] & _x_b[25]) ^ (P[26] & P[25] & _x_a[24] & _x_b[24]); //Depth=1
  assign P_26_1 = (P[26] & P[25] & P[24]); //depth=1
  assign G_27_1 = G[27] ^ (P[27] & G_26_1); //Depth=2
  assign P_27_1 = (P[27] & P[26] & P[25] & P[24]);//Depth1
  
  
  assign G_29_1  = G[29] ^ (P[29] & G[28]); //Depth=2
  assign P_29_1  = P[29] & P[28];//depth=1
  assign G_30_1  = G[30] ^ (P[30] & _x_a[29] & _x_b[29]) ^ (P[30] & P[29] & _x_a[28] & _x_b[28]); //Depth=1
  assign P_30_1  = (P[30] & P[29] & P[28]); //depth=1
  assign G_31_1  = G[31] ^ (P[31] & G_30_1); //Depth=2
  assign P_31_1  = (P[31] & P[30] & P[29] & P[28]);//Depth1
 //---------------------------------------------------------------------------------------------------------------------
  assign G_7_2  = G_7_1  ^ (P_7_1 & G[3]) ^ (P_7_1 & P[3] & G_2_1); //Depth2
  assign wx[8] = G_7_2 ^ P[8];
  assign G_11_2 = G_11_1 ^ (P_11_1 & G[7]) ^ (P_11_1 & P[7] & G_6_1) ^ (P_11_1 & P_7_1 & G[3]) ^ (P_11_1 & P_7_1 & P[3] & G_2_1); //Depth2
  assign wx[12] = G_11_2 ^ P[12];
  assign G_15_2 = G_15_1 ^ (P_15_1 & G_11_2); //Depth 3 
  assign wx[16] = G_15_2 ^ P[16];

 assign temp1 = G_15_1 ^ (P_15_1 & G[11]) ^ (P_15_1 & P[11] & G_10_1) ^ (P_15_1 & P_11_1 & G[7]) ^ (P_15_1 & P_11_1 & P[7] & G_6_1);//depth2
 assign G_19_2 = G_19_1 ^ (P_19_1 & temp1); //Depth3 
 assign P_19_2 = (P_19_1 & P_15_1 & P_11_1 & P_7_1);//Depth2
 
 assign temp2 = G_19_1 ^ (P_19_1 & G[15]) ^ (P_19_1 & P[15] & G_14_1) ^ (P_19_1 & P_15_1 & G[11]) ^ (P_19_1 & P_15_1 & P[11] & G_10_1);//depth2
 assign G_23_2 = G_23_1 ^ (P_23_1 & temp2); //Depth3 
 assign P_23_2 = (P_23_1 & P_19_1 & P_15_1 & P_11_1);//Depth2
	
 assign temp3 = G_23_1 ^ (P_23_1 & G[19]) ^ (P_23_1 & P[19] & G_18_1) ^ (P_23_1 & P_19_1 & G[15]) ^ (P_23_1 & P_19_1 & P[15] & G_14_1);//depth2
 assign G_27_2 = G_27_1 ^ (P_27_1 & temp3); //Depth3
 assign P_27_2 = (P_27_1 & P_23_1 & P_19_1 & P_15_1);//Depth2
 
 assign temp4 = G_27_1 ^ (P_27_1 & G[23]) ^ (P_27_1 & P[23] & G_22_1) ^ (P_27_1 & P_23_1 & G[19]) ^ (P_27_1 & P_23_1 & P[19] & G_18_1);//depth2
 assign G_31_2 = G_31_1 ^ (P_31_1 & temp4); //Depth3
 assign P_31_2 = (P_31_1 & P_27_1 & P_23_1 & P_19_1);//Depth2
 //---------------------------------------------------------------------------------------------------------------------
 assign G_19_3 = G_19_2 ^ (P_19_2 & G_3_1);//Depth3
 assign wx[20] = G_19_3 ^ P[20];
 assign G_23_3 = G_23_2 ^ (P_23_2 & G_7_2);//Depth3
 assign wx[24] = G_23_3 ^ P[24];
 assign G_27_3 = G_27_2 ^ (P_27_2 & G_11_2);//Depth3
 assign wx[28] = G_27_3 ^ P[28];
 //---------------------------------------------------------------------------------------------------------------------

 assign G_4_4 = G[4] ^ (P[4] & G_3_1);//Depth3
 assign wx[5] = G_4_4 ^ P[5];
 assign G_5_4 = G_5_1 ^ (P_5_1 & G_3_1);//Depth3
 assign wx[6] = G_5_4 ^ P[6];
 assign G_6_4 = G_6_1 ^ (P_6_1 & G_3_1);//Depth3
 assign wx[7] = G_6_4 ^ P[7];
 
 assign G_8_4 = G[8] ^ (P[8] & G_7_2);//Depth3
 assign wx[9] = G_8_4 ^ P[9];
 assign G_9_4 = G_9_1 ^ (P_9_1 & G_7_2);//Depth3
 assign wx[10] = G_9_4 ^ P[10];
 assign G_10_4= G_10_1 ^ (P_10_1 & G_7_2);//Depth3
 assign wx[11] = G_10_4 ^ P[11];
 
 assign G_12_4= G[12] ^ (P[12] & G_11_2);//Depth3
 assign wx[13] = G_12_4 ^ P[13];

 assign G_13_4= G_13_1 ^ (P_13_1 & G_11_2);//Depth3
 assign wx[14] = G_13_4 ^ P[14];

 assign G_14_4= G_14_1 ^ (P_14_1 & G_11_2);//Depth3
 assign wx[15] = G_14_4 ^ P[15];

 assign G_16_4= G[16] ^ (P[16] & G_15_1) ^ (P[16] & P_15_1 & G_11_2);//Depth3
 assign wx[17] = G_16_4 ^ P[17];

 assign G_17_4= G_17_1 ^ (P_17_1 & G_15_1) ^ (P_17_1 & P_15_1 & G_11_2);//Depth3
 assign wx[18] = G_17_4 ^ P[18];

 assign G_18_4= G_18_1 ^ (P_18_1 & G_15_1) ^ (P_18_1 & P_15_1 & G_11_2);//Depth3
 assign wx[19] = G_18_4 ^ P[19];

 assign G_20_4= G[20]  ^ (P[20] & G_19_1) ^ (P[20] & P_19_1 & temp1) ^ (P[20] & P_19_2 & G_3_1);//Depth3
 assign wx[21] = G_20_4 ^ P[21];

 assign G_21_4= G_21_1 ^ (P_21_1 & G_19_1) ^ (P_21_1 & P_19_1 & temp1) ^ (P_21_1 & P_19_2 & G_3_1);//Depth3
 assign wx[22] = G_21_4 ^ P[22];

 assign G_22_4= G_22_1 ^ (P_22_1 & G_19_1) ^ (P_22_1 & P_19_1 & temp1) ^ (P_22_1 & P_19_2 & G_3_1);//Depth3
 assign wx[23] = G_22_4 ^ P[23];


 assign G_24_4= G[24] ^ (P[24] & G_23_1) ^ (P[24] & P_23_1 & temp2) ^ (P[24] & P_23_2 & G_7_2);//Depth3
 assign wx[25] = G_24_4 ^ P[25];

 assign	G_25_4= G_25_1^ (P_25_1 & G_23_1) ^(P_25_1 & P_23_1 & temp2) ^ (P_25_1 & P_23_2 & G_7_2);//Depth3
 assign wx[26] = G_25_4 ^ P[26];

 assign	G_26_4= G_26_1^ (P_26_1 & G_23_1) ^(P_26_1 & P_23_1 & temp2) ^ (P_26_1 & P_23_2 & G_7_2);//Depth3
 assign wx[27] = G_26_4 ^ P[27];

 
 assign G_28_4= G[28] ^ (P[28] & G_27_1) ^(P[28] & P_27_1 & temp3) ^ (P[28] & P_27_2 & G_11_2);//Depth3
 assign wx[29] = G_28_4 ^ P[29];

 assign G_29_4= G_29_1^ (P_29_1& G_27_1) ^(P_29_1 & P_27_1 & temp3) ^ (P_29_1 & P_27_2 & G_11_2);//Depth3
 assign wx[30] = G_29_4 ^ P[30];

 assign G_30_4= G_30_1^ (P_30_1& G_27_1) ^(P_30_1 & P_27_1 & temp3) ^ (P_30_1 & P_27_2 & G_11_2);//Depth3
 assign wx[31] = G_30_4 ^ P[31];
///////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule



