//OF = Overflow, c0 = carry_in0
//flag: OF, zero, slt(set on less than)
module ALU8bit(input [7:0] a, input [7:0] b,
					input [3:0] Op,
					output reg [7:0] result, output reg [15:0] product,
					output OF,
					output zero, output slt);

wire [7:0] invResult; wire [7:0] andResult; wire [7:0] orResult; 
wire [7:0] arithmetic; wire [15:0] netProduct;
wire Binv;
wire c0;

wire CarryOut;

assign Binv = (Op == 4'b1010) ? 1'b1 : 1'b0;
assign c0 = (Op == 4'b1010) ? 1'b1 : 1'b0;

//Inverter
assign invResult = ~a;

//AND
assign andResult = a & b;

//OR
assign orResult = a | b;

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
always @(a, b, Op) begin
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
		4'b0011:begin //shift right logic 1 bit
			result <= {1'b0, a[7:1]};
			product <= 16'b0;
		end
		4'b0100:begin //shift left logic 1 bit
			result <= {a[6:0], 1'b0};
			product <= 16'b0;
		end
		4'b0101:begin //shift right arithmetic 1 bit
			case(a[7])
				1'b1: result <= {1'b1, a[7:1]};
				1'b0: result <= {1'b0, a[7:1]};
			endcase
			product <= 16'b0;
		end
		4'b0110:begin //shift left arithmetic 1 bit
			case(a[7])
				1'b1: result <= {1'b1, a[5:0], 1'b0};
				1'b0: result <= {a[6:0], 1'b0};
			endcase
			product <= 16'b0;
		end
		4'b0111:begin //Rotate right
			result <= {a[0], a[7:1]};
			product <= 16'b0;
		end
		4'b1000:begin //Rotate left
			result <= {a[6:0], a[7]};
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

module adder8bit(input [7:0] a, input [7:0] b, input c0, input Binv,
					  output [7:0] Sum, output Carry);
wire [1:0] P;
wire [1:0] G;
wire Carry1;
wire Carry2;

adder4bit A40(.a(a[3:0]), .b(b[3:0]), .CI(c0), .Binv(Binv), .result(Sum[3:0]), .P_out(P[0]), .G_out(G[0]));
CarryIn1 C1(.g0(G[0]), .p0(P[0]), .c0(c0), .c1(Carry1));
adder4bit A41(.a(a[7:4]), .b(b[7:4]), .CI(Carry1), .Binv(Binv), .result(Sum[7:4]), .P_out(P[1]), .G_out(G[1]));
CarryIn2 C2(.g(G[1:0]), .p(P[1:0]), .c0(c0), .c2(Carry2));
assign Carry = Carry2;

endmodule

module adder4bit(input [3:0] a, input [3:0] b, input CI, input Binv,
					  output [3:0]result, output P_out, output G_out);

wire [3:0] bInv;					  
wire [3:0] net_g;
wire [3:0] net_p;
wire c1, c2, c3, c4;
wire [3:0] net_result;
wire netP, netG;

assign bInv = (Binv) ? ~b : b;

_generate _G0(.ai(a[0]), .bi(bInv[0]), .gi(net_g[0]));
_generate _G1(.ai(a[1]), .bi(bInv[1]), .gi(net_g[1]));
_generate _G2(.ai(a[2]), .bi(bInv[2]), .gi(net_g[2]));
_generate _G3(.ai(a[3]), .bi(bInv[3]), .gi(net_g[3]));

_propagate _P0(.ai(a[0]), .bi(bInv[0]), .pi(net_p[0]));
_propagate _P1(.ai(a[1]), .bi(bInv[1]), .pi(net_p[1]));
_propagate _P2(.ai(a[2]), .bi(bInv[2]), .pi(net_p[2]));
_propagate _P3(.ai(a[3]), .bi(bInv[3]), .pi(net_p[3]));

CarryIn1 _CI1(.g0(net_g[0]), .p0(net_p[0]), .c0(CI), .c1(c1));
CarryIn2 _CI2(.g(net_g[1:0]), .p(net_p[1:0]), .c0(CI), .c2(c2));
CarryIn3 _CI3(.g(net_g[2:0]), .p(net_p[2:0]), .c0(CI), .c3(c3));

Propagate P0(.p(net_p[3:0]), .P(netP));
Generate G0(.g(net_g[3:0]), .p(net_p[3:0]), .G(netG));

adder1bit A10(.a(a[0]), .b(bInv[0]), .ci(CI), .result(net_result[0]));
adder1bit A11(.a(a[1]), .b(bInv[1]), .ci(c1), .result(net_result[1]));
adder1bit A12(.a(a[2]), .b(bInv[2]), .ci(c2), .result(net_result[2]));
adder1bit A13(.a(a[3]), .b(bInv[3]), .ci(c3), .result(net_result[3]));

assign result = net_result; assign P_out = netP; assign G_out = netG;
endmodule

module _generate(input ai, input bi, output gi);
	assign gi = ai & bi;
endmodule

module _propagate(input ai, input bi, output pi);
	assign pi = ai | bi;
endmodule

module CarryIn1(input g0, input p0, input c0, output c1);
	assign c1 = g0 | (p0 & c0);
endmodule

module CarryIn2(input [1:0] g, input [1:0] p, input c0, output c2);
	assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
endmodule

module CarryIn3(input [2:0] g, input [2:0] p, input c0, output c3);
	assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
endmodule

module CarryIn4(input [3:0] g, input [3:0] p, input c0, output c4);
	assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);
