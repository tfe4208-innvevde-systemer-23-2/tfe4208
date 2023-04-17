// Copyright

module Peak #(
    parameter NUM_BITS_SAMPLE           = 12,
    parameter NUM_SAMPLES               = 1024,
    parameter MAX_LAGS                  = 17,
    parameter BITS_PER_XCORR            = 6,            // $clog2(2*MAX_LAGS+1) 
    parameter NUM_XCORRS                = 6,
    parameter NUM_BITS_XCORRS           = 32,           // 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES)
    parameter MIN_XCORR_VAL             = 1000
) (
    input  logic                                                    clk,
    input  logic                                                    rst,

    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn0,
    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn1,
    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn2,
    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn3,
    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn4,
    input  logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataIn5,
    input  logic                                                    dataInValid,

    output logic[(NUM_XCORRS * BITS_PER_XCORR)-1:0]                 dataOut,
    output logic                                                    dataOutValid
);

    // -- Internal signals
    logic[$clog2(2*MAX_LAGS+1)-1:0]                             iterator;
    logic[NUM_XCORRS-1:0][$clog2(2*MAX_LAGS+1)-1:0]             dataOutInternal;
    logic                                                       rstInternal;
    logic                                                       rstFsm;
    logic[NUM_XCORRS-1:0][2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]    dataInInternal;

    // -- Assign statements
    assign rstInternal       =  rst | rstFsm;
    assign dataInInternal    = {dataIn5, dataIn4, dataIn3, dataIn2, dataIn1, dataIn0};     // Blame Intel...
    assign dataOut           = {dataOutInternal[5], 
                                dataOutInternal[4], 
                                dataOutInternal[3], 
                                dataOutInternal[2], 
                                dataOutInternal[1], 
                                dataOutInternal[0]};

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
                .dataIn             (dataInInternal[i]),
                .iterator           (iterator),
                .dataOut            (dataOutInternal[i])
            );
        end
    endgenerate

    // -- FSM
    PeakFsm #(
        .MAX_LAGS(MAX_LAGS)
    ) u_fsm (
        .clk(clk),
        .rst(rst),
        .enable(dataInValid),
        .iterator(iterator),
        .dataOutValid(dataOutValid),
        .rstFsm(rstFsm)
    );

endmodule