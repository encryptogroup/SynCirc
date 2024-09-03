module ManhattanDist15 (
	input [14:0] x1, y1, x2, y2,
	output [16:0] dist
);

wire signed [15:0] dist_x12, dist_x21, dist_xabs, dist_y12, dist_y21, dist_yabs;

SUB16 diff_x12 (.x_a(x1), .x_b(x2), .wx(dist_x12));
SUB16 diff_x21 (.x_a(x2), .x_b(x1), .wx(dist_x21));
MUX16 abs_x (.x_a(dist_x12), .x_b(dist_x21), .x_s(dist_x12[15]), .wx(dist_xabs));
SUB16 diff_y12 (.x_a(y1), .x_b(y2), .wx(dist_y12));
SUB16 diff_y21 (.x_a(y2), .x_b(y1), .wx(dist_y21));
MUX16 abs_y (.x_a(dist_y12), .x_b(dist_y21), .x_s(dist_y12[15]), .wx(dist_yabs));
ADD16 t_d (.x_a(dist_xabs), .x_b(dist_yabs), .wx(dist));

endmodule 
