module bitcell6T(input D, input En, output D_out);
wire a, b, c, d;
assign a = (En) ? D : d;
assign b = ~a;
assign c = (En) ? (~D) : b;
assign d = ~c;
assign D_out = b;
endmodule
