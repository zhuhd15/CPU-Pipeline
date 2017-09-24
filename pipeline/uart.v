module uart(sysclk, rst, uart_rxd, uart_txd, rx_data, tx_data, rx_status, tx_status, tx_en);

input sysclk, rst, uart_rxd, tx_en;
input  [7:0] tx_data;
output [7:0] rx_data;
output uart_txd, rx_status, tx_status;

wire boudratex16;

// rx_status 接收到一个完整的字节产生一个脉冲
// tx_status 空闲时为1，发送时为0
// tx_en 接收到一个脉冲时发送数据

receiver rsv(uart_rxd, rx_data, rx_status, boudratex16, rst, sysclk);
boud_generater bg(sysclk, rst, boudrate, boudratex16);
sender sd(uart_txd, tx_en, tx_status, tx_data, boudratex16, rst);

endmodule


module receiver (uart_rx, rx_data, rx_status, boudrate, rst, sysclk);

input        uart_rx;
input        boudrate;
input        rst;
input        sysclk;
output reg [7:0] rx_data;
output       rx_status;

reg          rx_status;
reg    [7:0] rx_data_temp;
reg    [7:0] sig_count;
reg          count_en;
reg          catch;
reg    [3:0] bitnum;
reg          nepulse;

always @(posedge boudrate or negedge rst) begin
	if (~rst) begin
		// reset
		rx_data <= 0;
		sig_count <= 0;
		count_en <= 0;
		catch <= 0;
	end

	else if (sig_count == 0 & !uart_rx & !count_en) begin
		count_en <= 1;
	end

	else if (sig_count == 150 & uart_rx) begin
		count_en <= 0;
		sig_count <= 0;
		rx_data <= rx_data_temp;
	end

	else if (count_en) begin
		sig_count <= sig_count + 8'b00000001;
		if (sig_count % 16 == 8 & sig_count != 8) begin
			catch <= 1;
		end
		else begin
			catch <= 0;
		end
	end
end

always @(posedge catch or negedge rst) begin
	if (~rst) begin
		bitnum <= 0;
		rx_data_temp <= 0;
	end
	else begin
		rx_data_temp[bitnum] <= uart_rx;
		bitnum <= (bitnum + 1) % 8;
	end
end

always @(posedge sysclk or negedge rst) begin
	if (~rst) begin
		// reset
		nepulse <= 0;
		rx_status <= 0;
	end
	else if (!rx_status & count_en) begin
		nepulse <= 1;
	end
	else if (!rx_status & !count_en & nepulse) begin
		rx_status <= 1;
		nepulse <= 0;
	end
	else if (rx_status) begin
		rx_status <= 0;
	end
end
endmodule

module sender(uart_tx, tx_en, tx_status, tx_data, boudrate, rst);

input        tx_en;
input        boudrate;
input  [7:0] tx_data;
input        rst;
output       uart_tx;
output reg   tx_status;

wire   [9:0] tx_data_temp;
reg    [3:0] bitnum;
reg          uart_tx;
reg    [3:0] boudcount;

assign tx_data_temp = {1'b1, tx_data, 1'b0};

always @(posedge boudrate or negedge rst or posedge tx_en) begin
	if (~rst) begin
		bitnum <= 0;
		boudcount <= 0;
	end
	else if (tx_en) begin
		bitnum <= 1;
		boudcount <= 0;
	end
	else if (bitnum != 0 & !tx_status) begin
		if (boudcount == 0) begin
			bitnum <= (bitnum + 1) % 11;
		end
		boudcount <= (boudcount + 1) % 16 ;
	end
end

always @(tx_en or boudcount) begin
	if (tx_en) begin
		tx_status <= 0;
	end
	else if (bitnum == 0 ) begin 
		tx_status <= 1; 
	end
end

always @(bitnum) begin
	if (bitnum != 0 & bitnum != 1) begin
		uart_tx <= tx_data_temp[bitnum - 2];
	end
	else begin
		uart_tx <= 1;
	end
end
endmodule

module boud_generater (sysclk, rst, boudrate, boudratex16);

input sysclk, rst;
output boudrate, boudratex16;

divider #(5208) div(sysclk, rst, boudrate);
divider #(326) div16(sysclk, rst, boudratex16);

endmodule

module divider(clk, rst, sigout);
input clk;
input rst;
output reg sigout;
reg [26: 0] count;

parameter t = 27'd50000000;

initial begin
  count <= 27'd0;
  sigout <= 1'b1;
end

always @(posedge clk or negedge rst) begin
  if (~rst) begin
    // reset
    count <= 27'd0;
    sigout <= 1'b1;
  end
  else begin
    if (count == t - 27'd2) begin
      count <= 27'd0;
      sigout <= ~sigout;
    end
    else begin
      count <= count + 27'd2;
    end
  end
end

endmodule