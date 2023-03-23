// Copyright

module Peak_test;

    // Parameters
    parameter NUM_BITS_SAMPLE           = 12;
    parameter NUM_SAMPLES               = 1024;
    parameter MAX_LAGS                  = 17;
    parameter NUM_XCORRS                = 1;            // Only use one XCorr for test
    parameter NUM_BITS_XCORRS           = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
    parameter MIN_XCORR_VAL             = 1000;
    
    // Clock and reset
    logic               clk50M;
    logic               rst;

    // DUT I/O
    logic[NUM_XCORRS-1:0][2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]    dataIn;
    logic                                                       dataInValid;
    logic signed[NUM_XCORRS-1:0][$clog2(2*MAX_LAGS)-1:0]               dataOut;
    logic                                                       dataOutValid;

    // Files
    int         fd_r;
    string      line;


    // DUT
    Peak #(
        .NUM_BITS_SAMPLE(NUM_BITS_SAMPLE),
        .NUM_SAMPLES(NUM_SAMPLES),
        .MAX_LAGS(MAX_LAGS),
        .NUM_XCORRS(NUM_XCORRS),
        .NUM_BITS_XCORRS(NUM_BITS_XCORRS),
        .MIN_XCORR_VAL(MIN_XCORR_VAL)
    ) dut (
        .clk(clk50M),
        .rst(rst),
        .dataIn(dataIn),
        .dataInValid(dataInValid),
        .dataOut(dataOut),
        .dataOutValid(dataOutValid)
    );

    initial begin
        clk50M = 1'b0;
        stim;
    end

    // Generate clock
    always #10 clk50M=!clk50M;

    always @(posedge clk50M) 
        $display($stime,,,"rst=%b DataIn=%0d ValidIn=%b ValidOut=%b DataOut=%d, state=%b",
            rst, dataIn, dataInValid, dataOutValid, dataOut, dut.u_fsm.state);

    task stim;
        rst=1'b0; dataIn = '0; dataInValid = 1'b0;
        @(negedge clk50M) rst=1'b1;
        @(negedge clk50M) rst=1'b0;
        
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
            for (int i = 0; i < 2*MAX_LAGS+1; i++) begin
                // Probably some more formatting required
                $display("Element %d: %d", i, dataIn[i]);
            end

            // Wait for IP to finish
            @(posedge dataOutValid)

            

        end
        $fclose(fd_r);

    endtask

endmodule