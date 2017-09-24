module PC_Branch(value1,value2,branch,PCSrc);
  input [31:0]value1;
  input [31:0]value2;
  input branch;
  output reg PCSrc;
  
  always@(*)
  if(branch&&value1==value2)
    PCSrc=1;
  else
    PCSrc=0;
endmodule