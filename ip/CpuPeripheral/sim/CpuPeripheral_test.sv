// Copyright

module CpuPeripheral_test;
    // -- Parameters --
    parameter NUM_SLAVES = 4,                // Number of SPI channels
    parameter MAX_LAGS = 17,                 // Maximum Correlation delay in num of samples (has to be < 32)
    parameter CPU_BITS = 32                  // Number of bits used for CPU communication

    // DUT
    CpuPeripheral #(
        .NUM_SLAVES     (NUM_SLAVES),
        .MAX_LAGS       (MAX_LAGS),
        .CPU_BITS       (CPU_BITS)
    ) dut (
        .clk            (),
        .reset          (),
        .readdata       (),
        .dataIn         (),
        .dataInValid    ()
    );

    initial begin
        clk50M = 1'b0;
        //stim;
        //@(posedge clk50M); $finish(2);
    end

    // Generate clock
    always #10 clk50M=!clk50M;

endmodule