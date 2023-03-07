// Copyright

module ClockScaler #(
    parameter FREQ_SCALE       = 2                // Board-to-SPI clock frequency scale 
) (
    input  logic        clkIn,
    input  logic        rst,
    input  logic        clkEnable,
    output logic        clkOut
);

    logic[$clog2(FREQ_SCALE)-1:0]   cnt;
    
    always_ff @(posedge clkIn or posedge rst) begin
        if (rst) begin
            cnt <= '0;
        end
        else begin
            cnt <= cnt + 1'b1;
            if (cnt == (FREQ_SCALE-1)) begin
                cnt <= '0;
            end
        end

        clkOut <= (cnt < ((FREQ_SCALE)/2)) ? 1'b1 : 1'b0;
    end

endmodule