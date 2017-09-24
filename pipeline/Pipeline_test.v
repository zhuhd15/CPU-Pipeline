`timescale 1ns/1ps
module Pipeline_test;
  
  reg reset, clk, switch, uart_rxd;
  wire led, digi_out1, digi_out2, digi_out3, digi_out4, uart_txd;
  wire [31:0]PC,rx_data, tx_data;
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
