module shift_right_arithmetic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {a[7], a[7:1]} :
					 (b == 8'd2) ? {a[7], a[7], a[7:2]} :
					 (b == 8'd3) ? {a[7], a[7], a[7], a[7:3]} :
					 (b == 8'd4) ? {a[7], a[7], a[7], a[7], a[7:4]} :
					 (b == 8'd5) ? {a[7], a[7], a[7], a[7], a[7], a[7:5]} :
					 (b == 8'd6) ? {a[7], a[7], a[7], a[7], a[7], a[7], a[7:6]} : {a[7], a[7], a[7], a[7], a[7], a[7], a[7], a[7]};
endmodule