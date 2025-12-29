module baud_gen (
    input wire clk,
    input wire rst_n,
    output wire tick
);

    // Counter variable (0 ~ 433)
    reg [8:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 9'd0;
        end else begin
            // 433 is the divider value for 115200bps at 50MHz clock
            if (cnt == 9'd433) begin
                cnt <= 9'd0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    // Tick is generated only when count reaches 433
    assign tick = (cnt == 9'd433) ? 1'b1 : 1'b0;

endmodule
