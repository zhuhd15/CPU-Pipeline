module Three_way_selector(num_A,num_B,num_C,sel_signal,result);
  input [31:0]num_A;
  input [31:0]num_B;
  input [31:0]num_C;
  input [1:0]sel_signal;
  
  output reg [31:0]result;
  
  always@(*)
  case(sel_signal)
    2'b00:result=num_A;
    2'b01:result=num_B;
    2'b10:result=num_C;
	 default:result=32'b0;
  endcase
endmodule

/*

module Three_way_special(num_A,num_B,num_C,num_D,forwardSign,PcSrcSgn,result);
	input [31:0]num_A;
	input [31:0]num_B;
	input [31:0]num_C;
	input [31:0]num_D;
	input [1:0]forwardSign;
	input PcSrcSgn;
	
	output reg [31:0]result;
	
	always@(*)
	case(PcSrcSgn)
		1'b1:result=num_D;
		default:
		begin
			case(forwardSign)
				2'b10:result=num_C;
				2'b01:result=num_B;
				default:result=num_A;
			endcase
		end
	endcase
endmodule*/

