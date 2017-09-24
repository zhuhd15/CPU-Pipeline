module PCnext_MUX(PCSrc, ALUOut, PCplus4, ConBA, JT, DATAbusA, PCnext);
input ALUOut;
input [2:0]PCSrc;
input [31:0]PCplus4, ConBA, DATAbusA;
input [25:0]JT;
output reg[31:0]PCnext;

localparam ILLOP = 32'h80000004;	//中断
localparam XADR = 32'h80000008;	//异常

wire [31:0]temp;
ConBA_MUX cm(ConBA, PCplus4, ALUOut, temp);

always@(*)
case(PCSrc)
  0: PCnext<=PCplus4;
  1: PCnext<=temp;
  2: 
    begin
	  PCnext[31:28] <= PCplus4[31:28];
	  PCnext[27:2] <= JT;
	  PCnext[1:0] <= 2'b00;
	end
  3: PCnext<=DATAbusA;
  4: PCnext<=ILLOP;
  5: PCnext<=XADR;
  default: PCnext<=PCplus4;
endcase
endmodule


module ConBA_MUX(ConBA, PCplus4, ALUOut, out);
input ALUOut;
input [31:0]ConBA, PCplus4;
output reg[31:0]out;
always@(*)
case(ALUOut)
  0: out<=PCplus4;
  1: out<=ConBA;
endcase
endmodule