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
    input  logic rst,

    // Values used for crosscorrelation calculations. The f and g refer to the symbols in the crosscorrelation formula.
    // The add-values are used when introducing a new value to crosscorrelation estimate, and the sub-values are used when they are removed.
    input logic [NUM_BITS_SAMPLE-1:0] xCorrInputAddf,
    input logic [NUM_BITS_SAMPLE-1:0] xCorrInputSubf,
    input logic [2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputAddg,
    input logic [2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputSubg,

    // Has the crosscorrelation values
    output logic [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorr 
);

genvar delay;
generate 
    for (delay = 0; delay <= 2*MAX_SAMPLES_DELAY; delay++) begin
        // Crosscorrelation calculations
        always_ff @(posedge clk or posedge rst) begin
            if (rst) begin
                xCorr[delay] <= '0;
            end else begin
                // Add and subtract new samples to the crosscorrelation estimate
                xCorr[delay] <= xCorr[delay] 
                                + xCorrInputAddf * xCorrInputAddg[delay]
                                - xCorrInputSubf * xCorrInputSubg[delay];
            end
        end
    end
endgenerate
    
endmodule
