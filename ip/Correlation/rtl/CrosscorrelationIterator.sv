//////////////////////////////////////////////////
// Title:           Crosscorrelation Iterator
// Author:          
// Date:            17.03.2023
// Description:     
////////////////////////////////////////////////////

module CrossorrelationIterator #(
    parameter NUM_BITS_SAMPLE           = 12;
    parameter NUM_SAMPLES               = 100;
    parameter MAX_SAMPLES_DELAY         = 11;
    parameter NUM_BITS_XCORR            = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
) (
    input  logic clk;
    input  logic rst;

    // Values used for crosscorrelation calculations. The f and g refer to the symbols in the crosscorrelation formula.
    // The add-values are used when introducing a new value to crosscorrelation estimate, and the sub-values are used when they are removed.
    input logic xCorrInputAddf [NUM_BITS_SAMPLE-1:0];
    input logic xCorrInputSubf [NUM_BITS_SAMPLE-1:0];
    input logic xCorrInputAddg [MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0];
    input logic xCorrInputSubg [MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0];

    // Has the crosscorrelation values
    output logic xCorr [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0];
);

genvar delay;
generate 
    // Crosscorrelation calculations
    always_ff @(posedge clk) begin
        if (rst) begin
            xCorr[delay] <= {NUM_BITS_XCORR{1'b0}};
        end else begin
            // Add and subtract new samples to the crosscorrelation estimate
            xCorr[delay] <= xCorr[delay] 
                            + xCorrInputAddf * xCorrInputAddg[delay]
                            - xCorrInputSubf * xCorrInputSubg[delay];
        end
    end
endgenerate
    
endmodule
