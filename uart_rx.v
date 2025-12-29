module uart_rx (
	input wire clk,
	input wire rst_n,
	input wire rx,
	output reg [7:0] dout,
	output reg rx_done
);

	localparam IDLE  = 2'b00;
	localparam START = 2'b01;
	localparam DATA  = 2'b10;
	localparam STOP  = 2'b11;
	
	localparam CLKS_PER_BIT = 434;
	localparam CLKS_HALF    =217;
	
	reg [1:0] state;
	reg [8:0] clk_cnt;
	reg [2:0] bit_cnt;
	reg [7:0] shift_reg;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= IDLE;
			dout      <= 8'd0;
			rx_done   <= 1'b0;
			clk_cnt   <= 9'd0;
			bit_cnt   <= 3'd0;
			shift_reg <= 8'd0;
		end else begin
			case (state)
				IDLE: begin
					rx_done <= 1'b0;
					clk_cnt <= 9'd0;
					bit_cnt <= 3'd0;
					
					if (rx == 1'b0) begin
						state <= START;
					end
				end
				
				START: begin
					if (clk_cnt == CLKS_HALF) begin
						if (rx == 1'b0) begin
							clk_cnt <= 9'd0;
							state   <= DATA;
						end else begin
							state <= IDLE;
						end
					end else begin
						clk_cnt <= clk_cnt + 1;
					end
				end
				
				DATA: begin
					if (clk_cnt == CLKS_PER_BIT) begin
						clk_cnt <= 9'd0;
						
						shift_reg <= {rx, shift_reg[7:1]};
						
						if (bit_cnt == 3'd7) begin
							state <= STOP;
						end else begin
							bit_cnt <= bit_cnt + 1;
						end
					end else begin
						clk_cnt <= clk_cnt + 1;
					end
				end
				
				STOP: begin
					if (clk_cnt == CLKS_PER_BIT) begin
						state   <= IDLE;
						dout    <= shift_reg;
						rx_done <= 1'b1;
					end else begin
						clk_cnt <= clk_cnt + 1;
					end
				end
			endcase
		end
	end
	
endmodule
