module rotate_left(input [7:0] a, input [2:0] b, output [7:0] r);
assign r[7:0] = (b == 3'd0) ? a :
					 (b == 3'd1) ? {a[6:0], a[7]} :
			       (b == 3'd2) ? {a[5:0], a[7:6]} :
			       (b == 3'd3) ? {a[4:0], a[7:5]} :
			       (b == 3'd4) ? {a[3:0], a[7:4]} :
			       (b == 3'd5) ? {a[2:0], a[7:3]} :
			       (b == 3'd6) ? {a[1:0], a[7:2]} : {a[0], a[7:1]};
endmodule