endmodule

module Propagate(input [3:0] p, output P);
	assign P = p[3] & p[2] & p[1] & p[0];
endmodule

module Generate(input [3:0] g, input [3:0] p, output G);
	assign G = g[3] | (p[2] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

module Multiply(input [7:0] a_in, input [7:0] b_in, output [15:0] product);

wire [7:0] net00, net01, net10, net11, net20, net21, net30, net31;
wire [7:0] net40, net41, net50, net51, net60, net61, net70, net71;


wire check;
assign check = a_in[7] ^ b_in[7];

wire [7:0] a1, b1; //One's complement
wire [7:0] a2, b2; //Two's complement
wire check_a, check_b;
wire [7:0] a, b;

assign a1 = ~a_in;
assign b1 = ~b_in;
assign check_a = a_in[7];
assign check_b = b_in[7];

//Two's Complement of inputs
adder8bit IN_TC0(.a(a1), .b(8'b00000001), .c0(1'b0), .Binv(1'b0), .Sum(a2), .Carry());
adder8bit IN_TC1(.a(b1), .b(8'b00000001), .c0(1'b0), .Binv(1'b0), .Sum(b2), .Carry());

assign a = (check_a) ? (a2) : a_in;
assign b = (check_b) ? (b2) : b_in;

assign net00[0] = a[0] & b[0];
assign net00[1] = a[1] & b[0];
assign net00[2] = a[2] & b[0];
assign net00[3] = a[3] & b[0];
assign net00[4] = a[4] & b[0];
assign net00[5] = a[5] & b[0];
assign net00[6] = a[6] & b[0];
assign net00[7] = a[7] & b[0];

assign net01[0] = a[7] & b[1];
assign net01[1] = a[7] & b[2];
assign net01[2] = a[7] & b[3];
assign net01[3] = a[7] & b[4];
assign net01[4] = a[7] & b[5];
assign net01[5] = a[7] & b[6];
assign net01[6] = a[7] & b[7];
assign net01[7] = 1'b0;

//---------------------------------------------------//

assign net10[0] = 1'b0;
assign net10[1] = a[0] & b[1];
assign net10[2] = a[1] & b[1];
assign net10[3] = a[2] & b[1];
assign net10[4] = a[3] & b[1];
assign net10[5] = a[4] & b[1];
assign net10[6] = a[5] & b[1];
assign net10[7] = a[6] & b[1];

assign net11[0] = a[6] & b[2];
assign net11[1] = a[6] & b[3];
assign net11[2] = a[6] & b[4];
assign net11[3] = a[6] & b[5];
assign net11[4] = a[6] & b[6];
assign net11[5] = a[6] & b[7];
assign net11[6] = 1'b0;
assign net11[7] = 1'b0;

//---------------------------------------------------//

assign net20[0] = 1'b0;
assign net20[1] = 1'b0;
assign net20[2] = a[0] & b[2];
assign net20[3] = a[1] & b[2];
assign net20[4] = a[2] & b[2];
assign net20[5] = a[3] & b[2];
assign net20[6] = a[4] & b[2];
assign net20[7] = a[5] & b[2];

assign net21[0] = a[5] & b[3];
assign net21[1] = a[5] & b[4];
assign net21[2] = a[5] & b[5];
assign net21[3] = a[5] & b[6];
assign net21[4] = a[5] & b[7];
assign net21[5] = 1'b0;
assign net21[6] = 1'b0;
assign net21[7] = 1'b0;

//-------------------------------------------------------//

assign net30[0] = 1'b0;
assign net30[1] = 1'b0;
assign net30[2] = 1'b0;
assign net30[3] = a[0] & b[3];
assign net30[4] = a[1] & b[3];
assign net30[5] = a[2] & b[3];
assign net30[6] = a[3] & b[3];
assign net30[7] = a[4] & b[3];

assign net31[0] = a[4] & b[4];
assign net31[1] = a[4] & b[5];
assign net31[2] = a[4] & b[6];
assign net31[3] = a[4] & b[7];
assign net31[4] = 1'b0;
assign net31[5] = 1'b0;
assign net31[6] = 1'b0;
assign net31[7] = 1'b0;

//-------------------------------------------------//

assign net40[0] = 1'b0;
assign net40[1] = 1'b0;
assign net40[2] = 1'b0;
assign net40[3] = 1'b0;
assign net40[4] = a[0] & b[4];
assign net40[5] = a[1] & b[4];
assign net40[6] = a[2] & b[4];
assign net40[7] = a[3] & b[4];

assign net41[0] = a[3] & b[5];
assign net41[1] = a[3] & b[6];
assign net41[2] = a[3] & b[7];
assign net41[3] = 1'b0;
assign net41[4] = 1'b0;
assign net41[5] = 1'b0;
assign net41[6] = 1'b0;
assign net41[7] = 1'b0;

//-----------------------------------------------------//

assign net50[0] = 1'b0;
assign net50[1] = 1'b0;
assign net50[2] = 1'b0;
assign net50[3] = 1'b0;
assign net50[4] = 1'b0;
assign net50[5] = a[0] & b[5];
assign net50[6] = a[1] & b[5];
assign net50[7] = a[2] & b[5];

assign net51[0] = a[2] & b[6];
assign net51[1] = a[2] & b[7];
assign net51[2] = 1'b0;
assign net51[3] = 1'b0;
assign net51[4] = 1'b0;
assign net51[5] = 1'b0;
assign net51[6] = 1'b0;
assign net51[7] = 1'b0;

//------------------------------------------------------//

assign net60[0] = 1'b0;
assign net60[1] = 1'b0;
assign net60[2] = 1'b0;
assign net60[3] = 1'b0;
assign net60[4] = 1'b0;
assign net60[5] = 1'b0;
assign net60[6] = a[0] & b[6];
assign net60[7] = a[1] & b[6];

assign net61[0] = a[1] & b[7];
assign net61[1] = 1'b0;
assign net61[2] = 1'b0;
assign net61[3] = 1'b0;
assign net61[4] = 1'b0;
assign net61[5] = 1'b0;
assign net61[6] = 1'b0;
assign net61[7] = 1'b0;

//--------------------------------------------------------//

assign net70[0] = 1'b0;
assign net70[1] = 1'b0;
assign net70[2] = 1'b0;
assign net70[3] = 1'b0;
assign net70[4] = 1'b0;
assign net70[5] = 1'b0;
assign net70[6] = 1'b0;
assign net70[7] = a[0] & b[7];

assign net71[0] = 1'b0;
assign net71[1] = 1'b0;
assign net71[2] = 1'b0;
assign net71[3] = 1'b0;
assign net71[4] = 1'b0;
assign net71[5] = 1'b0;
assign net71[6] = 1'b0;
assign net71[7] = 1'b0;

wire [7:0] add0Result, add1Result, add2Result, add3Result, add4Result, add5Result, add6Result, add7Result;
wire [7:0] add8Result, add9Result, add10Result, add11Result, add12Result, add13Result;

wire carry0, carry1, carry2, carry3, carry4, carry5, carry6;

adder8bit ADD0(.a(net00), .b(net10), .c0(1'b0), .Binv(1'b0), .Sum(add0Result), .Carry(carry0));
adder8bit ADD1(.a(net20), .b(net30), .c0(1'b0), .Binv(1'b0), .Sum(add1Result), .Carry(carry1));
adder8bit ADD2(.a(net40), .b(net50), .c0(1'b0), .Binv(1'b0), .Sum(add2Result), .Carry(carry2));
adder8bit ADD3(.a(net60), .b(net70), .c0(1'b0), .Binv(1'b0), .Sum(add3Result), .Carry(carry3));

adder8bit ADD4(.a(net01), .b(net11), .c0(carry0), .Binv(1'b0), .Sum(add4Result), .Carry());
adder8bit ADD5(.a(net21), .b(net31), .c0(carry1), .Binv(1'b0), .Sum(add5Result), .Carry());
adder8bit ADD6(.a(net41), .b(net51), .c0(carry2), .Binv(1'b0), .Sum(add6Result), .Carry());
adder8bit ADD7(.a(net61), .b(net71), .c0(carry3), .Binv(1'b0), .Sum(add7Result), .Carry());

adder8bit ADD8(.a(add0Result), .b(add1Result), .c0(1'b0), .Binv(1'b0), .Sum(add8Result), .Carry(carry4));
adder8bit ADD9(.a(add2Result), .b(add3Result), .c0(1'b0), .Binv(1'b0), .Sum(add9Result), .Carry(carry5));

adder8bit ADD10(.a(add4Result), .b(add5Result), .c0(carry4), .Binv(1'b0), .Sum(add10Result), .Carry());
adder8bit ADD11(.a(add6Result), .b(add7Result), .c0(carry5), .Binv(1'b0), .Sum(add11Result), .Carry());

adder8bit ADD12(.a(add8Result), .b(add9Result), .c0(1'b0), .Binv(1'b0), .Sum(add12Result), .Carry(carry6));
adder8bit ADD13(.a(add10Result), .b(add11Result), .c0(carry6), .Binv(1'b0), .Sum(add13Result), .Carry());

wire [7:0] add12Result_1, add12Result_2;
wire [7:0] add13Result_1, add13Result_2;
wire carry7;

//One's Complement of product
assign add12Result_1 = ~add12Result;
assign add13Result_1 = ~add13Result;

//Two's Complement of product
adder8bit OUT_TC0(.a(add12Result_1), .b(8'b00000001), .c0(1'b0), .Binv(1'b0), .Sum(add12Result_2), .Carry(carry7));
adder8bit OUT_TC1(.a(add13Result_1), .b(8'b0), .c0(carry7), .Binv(1'b0), .Sum(add13Result_2), .Carry());

assign product[7:0] = (check) ? add12Result_2 : add12Result;
assign product[15:8] = (check) ? add13Result_2 : add13Result;

//assign product[7:0] = add12Result;
//assign product[15:8] = add13Result;

endmodule

module adder1bit(input a, input b,  
					  input ci,
					  output result);
	assign result = a ^ b ^ ci;
endmodule

module Overflow(input Binv, input c0, input a, input b, input CarryOut, output OF);
wire a1, b1, Binv1, c01;
assign a1 = ~a; assign b1 = ~b; assign Binv1 = ~Binv; assign c01 = ~c0;
assign OF = CarryOut & ((a1 & b1 & c01 & Binv1) | (a1 & b & c0 & Binv) | (a & b & c01 & Binv1) | (a & b1 & c0 & Binv));
endmodule



