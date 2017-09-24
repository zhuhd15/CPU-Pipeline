`timescale 1ns/1ps

module Peripheral (reset, clk, rd, wr, addr, wdata, rdata, led, switch, digi, irqout, tx_data, rx_data, rx_status, tx_status, tx_en);
input reset,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;
reg [31:0] rdata;

output [7:0] led;
reg [7:0] led;
input [7:0] switch;
output [11:0] digi;
reg [11:0] digi;
output irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;
assign irqout = TCON[2];

input [7:0] rx_data;
input rx_status, tx_status;
output reg [7:0] tx_data;
output reg  tx_en;
reg rx_status_delay, tx_status_delay, rx_status_flag;
reg [4:0] uart_con;

always@(*) begin
	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			32'h40000018: rdata <= {24'b0, tx_data};
			32'h4000001C: rdata <= {24'b0, rx_data};
			32'h40000020: rdata <= {27'b0, uart_con};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	

		uart_con <= 5'b0;
	end

	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else TL <= TL + 1;
		end

		if(rd & addr == 32'h40000020) begin
			uart_con <= uart_con & 5'b10011;
		end

		if (tx_en) begin
			tx_en <= 0;
		end

		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				32'h40000018: 
				begin 
					if (uart_con[0]) begin
						tx_en <= 1;
						tx_data <= wdata[7:0];
					end
				end
				32'h40000020: uart_con <= wdata[4:0];

				default: ;
			endcase
		end

		rx_status_delay <= rx_status_flag;
		tx_status_delay <= tx_status;
		uart_con[4] <= tx_status;

		if ({tx_status_delay, tx_status} == 2'b01)
		uart_con[2] <= 1;

		if (rx_status_delay ^ rx_status_flag)
		uart_con[3] <= 1;
	end
end

always @(posedge rx_status or negedge reset) begin
	if (~reset) begin
		// reset
		rx_status_flag <= 0;
	end
	else begin
		rx_status_flag <= ~rx_status_flag;
	end
end
endmodule
