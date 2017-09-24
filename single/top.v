module top(reset, sysclk, switch, led, digi_out1, digi_out2, digi_out3, digi_out4, uart_rxd, uart_txd);
input reset, sysclk;
wire cpuclk;
input [7:0] switch;
output wire[7:0] led;
//digitube_scan
wire[11:0] digi;
output wire[6:0] digi_out1, digi_out2, digi_out3, digi_out4;
//uart
input uart_rxd;
output wire uart_txd;
wire[7:0] rx_data, tx_data;
wire rx_status, tx_status, tx_en;
cpu_clk clkgen (reset, sysclk, cpuclk);
CPU c (reset, cpuclk, switch, led, digi, tx_data, rx_data, rx_status, tx_status, tx_en);
uart u (sysclk, reset, uart_rxd, uart_txd, rx_data, tx_data, rx_status, tx_status, tx_en);
digitube_scan dts (digi,digi_out1,digi_out2,digi_out3,digi_out4);
endmodule

module cpu_clk(reset, sysclk, cpuclk);
input reset, sysclk;
output reg cpuclk;
reg [8:0]cnt;
always @(negedge sysclk or negedge reset)
	if(~reset)
		begin
		cnt <= 0;
		cpuclk <= 0;
		end
	else
		if(cnt == 499)
			//t=20us, f=50kHz
			begin
			cnt <= 0;
			cpuclk = ~cpuclk;
			end
		else
			cnt <= cnt+1;

endmodule