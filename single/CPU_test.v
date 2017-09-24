`timescale 1ns/1ps
module test_cpu();
	
	reg reset;
	reg clk;
	
	CPU cpu1(reset, clk);
	
	initial begin
		reset = 1;
		clk = 1;
		#1 reset = 0;
		#1 reset = 1;
	end
	
	always #10 clk = ~clk;
		
endmodule
