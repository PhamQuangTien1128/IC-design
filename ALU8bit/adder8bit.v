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

module adder1bit(input a, input b,  
					  input ci,
					  output result);
	assign result = a ^ b ^ ci;
endmodule