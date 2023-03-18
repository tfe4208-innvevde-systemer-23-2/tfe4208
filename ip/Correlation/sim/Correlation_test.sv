// Copyright

module Correlation_test;

    // Parameters 
    parameter NUM_SLAVES = 4;                // Number of SPI channels
    parameter NUM_BITS = 12;                 // Number of bits in SPI word
    parameter FREQ_SCALE = 4;               // Board-to-SPI clock frequency scale 

    // Clock and reset
    logic                                   clk50M;     // Main clock
    logic                                   busClk;     // SPI bus clock
    logic                                   rst;

    int fd_r;
    string line;

    logic[NUM_SLAVES-1:0][NUM_BITS-1:0]     dataIn;

    /*// Instantiate DUT
    Correlation #(
        // Parameters
    ) dut (
        // Signals
    )*/

    // Instantiate golden model
    // import pysv::Correlate;
    
    // Generate clock
    always #10 clk50M=!clk50M;
    
    // Set up stimulus
    initial begin
        clk50M = 1'b0;

        // File management
        fd_r = $fopen("data/test.csv", "r");        // File path relative to sim-folder
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

            // Do checks on DUT with new values

        end

        $fclose(fd_r);
    end
    //$finish;

endmodule