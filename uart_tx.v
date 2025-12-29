module uart_tx	(
	input wire clk,
	input wire rst_n,
	input wire tick,
	input wire start,
	input wire [7:0] din,
	output reg tx,
	output reg busy
);
	
	localparam IDLE  = 2'b00;
	localparam START = 2'b01;
	localparam DATA  = 2'b10;
	localparam STOP  = 2'b11;
	
	reg [1:0] state;
	reg [2:0] bit_cnt;
	reg [7:0] data_reg;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state    <= IDLE;
			tx       <= 1'b1;
			busy     <= 1'b0;
			bit_cnt  <= 3'd0;
			data_reg <= 8'd0;
		end else begin
			case (state)
				IDLE: begin
					tx <= 1'b1;
					busy <= 1'b0;
					if (start == 1'b1) begin
						state    <= START;
						data_reg <= din;
						busy     <= 1'b1;
					end
				end
			
				START: begin
					tx <= 1'b0;
					if (tick == 1'b1) begin
						state <= DATA;
						bit_cnt <= 3'd0;
					end
				end
			
				DATA: begin
					tx <= data_reg[0];
					if (tick == 1'b1) begin
						if (bit_cnt == 3'd7) begin
							state <= STOP;
						end else begin
							data_reg <= data_reg >>1;
							bit_cnt <= bit_cnt + 1;
						end
					end
				end
			
				STOP: begin
					tx <= 1'b1;
					if (tick == 1'b1) begin
						state <= IDLE;
						busy  <= 1'b0;
					end
				end
			endcase
		end
	end	
endmodule
