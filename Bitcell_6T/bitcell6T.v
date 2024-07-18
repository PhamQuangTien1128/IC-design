module bitcell6T(input D_in, input En, output D_out_bar);
wire C1, C2;
assign C1 = (En) ? D_in : 1'bz;
assign D_out_bar = (En) ? C2 : 1'bz;
memcell U0(.C1(C1), .C2(C2));
endmodule

module memcell(inout C1, inout C2);
wire a, b, c, d;

assign b = ~a;
assign c = b;
assign d = ~c;
assign a = d;

assign a = C1;
assign C2 = b;
endmodule