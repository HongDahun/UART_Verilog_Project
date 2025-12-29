module top_uart_loopback (
	input wire clk,
	input wire rst_n,
	input wire rx,
	output wire tx
);

	wire [7:0] loop_data;
	wire loop_valid;
	
	wire tick;
	
	reg [8:0] clk_cnt;
	reg tick_reg;
	
	assign tick = tick_reg;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			clk_cnt  <= 9'd0;
			tick_reg <= 1'b0;
		end else begin
			if (clk_cnt == 434) begin
				clk_cnt  <= 9'd0;
				tick_reg <= 1'b1;
			end else begin
				clk_cnt  <= clk_cnt + 1;
				tick_reg <= 1'b0;
			end
		end
	end
	
	uart_rx u_rx (
		.clk(clk),
		.rst_n(rst_n),
		.rx(rx),
		.dout(loop_data),
		.rx_done(loop_valid)
	);
	
	uart_tx u_tx (
		.clk(clk),
		.rst_n(rst_n),
		.tick(tick),
		.start(loop_valid),
		.din(loop_data),
		.tx(tx),
		.busy()
	);
	
endmodule
