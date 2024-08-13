module shift_right_logic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {1'b0, a[7:1]} :
					 (b == 8'd2) ? {2'b0, a[7:2]} :
					 (b == 8'd3) ? {3'b0, a[7:3]} :
					 (b == 8'd4) ? {4'b0, a[7:4]} :
					 (b == 8'd5) ? {5'b0, a[7:5]} :
					 (b == 8'd6) ? {6'b0, a[7:6]} : 
					 (b == 8'd7) ? {7'b0, a[7]} : 8'b0;
endmodule