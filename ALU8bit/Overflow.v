module Overflow(input Binv, input c0, input a, input b, input CarryOut, output OF);
wire a1, b1, Binv1, c01;
assign a1 = ~a; assign b1 = ~b; assign Binv1 = ~Binv; assign c01 = ~c0;
assign OF = CarryOut & ((a1 & b1 & c01 & Binv1) | (a1 & b & c0 & Binv) | (a & b & c01 & Binv1) | (a & b1 & c0 & Binv));
endmodule