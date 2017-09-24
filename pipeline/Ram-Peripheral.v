module RdData_Mux(RdData1, RdData2, ALUOut, RdData);
input [31:0] RdData1, RdData2, ALUOut;
output reg[31:0] RdData;
always@(*)
  if(ALUOut < 32'h40000000)
    RdData <= RdData1;
  else
    RdData <= RdData2;
endmodule

