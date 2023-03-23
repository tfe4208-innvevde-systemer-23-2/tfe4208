// Copyright

module Peak #(
    parameter NUM_BITS_SAMPLE           = 12;
    parameter NUM_SAMPLES               = 1024;
    parameter MAX_LAGS                  = 17;
    parameter NUM_XCORRS                = 6;
    parameter NUM_XCORRS                = 6;
    parameter NUM_BITS_XCORRS           = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
) (
    input  logic                                                    clk;
    input  logic                                                    rst;

    input  logic[NUM_XCORRS-1:0][2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0] dataIn;
    input  logic                                                    dataInValid;

    output logic[NUM_XCORRS-1:0][$clog2(2*MAX_LAGS)-1:0]            dataOut;
    output logic                                                    dataOutValid
);

// Need edge detector???

// Internal signals
logic[$clog2(2*MAX_LAGS)-1:0]   iterator;
logic                           rstInternal;

// Assign statements

    // -- Generate functional units
    genvar i;
    generate
        for (i = 0; i < NUM_XCORRS; i++) begin : peakGen
            PeakFinder #(
                .NUM_BITS_SAMPLE    (NUM_BITS_SAMPLE),
                .NUM_SAMPLES        (NUM_SAMPLES),
                .NUM_BITS_XCORRS    (NUM_BITS_XCORRS),
                .MAX_LAGS           (MAX_LAGS),
                .MIN_XCORR_VAL      (MIN_XCORR_VAL)
            ) u_PeakFinder (
                .clk                (clk),
                .rst                (rstInternal),
                .dataIn             (dataIn[i]),
                .iterator           (iterator),
                .dataOut            (dataOut[i])
            );
        end
    endgenerate

    // -- FSM
    Fsm #(
        .MAX_LAGS(MAX_LAGS)
    ) u_fsm (
        .clk(clk),
        .rst(rst),
        .enable(dataInValid),
        .iterator(iterator),
        .dataOutValid(dataOutValid),
        .rstInternal(rstInternal)
    );

endmodule