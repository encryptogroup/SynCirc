module MUX64 (x_a,x_b,x_s,wx);
  input  [63:0] x_a, x_b;
  input x_s;
  output [63:0] wx;
  
  genvar i;
  generate
	for (i=0;i<64;i=i+1)
	begin:FIN64
		assign wx[i]=(((x_a[i]^x_b[i])&x_s)^x_a[i]);
	end
  endgenerate
  
endmodule



