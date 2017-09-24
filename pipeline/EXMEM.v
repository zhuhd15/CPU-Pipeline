module EXMEM_Register
(EX_MEM_PCP4_in,
EX_MEM_PCP4_out,
ALUResult_in,
BusB_in,
MemWr_in,
MemtoReg_in,
RegWr_in,
MemRd_in,
clk,
reset,
ALUResult_out,
BusB_out,
MemWr_out,
MemtoReg_out,
MemRd_out,
RegWr_out
);
  input [31:0]EX_MEM_PCP4_in;
  output reg [31:0]EX_MEM_PCP4_out;
  input [31:0]ALUResult_in;
  input [31:0]BusB_in;
  input MemWr_in;
  input [1:0]MemtoReg_in;
  input RegWr_in;
  input MemRd_in;
  
  input clk;
  input reset;
  
  output reg [31:0]ALUResult_out;
  output reg [31:0]BusB_out;
  output reg MemWr_out;
  output reg [1:0]MemtoReg_out;
  output reg RegWr_out;
  output reg MemRd_out;
  
  always@(negedge reset or posedge clk)
  begin
    if(!reset)
      begin
        ALUResult_out<=32'b0;
        BusB_out<=32'b0;
        MemWr_out<=0;
        MemtoReg_out<=2'b0;
        RegWr_out<=0;
        MemRd_out<=0;
        EX_MEM_PCP4_out<=32'b0;
      end
    else
      begin
        ALUResult_out<=ALUResult_in;
        BusB_out<=BusB_in;
        MemWr_out<=MemWr_in;
        MemtoReg_out<=MemtoReg_in;
        RegWr_out<=RegWr_in;
        MemRd_out<=MemRd_in;
        EX_MEM_PCP4_out<=EX_MEM_PCP4_in;
      end
  end
endmodule
        