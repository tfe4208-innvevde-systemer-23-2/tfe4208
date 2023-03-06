// Copyright

module SPI_test ();

    logic clk50M;
    logic busClk;

    // Generate clock
    clk50M = 0;
    forever begin
        clk50M = ~clk50M;
    end

    // SPI bus signals
    

    // DUT
    SPI (
        .NUM_SLAVES     (5),
        .NUM_BITS       (12),
        .SAMPLE_TIME    (2),
        .FREQ_SCALE     (10)
    ) dut (
        .clk            (clk50M),
        .rst            (),

        .dataIn         (),

        .chipSelect     (),
        .busClk         (busClk),
        
        .dataOutValid   (),
        .dataOut        ()
    );



endmodule