module sram8T(input D, input RE, input WE, output D_out);
supply1 VDD;
supply0 GND;
wire Q, Q_bar;
wire a, b, c, d;	

nmos n1(Q, D, WE);
nmos n2(Q_bar, (~D), WE);

assign a = (WE) ? Q : d;
assign c = (WE) ? Q_bar : b;

pmos p1(b, VDD, a);
nmos n3(b, GND, a);

pmos p2(d, VDD, c);
nmos n4(d, GND, c);

assign D_out = (RE) ? ~(RE & b) : 1'bz;
endmodule