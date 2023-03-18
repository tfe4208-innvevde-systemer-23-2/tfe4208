// Copyright

module Correlation_test;

    // Parameters 
    parameter NUM_SLAVES = 1;                // Number of SPI channels
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
    import pysv::Correlate;
    
    // Generate clock
    always #10 clk50M=!clk50M;
    
    // Set up stimulus
    initial begin
        clk50M = 1'b0;

        // File management
        fd_r = $fopen("ip/Correlation/sim/data/nepe.bin", "r");
        if (fd_r) $display("File was opened successfully : %0d", fd_r)
        else      $display("Error opening data file : %0d", fd_r);

        while (!$feof(fd_r)) begin
            @negedge(clk50M)
            $fgets(line, fd_r);
            $display("Line: %s", line);
            for (int i = 0; i < NUM_SLAVES; i++) begin
                $sscanf(line, "%s", dataIn[i])
                // Probably some more formatting required
            end

            // Do checks on DUT with new values

        end

        $fclose(fd_r);
    end
    $finish;
endmodule;