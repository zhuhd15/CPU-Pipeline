module Two_way_selector(num_A,num_B,sel_signal,result);
  input [31:0]num_A;
  input [31:0]num_B;
  input sel_signal;
  
  output reg [31:0]result;
  
  always@(*)
  if(sel_signal)
    result=num_B;
  else
    result=num_A;
    
endmodule