module EXT32 (imm16, ExtOp, imm32);
//1符号0无符号拓展
input [15:0] imm16;
input ExtOp;
output reg[31:0]imm32;
always@(*)
  begin
  imm32[15:0]<= imm16;
  if(~ExtOp || ~imm16[15])
    imm32[31:16] <= 0;
  else
    imm32[31:16] <= 16'b1111111111111111;
  end
endmodule