// Copyright

module Peak_test;

    // Parameters
    parameter NUM_BITS_SAMPLE           = 12;
    parameter NUM_SAMPLES               = 1024;
    parameter MAX_LAGS                  = 4;
    parameter NUM_XCORRS                = 1;            // Only use one XCorr for test
    parameter NUM_BITS_XCORRS           = 34;           //2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
    parameter MIN_XCORR_VAL             = 1;
    
    // Clock and reset
    logic               clk50M;
    logic               rst;

    // DUT I/O
    logic[NUM_XCORRS-1:0][2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]    dataIn;
    logic                                                       dataInValid;
    logic[NUM_XCORRS-1:0][$clog2(2*MAX_LAGS+1)-1:0]               dataOut;
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
        $display($stime,,,"rst=%b dataIn=%d ValidIn=%b ValidOut=%b DataOut=%d, state=%b, maxval=%d, iterator=%d",
            rst, dut.peakGen[0].u_PeakFinder.dataIn[dut.iterator], dataInValid, dataOutValid, dataOut, dut.u_fsm.state, dut.peakGen[0].u_PeakFinder.maxValue, dut.iterator);

    task stim;
        rst=1'b0; dataIn = '0; dataInValid = 1'b0;
        @(negedge clk50M) rst=1'b1;
        @(negedge clk50M) rst=1'b0;
        
        // TODO: Make random procedural data instead
        // File management
        fd_r = $fopen("data/test.csv", "r");        // File path relative to sim-folder
        if (!fd_r) begin
            $error("Error opening data file : %0d", fd_r);
        end

        @(negedge clk50M);

        while (!$feof(fd_r)) begin
            $fgets(line, fd_r);                                                             
            $display("\n",$stime,,,"DataIn: %s", line);
            $sscanf(line, "%d,%d,%d,%d,%d,%d,%d,%d,%d", 
                    dataIn[0][0], dataIn[0][1], dataIn[0][2], 
                    dataIn[0][3], dataIn[0][4], dataIn[0][5], 
                    dataIn[0][6], dataIn[0][7], dataIn[0][8]);    // Parse line and put it on dataIn-bus
            
            // Mark data input as valid
            @(negedge clk50M) dataInValid=1'b1;
            @(negedge clk50M) dataInValid=1'b0;

            // Wait for IP to finish
            @(posedge dataOutValid);
            // Do checks

            @(posedge clk50M);
            


        end
        $fclose(fd_r);

    endtask

    task max();

    endtask

endmodule