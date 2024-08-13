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