module ForwardUnit
(EX_MEM_RD,
MEM_WB_RD,
ID_EX_RS,
ID_EX_RT,
EX_MEM_RegWrite,
MEM_WB_RegWrite,
Forward_Signal_A,
Forward_Signal_B);
  input [4:0]EX_MEM_RD;
  input [4:0]MEM_WB_RD;
  input [4:0]ID_EX_RS;
  input [4:0]ID_EX_RT;
  input EX_MEM_RegWrite;
  input MEM_WB_RegWrite;
  
  output reg[1:0]Forward_Signal_A;
  output reg[1:0]Forward_Signal_B;

  always@(*)
  begin
  if(EX_MEM_RegWrite&&EX_MEM_RD!=5'b0&&EX_MEM_RD==ID_EX_RS)
        Forward_Signal_A=2'b10;
    else
    if(MEM_WB_RegWrite&&MEM_WB_RD!=5'b0&&MEM_WB_RD==ID_EX_RS&&(EX_MEM_RD!=ID_EX_RS||!EX_MEM_RegWrite))
      Forward_Signal_A=2'b01;
      else Forward_Signal_A=2'b00;
  end
  
  always@(*)
  begin
    if(EX_MEM_RegWrite&&EX_MEM_RD!=5'b0&&EX_MEM_RD==ID_EX_RT)
        Forward_Signal_B=2'b10;
    else
      if(MEM_WB_RegWrite&&MEM_WB_RD!=5'b0&&MEM_WB_RD==ID_EX_RT&&(EX_MEM_RD!=ID_EX_RT||!EX_MEM_RegWrite))
        Forward_Signal_B=2'b01;
      else Forward_Signal_B=2'b00;
  end
endmodule