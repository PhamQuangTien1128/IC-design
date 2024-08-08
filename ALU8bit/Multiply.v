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
endmodule