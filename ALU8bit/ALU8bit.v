//clk: clock, OF: Overflow, c0: carry_in0
//flag: OF, zero, slt(set on less than)
module ALU8bit(input clk, input [3:0] Op,
					input [7:0] a, input [7:0] b,
					output reg [7:0] result, output reg [15:0] product,
					output OF, output zero, output slt);

wire [7:0] invResult, andResult, orResult; 
wire [7:0] sll, srl, sla, sra, rl, rr;
// sll: shift left logic, srl: shift right logic, sla: shift left arithmetic, sra: shift right arithmetic, rl: rotate left, rr: rotate right
wire [7:0] arithmetic; wire [15:0] netProduct;
wire Binv, c0, CarryOut;

assign Binv = (Op == 4'b1010) ? 1'b1 : 1'b0;
assign c0 = (Op == 4'b1010) ? 1'b1 : 1'b0;

//Inverter
assign invResult = ~a;

//AND
assign andResult = a & b;

//OR
assign orResult = a | b;

//Shift Left Logic
shift_left_logic SLL(.a(a), .b(b), .r(sll));

//Shift Right Logic
shift_right_logic SRL(.a(a), .b(b), .r(srl));

//Shift Left Arithmetic
shift_left_arithmetic SLA(.a(a), .b(b), .r(sla));

//Shift Right Arithmetic
shift_right_arithmetic SRA(.a(a), .b(b), .r(sra));

//Rotate Left
rotate_left RL(.a(a), .b(b[2:0]), .r(rl));

//Rotate Right
rotate_right RR(.a(a), .b(b[2:0]), .r(rr));

//Arithmetic
adder8bit A80(.a(a), .b(b), .c0(c0), .Binv(Binv), .Sum(arithmetic), .Carry(CarryOut));

//Multiply
Multiply M0(.a_in(a), .b_in(b), .product(netProduct));

//Overflow Flag
Overflow OV(.Binv(Binv), .c0(c0), .a(a[7]), .b(b[7]), .CarryOut(CarryOut), .OF(OF));

//Zero Flag
assign zero = ((result == 8'b0) && (!OF)) ? 1'b1 : 1'b0;

//Set-on-less-than Flag
assign slt = result[7] & Binv & c0 & (~OF);

always @(posedge clk) begin
	case(Op)
		4'b0000:begin //inverter
			result <= invResult;
			product <= 16'b0;
		end
		4'b0001:begin //AND bitwise
			result <= andResult;
			product <= 16'b0;
		end
		4'b0010:begin //OR bitwise
			result <= orResult;
			product <= 16'b0;
		end
		4'b0011:begin //shift left logic
			result <= sll;
			product <= 16'b0;
		end
		4'b0100:begin //shift right logic
			result <= srl;
			product <= 16'b0;
		end
		4'b0101:begin //shift left arithmetic
			result <= sla;
			product <= 16'b0;
		end
		4'b0110:begin //shift right arithmetic
			result <= sra;
			product <= 16'b0;
		end
		4'b0111:begin //Rotate left
			result <= rl;
			product <= 16'b0;
		end
		4'b1000:begin //Rotate right
			result <= rr;
			product <= 16'b0;
		end
		4'b1001:begin //add
			result <= arithmetic;
			product <= 16'b0;
		end
		4'b1010:begin //sub
			result <= arithmetic;
			product <= 16'b0;
		end
		4'b1011:begin //multiply
			product <= netProduct;
			result <= 8'b0;
		end
		default:begin //set zero
			result <= 8'b0;
			product <= 16'b0;
		end
	endcase
end
endmodule

module Overflow(input Binv, input c0, input a, input b, input CarryOut, output OF);
wire a1, b1, Binv1, c01;
assign a1 = ~a; assign b1 = ~b; assign Binv1 = ~Binv; assign c01 = ~c0;
assign OF = CarryOut & ((a1 & b1 & c01 & Binv1) | (a1 & b & c0 & Binv) | (a & b & c01 & Binv1) | (a & b1 & c0 & Binv));
endmodule

module shift_left_logic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {a[6:0], 1'b0} :
					 (b == 8'd2) ? {a[5:0], 2'b0} :
					 (b == 8'd3) ? {a[4:0], 3'b0} :
					 (b == 8'd4) ? {a[3:0], 4'b0} :
					 (b == 8'd5) ? {a[2:0], 5'b0} :
					 (b == 8'd6) ? {a[1:0], 6'b0} : 
					 (b == 8'd7) ? {a[0], 7'b0} : 8'b0;
endmodule

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

module shift_left_arithmetic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {a[7], a[5:0], 1'b0} :
					 (b == 8'd2) ? {a[7], a[4:0], 2'b0} :
					 (b == 8'd3) ? {a[7], a[3:0], 3'b0} :
					 (b == 8'd4) ? {a[7], a[2:0], 4'b0} :
					 (b == 8'd5) ? {a[7], a[1:0], 5'b0} :
					 (b == 8'd6) ? {a[7], a[0], 6'b0} : {a[7], 7'b0};
endmodule

module shift_right_arithmetic(input [7:0] a, input [7:0] b, output [7:0] r);
assign r[7:0] = (b == 8'd0) ? a : 
					 (b == 8'd1) ? {a[7], a[7:1]} :
					 (b == 8'd2) ? {a[7], a[7], a[7:2]} :
					 (b == 8'd3) ? {a[7], a[7], a[7], a[7:3]} :
					 (b == 8'd4) ? {a[7], a[7], a[7], a[7], a[7:4]} :
					 (b == 8'd5) ? {a[7], a[7], a[7], a[7], a[7], a[7:5]} :
					 (b == 8'd6) ? {a[7], a[7], a[7], a[7], a[7], a[7], a[7:6]} : {a[7], a[7], a[7], a[7], a[7], a[7], a[7], a[7]};
endmodule

module rotate_left(input [7:0] a, input [2:0] b, output [7:0] r);
assign r[7:0] = (b == 3'd0) ? a :
					 (b == 3'd1) ? {a[6:0], a[7]} :
			       (b == 3'd2) ? {a[5:0], a[7:6]} :
			       (b == 3'd3) ? {a[4:0], a[7:5]} :
			       (b == 3'd4) ? {a[3:0], a[7:4]} :
			       (b == 3'd5) ? {a[2:0], a[7:3]} :
			       (b == 3'd6) ? {a[1:0], a[7:2]} : {a[0], a[7:1]};
endmodule

module rotate_right(input [7:0] a, input [2:0] b, output [7:0] r);
assign r[7:0] = (b == 3'd0) ? a :
					 (b == 3'd1) ? {a[0], a[7:1]} :
					 (b == 3'd2) ? {a[1:0], a[7:2]} :
					 (b == 3'd3) ? {a[2:0], a[7:3]} :
					 (b == 3'd4) ? {a[3:0], a[7:4]} :
					 (b == 3'd5) ? {a[4:0], a[7:5]} :
					 (b == 3'd6) ? {a[5:0], a[7:6]} : {a[6:0], a[7]};
endmodule