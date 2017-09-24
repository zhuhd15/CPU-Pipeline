module RegFile (reset, clk, AddrA, AddrB, AddrC, WrC, WrtDataC, RdDataA, RdDataB);
input reset, clk, WrC;
input [4:0] AddrA, AddrB, AddrC;
input [31:0] WrtDataC;
output [31:0] RdDataA, RdDataB;

reg [31:0] RF_Data[31:1];
integer i;
assign RdDataA=(AddrA==5'b0)?32'b0:RF_Data[AddrA];	//$0 MUST be all zeros
assign RdDataB=(AddrB==5'b0)?32'b0:RF_Data[AddrB];

always@(negedge reset or posedge clk) begin
	if(~reset)
		for(i=1;i<32;i=i+1) RF_Data[i]<=32'b0;
	else
		if(WrC && AddrC) RF_Data[AddrC] <= WrtDataC;
end
endmodule


module AddrC_Mux (RegDst, Rt, Rd, AddrC);
input [1:0] RegDst;
input [4:0] Rt, Rd;
output reg[4:0] AddrC;
always@(*)
case(RegDst)
  0: AddrC <= Rd;
  1: AddrC <= Rt;
  2: AddrC <= 31;
  3: AddrC <= 26;
endcase
endmodule