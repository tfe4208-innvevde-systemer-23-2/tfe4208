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

    parameter DEBUG_MODE                = 0;

    // Clock and reset
    logic                                   clk50M;     // Main clock
    logic                                   busClk;     // SPI bus clock
    logic                                   rst;
    logic                                   validIn;

    int fd_r;
    int file_result[NUM_XCORRS];
    int line_num;

    int num_fails;

    string line;
    string line_result;

    logic[NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0] dataIn;
    logic validOut;
    logic signed [NUM_XCORRS-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorr;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut0;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut1;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut2;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut3;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut4;
    logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut5;
    logic[NUM_XCORRS-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrModel;

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
        .validIn(validIn),
        .dataIn(dataIn),
        .validOut(validOut),
        .xCorrOut0(xCorrOut0),
        .xCorrOut1(xCorrOut1),
        .xCorrOut2(xCorrOut2),
        .xCorrOut3(xCorrOut3),
        .xCorrOut4(xCorrOut4),
        .xCorrOut5(xCorrOut5)
    );

    assign xCorr = {xCorrOut5, xCorrOut4, xCorrOut3, xCorrOut2, xCorrOut1, xCorrOut0};

    // Generate clock
    always #1 clk50M=!clk50M;
    
    // Set up stimulus
    initial begin
        clk50M = 1'b0;
        line_num = 0;
        num_fails = 0;

        // File management
        fd_r = $fopen("data/nepe0.csv", "r");        // File path relative to sim-folder
        if (fd_r) begin
             $display("File was opened successfully : %0h", fd_r);
        end
        else begin
            $error("Error opening data file : %0d", fd_r);
        end

        for (int i = 0; i < NUM_XCORRS; i++) begin
            file_result[i] = $fopen({"data/nepe0_model_result", string'(i+48), ".csv"}, "r");
            if (file_result[i]) begin
                $display("File was opened successfully : %0d", file_result[i]);
            end
            else begin
                $error("Error opening data file : %0d", file_result[i]);
            end
        end

        @(negedge clk50M);
        validIn = 1'b0;
        @(negedge clk50M);
        rst = 1'b1;
        @(negedge clk50M);
        @(negedge clk50M);
        rst = 1'b0;
        @(negedge clk50M);

        while (!$feof(fd_r)) begin
            @(posedge clk50M);
            
            $fgets(line, fd_r);                                                             // Read next line in file
            line_num = line_num + 1;
            if (DEBUG_MODE)
                $display("\nLine: %s", line);
                validIn = 1'b1;
            // @(posedge clk50M);
            $sscanf(line, "%d, %d, %d, %d", dataIn[0], dataIn[1], dataIn[2], dataIn[3]);    // Parse line and put it on dataIn-bus

            if (DEBUG_MODE) begin
                for (int i = 0; i < NUM_SLAVES; i++) begin
                    // Probably some more formatting required
                    $display("Element %d: %d", i, dataIn[i]);          
                end
            end

            // if (DEBUG_MODE)
            //     $display("Buffer: %x", dut.inputBuffer);

            // Print dut.inputBuffer
            if (DEBUG_MODE) begin
                for (int i = 0; i < NUM_SLAVES; i++) begin
                    $write("Slave %d: ", i);
                    for (int j = 0; j < NUM_SAMPLES; j++) begin
                        $write("%d,", dut.inputBuffer[i][j]);
                    end
                    $write("\n");
                end
            end 

            for (int i = 0; i < NUM_XCORRS; i++) begin
                $fgets(line_result, file_result[i]);

                if (DEBUG_MODE)
                    $display("xCorrLine%d: %s", i, line_result);

                if (DEBUG_MODE) begin
                    $write("xCorrOut: ");
                    for (int j = 0; j<2*MAX_SAMPLES_DELAY+1; j++) begin
                        $write("%d,", xCorr[i][j]);
                    end
                    $write("\n");
                end

            
                // I am sorry
                $sscanf(line_result, "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d", xCorrModel[i][0], xCorrModel[i][1], xCorrModel[i][2], xCorrModel[i][3], xCorrModel[i][4], xCorrModel[i][5], xCorrModel[i][6], xCorrModel[i][7], xCorrModel[i][8], xCorrModel[i][9], xCorrModel[i][10], xCorrModel[i][11], xCorrModel[i][12], xCorrModel[i][13], xCorrModel[i][14], xCorrModel[i][15], xCorrModel[i][16], xCorrModel[i][17], xCorrModel[i][18], xCorrModel[i][19], xCorrModel[i][20], xCorrModel[i][21], xCorrModel[i][22]);

                if (line_num > NUM_SAMPLES) begin
                    for (int j = 0; j < 2*MAX_SAMPLES_DELAY+1; j++) begin
                        assert(xCorr[i][j] == xCorrModel[i][j]) begin
                        if (DEBUG_MODE)
                            $display("SUCCESS: xCorrOut[%d][%d] = %h, xCorrModel[%d][%d] = %h", i, j, xCorr[i][j], i, j, xCorrModel[i][j]);
                        end else begin
                            $display("FAIL:    xCorrOut[%d][%d] = %h, xCorrModel[%d][%d] = %h, diff = %h", i, j, xCorr[i][j], i, j, xCorrModel[i][j],  int'(xCorr[i][j]) - int'(xCorrModel[i][j]));
                            num_fails++;
                        end
                    end
                end
            end
            
            @(negedge clk50M);
            @(negedge clk50M);
            validIn = 1'b0;
            @(negedge clk50M);
            @(negedge clk50M);
            
            // Correlate();

            // Do checks on DUT with new values

        end

        $display("Number of fails: %d", num_fails);

        $fclose(fd_r);
        // $finish;
    end

endmodule