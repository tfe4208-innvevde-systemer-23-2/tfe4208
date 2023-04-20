//////////////////////////////////////////////////
// Title:           Crosscorrelation Iterator
// Author:          
// Date:            17.03.2023
// Description:     
////////////////////////////////////////////////////

module CrossorrelationIterator #(
    parameter NUM_BITS_SAMPLE           = 12,
    parameter NUM_SAMPLES               = 100,
    parameter MAX_SAMPLES_DELAY         = 11,
    parameter NUM_BITS_XCORR            = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES)
) (
    input  logic clk,
    input  logic enable,
    input  logic rst,

    // Values used for crosscorrelation calculations. The f and g refer to the symbols in the crosscorrelation formula.
    // The add-values are used when introducing a new value to crosscorrelation estimate, and the sub-values are used when they are removed.
    input logic signed [NUM_BITS_SAMPLE-1:0] xCorrInputAddf,
    input logic signed [NUM_BITS_SAMPLE-1:0] xCorrInputSubf,
    input logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputAddg,
    input logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputSubg,

    // Has the crosscorrelation values
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorr 
);

logic signed [NUM_BITS_XCORR-1:0] xCorrInputAddfPadded;
logic signed [NUM_BITS_XCORR-1:0] xCorrInputSubfPadded;
logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrInputAddgPadded;
logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrInputSubgPadded;

logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrInputAddFactor;
logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrInputSubFactor;


assign xCorrInputAddfPadded = {{NUM_BITS_XCORR - NUM_BITS_SAMPLE{xCorrInputAddf[NUM_BITS_SAMPLE-1]}}, xCorrInputAddf};
assign xCorrInputSubfPadded = {{NUM_BITS_XCORR - NUM_BITS_SAMPLE{xCorrInputSubf[NUM_BITS_SAMPLE-1]}}, xCorrInputSubf};

genvar delay;
generate 
    for (delay = 0; delay <= 2*MAX_SAMPLES_DELAY; delay++) begin
        assign xCorrInputAddgPadded[delay] = {{NUM_BITS_XCORR - NUM_BITS_SAMPLE{xCorrInputAddg[delay][NUM_BITS_SAMPLE-1]}}, xCorrInputAddg[delay]};
        assign xCorrInputSubgPadded[delay] = {{NUM_BITS_XCORR - NUM_BITS_SAMPLE{xCorrInputSubg[delay][NUM_BITS_SAMPLE-1]}}, xCorrInputSubg[delay]};

        assign xCorrInputAddFactor[delay] = xCorrInputAddfPadded * xCorrInputAddgPadded[delay];
        assign xCorrInputSubFactor[delay] = xCorrInputSubfPadded * xCorrInputSubgPadded[delay];

        // Crosscorrelation calculations
        always_ff @(posedge clk or posedge rst) begin
            if (rst) begin
                xCorr[delay] <= '0;
            end else if (enable) begin
                // Add and subtract new samples to the crosscorrelation estimate
                xCorr[delay] <= xCorr[delay] 
                                + xCorrInputAddFactor[delay]
                                - xCorrInputSubFactor[delay];
            end else begin
                xCorr[delay] <= xCorr[delay];
            end
        end
    end
endgenerate
    
endmodule
