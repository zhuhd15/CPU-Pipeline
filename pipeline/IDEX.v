module IDEX_Register
(speccial_hazard,
Rs_out,
Rt_out,
Rd_out,
Rs_in,
Rt_in,
Rd_in,
ID_EX_PCP4_in,
ID_EX_PCP4_out,
ID_EX_SIGN_1bit_out,
ID_EX_SIGN_1bit_in,
shamt_out,
ALUFun_out,
ReadData1_out,
ReadData2_out,
SgnExtend_out,
ExtOp_out,
ALUSrc1_out,
ALUSrc2_out,
RegDst_out,
MemRd_out,
MemWr_out,
MemtoReg_out,
RegWr_out,
shamt_in,
ALUFun_in,
ReadData1_in,
ReadData2_in,
SgnExtend_in,
ExtOp_in,
ALUSrc1_in,
ALUSrc2_in,
RegDst_in,
MemRd_in,
MemWr_in,
MemtoReg_in,
RegWr_in,
clk,
reset,
hazard);

  input [31:0]ID_EX_PCP4_in;
  input [4:0]Rs_in;
  input [4:0]Rt_in;
  input [4:0]Rd_in;
  output reg [31:0]ID_EX_PCP4_out;
  input ID_EX_SIGN_1bit_in;
  input [31:0]ReadData1_in;
  input [31:0]ReadData2_in;
  input [31:0]SgnExtend_in;
  input [4:0]shamt_in;
  input [5:0]ALUFun_in;
  input ExtOp_in;
  input ALUSrc1_in;
  input ALUSrc2_in;
  input [1:0]RegDst_in;
  input MemWr_in;
  input MemRd_in;
  input [1:0]MemtoReg_in;
  input RegWr_in;
  
  input hazard;
  input clk;
  input reset;
  input speccial_hazard;
  
  output reg [4:0]Rs_out;
  output reg [4:0]Rt_out;
  output reg [4:0]Rd_out;
  output reg ID_EX_SIGN_1bit_out;
  output reg [31:0]ReadData1_out;
  output reg [31:0]ReadData2_out;
  output reg [31:0]SgnExtend_out;
  output reg [4:0]shamt_out;
  output reg [5:0]ALUFun_out;
  output reg ExtOp_out;
  output reg ALUSrc1_out;
  output reg ALUSrc2_out;
  output reg [1:0]RegDst_out;
  output reg MemWr_out;
  output reg MemRd_out;
  output reg [1:0] MemtoReg_out;
  output reg RegWr_out;
  
  always@(negedge reset or posedge clk)
  begin
    if(!reset)
      begin
		Rs_out=5'b0;
		Rt_out=5'b0;
		Rd_out=5'b0;
        ID_EX_PCP4_out=32'b0;
        ReadData1_out=32'b0;
        ReadData2_out=32'b0;
        SgnExtend_out=32'b0;
        shamt_out=5'b0;
        ALUFun_out=6'b0;
        ExtOp_out=0;
        ALUSrc1_out=0;
        ALUSrc2_out=0;
        RegDst_out=2'b0;
        MemWr_out=0;
        MemRd_out=0;
        MemtoReg_out=2'b0;
        RegWr_out=0;
        ID_EX_SIGN_1bit_out=1'b0;
      end
    else
		if(hazard||speccial_hazard)
		begin
		Rs_out=5'b0;
		Rt_out=5'b0;
		Rd_out=5'b0;
        ID_EX_PCP4_out=32'b0;
        ReadData1_out=32'b0;
        ReadData2_out=32'b0;
        SgnExtend_out=32'b0;
        shamt_out=5'b0;
        ALUFun_out=6'b0;
        ExtOp_out=0;
        ALUSrc1_out=0;
        ALUSrc2_out=0;
        RegDst_out=2'b0;
        MemWr_out=0;
        MemRd_out=0;
        MemtoReg_out=2'b0;
        RegWr_out=0;
        ID_EX_SIGN_1bit_out=1'b0;
      end
		else
      begin
		Rs_out=Rs_in;
		Rt_out=Rt_in;
		Rd_out=Rd_in;
      ID_EX_PCP4_out=ID_EX_PCP4_in;
        ID_EX_SIGN_1bit_out=ID_EX_SIGN_1bit_in;
        ReadData1_out=ReadData1_in;
        ReadData2_out=ReadData2_in;
        SgnExtend_out=SgnExtend_in;
        shamt_out=shamt_in;
        ALUFun_out=ALUFun_in;
        ExtOp_out=ExtOp_in;
        ALUSrc1_out=ALUSrc1_in;
        ALUSrc2_out=ALUSrc2_in;
        RegDst_out=RegDst_in;
        MemWr_out=MemWr_in;
        MemRd_out=MemRd_in;
        RegWr_out=RegWr_in;
        MemtoReg_out=MemtoReg_in;
      end
  end
endmodule