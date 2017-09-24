module Four_way_selector(num_A,num_B,num_C,num_D,sel_signal,result);
  input [4:0]num_A;
  input [4:0]num_B;
  input [4:0]num_C;
  input [4:0]num_D;
  input [1:0]sel_signal;
  
  output reg [4:0]result;
  
  always@(*)
  case(sel_signal)
    2'b00:result=num_A;
    2'b01:result=num_B;
    2'b10:result=num_C;
    2'b11:result=num_D;
  endcase
endmodule
