// Copyright

module ClockScaler #(
    parameter FREQ_SCALE       = 2      // Board-to-SPI clock frequency scale 
										//  ^ Has to be divisble by two
) (
    input  logic        clkIn,
    input  logic        rst,
    input  logic        clkEnable,
    output logic        clkOut
);
	// Internal signals
    logic[$clog2((FREQ_SCALE/2)-1)-1:0]   cnt;
	logic 							comp;
	 
	// Internal assignments
	assign comp = (cnt == (FREQ_SCALE/2)-1);
    
    always_ff @(posedge clkIn or posedge rst) begin
        if (rst) begin
            cnt <= '0;
        end
        else begin
            if (comp) begin
				cnt <= '0;
			end	
			else begin
				cnt = cnt + 1'b1;
			end
        end
    end
	 
	always_ff @(posedge clkIn or posedge rst) begin
	    if (rst) begin
			clkOut <= 1'b0;
		end
		else begin
			if (comp) begin
				clkOut <= ~clkOut;
			end
		end
	end

endmodule