// Copyright

module ClockScaler (
    parameter FREQ_SCALE       = 40                // Board-to-SPI clock frequency scale 
) (
    input  logic        clkIn;
    input  logic        clkEnable;
    output logic        ClkOut
);

    logic[$clog2(FREQ_SCALE)-1:0]   cnt;
    
    always_ff @(posedge clkIn) begin
        cnt <= cnt + 1;
        if (cnt >= (FREQ_SCALE-1)) begin
            cnt <= '0
        end
        ClkOut <= (cnt < FREQ_SCALE/2) ? 1'b1 : 1'b0;
    end

endmodule;