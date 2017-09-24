module Forward_PC(EX_MEM_WB,IF_ID_R1,IF_ID_R2,address1,address2);
  input [4:0]EX_MEM_WB;
  input [4:0]IF_ID_R1;
  input [4:0]IF_ID_R2;
  output reg address1;
  output reg address2;
  
  always@(*)
  if(EX_MEM_WB==IF_ID_R1)
    address1=1;
  else
    address1=0;
    
  always@(*)
  if(EX_MEM_WB==IF_ID_R2)
    address2=1;
  else
    address2=0;
    
endmodule
  