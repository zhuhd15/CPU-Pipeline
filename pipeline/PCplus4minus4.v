module PCplus4minus4(IRQ, PC31, in, out, badInstr);

input IRQ, PC31, badInstr;
input [31:0]in;
output [31:0]out;
wire IRQ_trig;

assign IRQ_trig = IRQ == 1 & !PC31;
assign out = IRQ_trig ? (badInstr ? in - 8 : in - 4) : in;
endmodule