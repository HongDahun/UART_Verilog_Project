`timescale 1ns/1ps

module tb_uart_loopback;
	
	reg clk;
	reg rst_n;
	reg rx;
	wire tx;
	
	top_uart_loopback uut (
		.clk(clk),
		.rst_n(rst_n),
		.rx(rx),
		.tx(tx)
	);
	
	always #10 clk = ~clk;
	
	localparam BIT_TIME = 8680;
	
	initial begin
		clk = 0;
		rst_n = 0;
		rx = 1;
		
		#100 rst_n = 1;
		#1000;
		
		rx = 0; #(BIT_TIME);
		
		rx = 1; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		rx = 1; #(BIT_TIME);
		rx = 0; #(BIT_TIME);
		
		rx = 1; #(BIT_TIME);
		
		#200000;
		
		$stop;
	end
	
endmodule
