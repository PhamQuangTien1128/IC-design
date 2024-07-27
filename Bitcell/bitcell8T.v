//WE: Write Enable; RE: Read Enable; RBL: Read Bit Line
module bitcell8T(input WE, input RE, input D, output RBL);
wire a, b, c, d;
assign a = (WE) ? D : d;
assign b = ~a;
assign c = (WE) ? (~D) : b;
assign d = ~c;
assign RBL = (RE) ? (~RE & b) : 1'bz;
endmodule
