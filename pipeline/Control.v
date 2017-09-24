module Control(IRQ, PC31, OpCode, Funct, PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2, ALUFun, sign, MemWr, MemRd, MemtoReg, ExtOp, LUOp, bad_signal);

input IRQ, PC31;
input [5:0]OpCode, Funct;
output RegWr, ALUSrc1, ALUSrc2, sign, MemWr, MemRd, ExtOp, LUOp;
output [2:0]PCSrc;
output [1:0]RegDst, MemtoReg;
output [5:0]ALUFun;
output bad_signal;
//未明确异常、中断操作

assign bad_signal = (PCSrc == 5);

assign PCSrc = 
	(IRQ & !PC31)? 3'b100
	:(OpCode == 6'b100011 || OpCode == 6'b101011
		|| OpCode == 6'b001111
		|| OpCode[5:2] == 4'b0010 || OpCode == 6'b001100
		|| (OpCode == 0 && (Funct == 6'b101010
		|| Funct == 6'b000010 || Funct == 6'b000011 
		|| Funct == 6'b000110 || Funct == 6'b000111 
		|| Funct == 6'b000000 || Funct == 6'b000010
		|| Funct[5:2] == 4'b1000 || Funct[5:2] == 4'b0001)))? 0
	:(OpCode[5:2] == 4'b0001 || OpCode == 1)? 1
	:(OpCode[5:1] == 5'b00001)? 2
	:(OpCode == 6'b0 && Funct[5:1] == 4)? 3
	:5;
assign RegDst = 
	(IRQ& !PC31 || bad_signal)? 2'b11
	:(OpCode == 0 && (Funct == 6'b101010
		|| Funct == 6'b000010 || Funct == 6'b000011 
		|| Funct == 6'b000110 || Funct == 6'b000111 
		|| Funct == 6'b000000 || Funct == 6'b000010
		|| Funct[5:2] == 4'b1000 || Funct[5:2] == 4'b0001))? 0
	:(OpCode == 6'b100011 ||OpCode == 6'b001111
		|| OpCode[5:2] == 4'b0010 || OpCode == 6'b001100)? 1
	:(OpCode == 6'b000011 || (OpCode == 0 && Funct == 6'b001001))? 2
	:3;
assign RegWr = 
	!(IRQ & !PC31 || bad_signal) & (OpCode == 6'b101011 || OpCode[5:2] == 4'b0001
		|| OpCode == 1 || OpCode == 2
		|| (OpCode == 6'b000000 && Funct == 6'b001001) 
		|| (OpCode == 6'b000000 && Funct == 6'b001000))? 1'b0 : 1'b1; 
assign ALUSrc1 = 
	(OpCode == 0 && Funct[5:2] == 0) ? 1'b1 : 1'b0;
assign ALUSrc2 = 
	(OpCode == 6'b100011 || OpCode == 6'b101011|| OpCode == 6'b001111
		|| OpCode[5:2] == 4'b0010 
		|| OpCode == 6'b001100) ? 1'b1 : 1'b0;
assign ALUFun =
	(OpCode == 0 && Funct[5:1] == 5'b10001)? 6'b000001
	:((OpCode == 0 && Funct == 6'b000100) || OpCode == 6'b001100)? 6'b011000
	:(OpCode == 0 && Funct == 6'b000101)? 6'b011110
	:(OpCode == 0 && Funct == 6'b000110)? 6'b010110
	:(OpCode == 0 && Funct == 6'b000111)? 6'b010001
	:(OpCode == 0 && Funct[5:1] == 5'b00100)? 6'b011010	
	:(OpCode == 0 && Funct == 6'b000000)? 6'b100000
	:(OpCode == 0 && Funct == 6'b000010)? 6'b100001
	:(OpCode == 0 && Funct == 6'b000011)? 6'b100011
	:(OpCode == 6'b000100)? 6'b110011
	:(OpCode == 6'b000101)? 6'b110001
	:(OpCode[5:1] == 5'b00101 || (OpCode == 0 && Funct == 6'b101010))? 6'b110101
	:(OpCode == 6'b111101)? 6'b111101
	:(OpCode == 6'b000001)? 6'b111011
	:(OpCode == 6'b000111)? 6'b111111
	:0;
assign sign =
	(OpCode == 6'b001111 || OpCode == 6'b001100
	|| (OpCode == 6'b000000 && (Funct[5:2] == 4'b0001 || Funct == 6'b000000 || Funct == 6'b000010)))? 1'b0 : 1'b1;
assign MemRd = (OpCode == 6'h23)? 1'b1 : 1'b0;
assign MemWr = (OpCode == 6'h2b)? 1'b1 : 1'b0;	
assign MemtoReg[1:0] =
	((IRQ == 1 & !PC31 || bad_signal) || OpCode == 6'h03 || (OpCode == 0 && Funct == 6'h09))? 2'b10
	:(OpCode == 6'h23)? 2'b01
	:(OpCode == 6'b001111
		|| OpCode[5:2] == 4'b0010 || OpCode == 6'b001100
		|| (OpCode == 0 && (Funct == 6'b101010
		|| Funct == 6'b000010 || Funct == 6'b000011 
		|| Funct == 6'b000110 || Funct == 6'b000111 
		|| Funct == 6'b000000 || Funct == 6'b000010
		|| Funct[5:2] == 4'b1000 || Funct[5:2] == 4'b0001)))?2'b00
	:2'b10;
assign ExtOp = (OpCode == 6'h0c )? 1'b0 : 1'b1;
assign LUOp = (OpCode == 6'h0f)? 1'b1 : 1'b0;	
endmodule
