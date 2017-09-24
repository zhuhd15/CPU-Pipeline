module Hazard(speccial_hazard,bad_signal,reset,ID_EX_RT,IF_ID_RS,IF_ID_RT,JMP,ID_EX_MEMRead,Hazard_signal,flush,pc_sign,IRQ,PC31,OpCode,HZ_rec);
  input [5:0]OpCode;
  input [4:0]ID_EX_RT;
  input [4:0]IF_ID_RS;
  input [4:0]IF_ID_RT;
  input [2:0]JMP;
  input reset;
  input pc_sign;
  input ID_EX_MEMRead;
  input IRQ, PC31;
  input bad_signal;
  input HZ_rec;
  output reg Hazard_signal;
  output reg flush;
  output wire speccial_hazard;
//  output reg speccial_hazard;
  
  
  always@(*)
  if((ID_EX_MEMRead&&(ID_EX_RT==IF_ID_RS||ID_EX_RT==IF_ID_RT)))
    Hazard_signal=1'b1;
  else
    Hazard_signal=1'b0;
    
  always@(*)
  if(JMP==3'b010||(JMP==3'b001&&pc_sign)||(IRQ & !PC31)||bad_signal)
    flush=1'b1;
  else
    flush=1'b0;
	 
	 
  assign speccial_hazard=(OpCode[5:1]==5'b00010&&!HZ_rec)?1'b1:1'b0;
endmodule