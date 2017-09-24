module Five_bit_two_way(num_A,num_B,sel_signal,result);
  input [4:0]num_A;
  input [4:0]num_B;
  input sel_signal;
  
  output reg [4:0]result;
  
  always@(*)
  if(sel_signal)
    result=num_B;
  else
    result=num_A;
    
endmodule