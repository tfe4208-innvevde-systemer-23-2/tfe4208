// Copyright

module Correlation_test;

    // Clock and reset
    logic                                   clk50M;     // Main clock
    logic                                   rst;


    // Instantiate DUT
    Correlation #(
        // Parameters
    ) dut (
        // Signals
    )

    initial begin
        clk50M = 1'b0;
        //stim;
        //@(posedge clk50M); $finish(2);
    end

    // Generate clock
    always #10 clk50M=!clk50M;

endmodule;