module sram6T(input D, input EN, output D_out);
supply1 VDD;
supply0 GND;
wire Q, Q_bar;
wire a, b, c, d;	

nmos n1(Q, D, EN);
nmos n2(Q_bar, (~D), EN);

assign a = (EN) ? Q : d;
assign c = (EN) ? Q_bar : b;

pmos p1(b, VDD, a);
nmos n3(b, GND, a);

pmos p2(d, VDD, c);
nmos n4(d, GND, c);

assign D_out = a;
endmodule
