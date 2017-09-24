module RAM (reset, clk, WrData, MemRd, MemWr, Addr, RdData);
input reset, clk;
input MemRd, MemWr;
input [31:0] Addr;	//Address Must be Word Aligned
input [31:0] WrData;
output [31:0] RdData;

parameter RAM_SIZE = 256;
reg [31:0] RAMDATA [RAM_SIZE-1:0];

assign RdData=(MemRd && (Addr[31:2] < RAM_SIZE))?RAMDATA[Addr[31:2]]:32'b0;
always@(posedge clk) begin
	if(MemWr && (Addr[31:2] < RAM_SIZE)) RAMDATA[Addr[31:2]] <= WrData;
end
endmodule
