// Copyright

module PeakFinder #(
    // -- Parameters
    parameter NUM_BITS_SAMPLE           = 12,
    parameter NUM_SAMPLES               = 1024,
    parameter NUM_BITS_XCORRS           = 34,       // 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES)
    parameter MAX_LAGS                  = 17,
    parameter BITS_PER_XCORR            = 5,        // $clog2(2*MAX_LAGS+1) 
    parameter MIN_XCORR_VAL             = 1000      // 
) (
    // -- Clock and reset
    input logic clk,
    input logic rst,

    // --
    input logic signed [2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]   dataIn,
    input logic[BITS_PER_XCORR-1:0]                          iterator,

    // -- 
    output logic[BITS_PER_XCORR-1:0] dataOut
);

    // -- Internal signals
    logic signed [NUM_BITS_XCORRS-1:0]  value;
    logic signed [NUM_BITS_XCORRS-1:0]  maxValue;
    logic        [BITS_PER_XCORR-1:0]   lagIterator;



    // -- Assign statements
    assign value = dataIn[iterator];
    assign dataOut = ((maxValue > MIN_XCORR_VAL) ? lagIterator : {1'b1, {($clog2(2*MAX_LAGS)){1'b0}}});

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            maxValue        <= '0;
            lagIterator     <= '0;
        end
        else begin
            if (value > maxValue) begin
                maxValue <= value;
                lagIterator <= iterator;
            end
            else begin
                maxValue <= maxValue;
                lagIterator <= lagIterator;
            end
        end
    end

endmodule