module bitcell8T(input WriteEn, input ReadEn, inout D, inout D_bar);
wire [1:0] D1;
wire [1:0] D2;

memcell U0(.D1(D1[0]), .D2(D1[1]));
memcell U1(.D1(D2[0]), .D2(D2[1]));

assign D1[0] = (ReadEn) ? D : 1'bz;
assign D = (WriteEn) ? D2[0] : 1'bz;
assign D2[1] = (ReadEn) ? D_bar : 1'bz;
assign D_bar = (WriteEn) ? D1[1] : 1'bz;
endmodule

module memcell(inout D1, inout D2);
wire a, b, c, d;

assign b = ~a;
assign c = b;
assign d = ~c;
assign a = d;

assign a = D1;
assign D2 = b;
endmodule