// Copyright

`timescale 10 ns / 1 ns

module Correlation_test;

    // Parameters 
    parameter FREQ_SCALE                = 4;    // Board-to-SPI clock frequency scale 
    parameter NUM_BITS_SAMPLE           = 12;   // Number of bits in SPI word
    parameter NUM_SLAVES                = 4;
    parameter NUM_SAMPLES               = 100;
    parameter MAX_SAMPLES_DELAY         = 11;
    parameter NUM_BITS_XCORR            = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
    parameter NUM_XCORRS                = 6;

    // Clock and reset
    logic                                   clk50M;     // Main clock
    logic                                   busClk;     // SPI bus clock
    logic                                   rst;

    int fd_r;
    string line;

    logic[NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0]     dataIn;
    logic[NUM_XCORRS-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut;

    // Instantiate DUT
    Correlation #(
        .NUM_BITS_SAMPLE(NUM_BITS_SAMPLE),
        .NUM_SLAVES(NUM_SLAVES),
        .NUM_SAMPLES(NUM_SAMPLES),
        .MAX_SAMPLES_DELAY(MAX_SAMPLES_DELAY),
        .NUM_BITS_XCORR(NUM_BITS_XCORR),
        .NUM_XCORRS(NUM_XCORRS)
    ) dut (
        // Signals
        .clk(clk50M),
        .rst(rst),
        .dataIn(dataIn),
        .xCorrOut(xCorrOut)
    );

    // Instantiate golden model
    // import pysv::Correlate;
    
    // Generate clock
    always #1 clk50M=!clk50M;
    
    // Set up stimulus
    initial begin
        clk50M = 1'b0;

        // File management
        fd_r = $fopen("data/nepe0.csv", "r");        // File path relative to sim-folder
        if (fd_r) begin
             $display("File was opened successfully : %0h", fd_r);
        end
        else begin
            $error("Error opening data file : %0d", fd_r);
        end

        while (!$feof(fd_r)) begin
            @(negedge clk50M);
            $fgets(line, fd_r);                                                             // Read next line in file
            $display("\nLine: %s", line);
            $sscanf(line, "%d, %d, %d, %d", dataIn[0], dataIn[1], dataIn[2], dataIn[3]);    // Parse line and put it on dataIn-bus
            for (int i = 0; i < NUM_SLAVES; i++) begin
                // Probably some more formatting required
                $display("Element %d: %d", i, dataIn[i]);
            end
            // Correlate();

            // Do checks on DUT with new values

        end

        $fclose(fd_r);
        // $finish;
    end

endmodule