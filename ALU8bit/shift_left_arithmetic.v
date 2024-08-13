module shift_left_arithmetic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {a[7], a[5:0], 1'b0} :
					 (b == 8'd2) ? {a[7], a[4:0], 2'b0} :
					 (b == 8'd3) ? {a[7], a[3:0], 3'b0} :
					 (b == 8'd4) ? {a[7], a[2:0], 4'b0} :
					 (b == 8'd5) ? {a[7], a[1:0], 5'b0} :
					 (b == 8'd6) ? {a[7], a[0], 6'b0} : {a[7], 7'b0};
endmodule