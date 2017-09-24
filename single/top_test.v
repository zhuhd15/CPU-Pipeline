`timescale 1ns/1ps
module top_test;
	
	reg reset, clk, switch, uart_rxd;
	wire [7:0]led;
	wire uart_txd;
	wire [6:0] digi_out1, digi_out2, digi_out3, digi_out4;
	top top1(reset, clk, switch, led, digi_out1, digi_out2, digi_out3, digi_out4, uart_rxd, uart_txd);
	
	initial begin
		reset <= 1;
		clk <= 1;
		uart_rxd <= 1;
		#1 reset <= 0;
		#1 reset <= 1;
		#1100000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 1;
		#1100000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 1;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 0;
		#104000 uart_rxd <= 1;
	end
	
	always #10 clk = ~clk;
		
endmodule
