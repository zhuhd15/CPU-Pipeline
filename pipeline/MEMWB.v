module MEMWB_Register
  (MEM_WB_PCP4_in,
MEM_WB_PCP4_out,
Memory_in,
  BusB_in,
  WBAddress_in,
  MemtoReg_in,
  RegWr_in,
  clk,
  reset,
  Memory_out,
  BusB_out,
  WBAddress_out,
  MemtoReg_out,
  RegWr_out
  );
  
  input [31:0]MEM_WB_PCP4_in;
  output reg [31:0]MEM_WB_PCP4_out;
  input [31:0]Memory_in;
  input [31:0]BusB_in;
  input [4:0]WBAddress_in;
  input [1:0]MemtoReg_in;
  input RegWr_in;
  
  input clk;
  input reset;
  
  output reg [31:0]Memory_out;
  output reg [31:0]BusB_out;
  output reg [4:0]WBAddress_out;
  output reg [1:0]MemtoReg_out;
  output reg RegWr_out;
  
  always@(posedge clk or negedge reset)
  begin
    if(!reset)
      begin
      MEM_WB_PCP4_out<=32'b0;
        Memory_out<=32'b0;
        BusB_out<=32'b0;
        WBAddress_out<=5'b0;
        MemtoReg_out<=2'b0;
        RegWr_out<=0;
      end
    else
      begin
      MEM_WB_PCP4_out<=MEM_WB_PCP4_in;
        Memory_out<=Memory_in;
        BusB_out<=BusB_in;
        WBAddress_out<=WBAddress_in;
        MemtoReg_out<=MemtoReg_in;
        RegWr_out<=RegWr_in;
      end
  end
endmodule