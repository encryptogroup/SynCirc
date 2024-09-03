module MUX32 (x_a,x_b,x_s,wx);
  input  [31:0] x_a, x_b;
  input x_s;
  output [31:0] wx;
  
  genvar i;
  generate
	for (i=0;i<32;i=i+1)
	begin:FIN32
		assign wx[i]=(((x_a[i]^x_b[i])&x_s)^x_a[i]);
	end
  endgenerate
  
endmodule



