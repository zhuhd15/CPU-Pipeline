module CPU(reset, clk, switch, led, digi, tx_data, rx_data, rx_status, tx_status, tx_en);
	input reset, clk;
	input [7:0] switch;
	output wire[7:0] led;
	output wire[11:0] digi;		
	input [7:0] rx_data;
	input rx_status, tx_status;
	output wire [7:0] tx_data;
	output wire  tx_en;
	
	//PC+4 var
	reg [31:0] PC;
	wire [31:0] PCplus4;
	wire [31:0] PCnext;
	wire [31:0] ConBA, DATAbusA;
	//part of Instruct
	wire [25:0] JT;
	wire [15:0] imm16;
	wire [4:0] shamt, Rd, Rt, Rs;
	//Control signal
	wire IRQ;
	wire [2:0] PCSrc;	
	wire [1:0] RegDst;
	wire RegWr;
	wire ALUSrc1;
	wire ALUSrc2;	
	wire [5:0] ALUFun;
	wire sign;
	wire MemWr;
	wire MemRd;
	wire [1:0] MemtoReg;
	wire ExtOp;
	wire LUOp;
	wire PC31;
	//ALU var
	wire [31:0] calA, calB, ALUOut;
	//PC+4保证PC[31]不变
	assign PCplus4[31] = PC[31];
	assign PCplus4[30:0] = PC[30:0] + 31'd4;
	assign PC31 = PC[31];
	
	always @(negedge reset or posedge clk)
		if (~reset)
			PC <= 32'h00000000;
		else
			PC <= PCnext;
	PCnext_MUX pcnm (PCSrc, ALUOut, PCplus4, ConBA, JT, DATAbusA, PCnext);
	
	//InstructionMemorg
	wire [31:0] Instruct;
	InstructMem im (PC, Instruct);

	assign JT = Instruct[25:0];
	assign imm16 = Instruct[15:0];
	assign shamt = Instruct[10:6];
	assign Rd = Instruct[15:11];
	assign Rt = Instruct[20:16];
	assign Rs = Instruct[25:21];
	
	Control ctrl (IRQ, Instruct[31:26], Instruct[5:0], PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2, ALUFun, sign, MemWr, MemRd, MemtoReg, ExtOp, LUOp, PC31);

	wire [4:0]AddrC;
	AddrC_Mux addrcm(RegDst, Rt, Rd, AddrC);
	
	wire [31:0]DataBusB, DataBusC;
	RegFile rf (reset, clk, Rs, Rt, AddrC, RegWr, DataBusC, DATAbusA, DataBusB);
	
	//ALU
	wire [31:0] imm32_1, imm32_2;
	EXT32 ext32(imm16, ExtOp, imm32_1);
	Mux2_32b m2321(imm32_1, {imm16,16'd0}, LUOp, imm32_2);
	Mux2_32b m2322(DataBusB, imm32_2, ALUSrc2, calB);
	Mux2_32b m2323(DATAbusA, {27'd0,shamt}, ALUSrc1, calA);
	ALU alu(calA, calB, ALUFun, sign, ALUOut);
	
	assign ConBA = PCplus4 + {imm32_1[29:0],2'b00};
	
	wire [31:0] RdData1, RdData2, RdData;
	RAM ram (reset, clk, DataBusB, MemRd, MemWr, ALUOut, RdData1);
	Peripheral pp (reset, clk, MemRd, MemWr, ALUOut, DataBusB, RdData2, led, switch, digi, IRQ, tx_data, rx_data, rx_status, tx_status, tx_en);
	
/*	解决异常跳指令的临时版本
	wire PCp4m4;
	RdData_Mux ram_pp(RdData1, RdData2, ALUOut, RdData);
	PCplus4minus4 PCpm(IRQ, PC31, PCplus4, PCp4m4);
	Mux3_32b m332(ALUOut, RdData, PCp4m4, MemtoReg, DataBusC);
*/
//	写寄存器改为四路输入，增加PC
	RdData_Mux ram_pp(RdData1, RdData2, ALUOut, RdData);
	Mux4_32b m432(ALUOut, RdData, PCplus4, PC, MemtoReg, DataBusC);

endmodule
	
	
	
module EXT32 (imm16, ExtOp, imm32);
//1符号0无符号拓展
input [15:0] imm16;
input ExtOp;
output reg[31:0]imm32;
always@(*)
  begin
  imm32[15:0] <= imm16;
  if(~ExtOp || ~imm16[15])
    imm32[31:16] <= 0;
  else
    imm32[31:16] <= 16'b1111111111111111;
  end
endmodule


module Mux2_5b(num_A,num_B,sel_signal,result);
  input [4:0]num_A;
  input [4:0]num_B;
  input sel_signal;
  output reg [4:0]result;
  always@(*)
  if(sel_signal)
    result<=num_B;
  else
    result<=num_A;   
endmodule

	
module Mux2_32b(num_A,num_B,sel_signal,result);
//0-A, 1-B
  input [31:0]num_A;
  input [31:0]num_B;
  input sel_signal;
  output reg [31:0]result;
  always@(*)
  if(sel_signal)
    result<=num_B;
  else
    result<=num_A;
endmodule

/*
module Mux3_32b(num_A,num_B,num_C,sel_signal,result);
//0-A, 1-B
  input [31:0]num_A, num_B, num_C;
  input [1:0]sel_signal;
  output reg [31:0]result;
  always@(*)
  case(sel_signal)
    0: result<=num_A;
	1: result<=num_B;
	default: result<=num_C;
  endcase
endmodule
*/
module Mux4_32b(num_A,num_B,num_C,num_D,sel_signal,result);
//0-A, 1-B
  input [31:0]num_A, num_B, num_C, num_D;
  input [1:0]sel_signal;
  output reg [31:0]result;
  always@(*)
  case(sel_signal)
    0: result<=num_A;
	1: result<=num_B;
	2: result<=num_C;
	3: result<=num_D;
  endcase
endmodule


	
module RdData_Mux(RdData1, RdData2, ALUOut, RdData);
input [31:0] RdData1, RdData2, ALUOut;
output reg[31:0] RdData;
always@(*)
  if(ALUOut < 32'h40000000)
    RdData <= RdData1;
  else
    RdData <= RdData2;
endmodule

/*
module PCplus4minus4(IRQ, PC31, in, out);
input IRQ, PC31;
input [31:0] in;
output reg [31:0] out;
always @(*)
  if(IRQ == 1 & !PC31)
	out <= (in-4);
  else
    out <= in;
endmodule
*/



