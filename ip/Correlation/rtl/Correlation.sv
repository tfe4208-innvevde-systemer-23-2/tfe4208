//////////////////////////////////////////////////
// Title:           Crosscorrelation
// Author:          
// Date:            17.03.2023
// Description:     
////////////////////////////////////////////////////

module Correlation #(
    parameter NUM_BITS_SAMPLE           = 12;
    parameter NUM_SLAVES                = 4;
    parameter NUM_SAMPLES               = 100;
    parameter MAX_SAMPLES_DELAY         = 11;
    parameter NUM_BITS_XCORR            = 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES);
    parameter NUM_XCORRS                = 6;
) (
    input  logic                                            clk;
    input  logic                                            rst;
    input  logic[NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0]       dataIn;
);

// Need edge detector???

// Shift register for storing the input data
reg inputBuffer [NUM_SLAVES-1:0][NUM_SAMPLES-1:0][NUM_BITS_SAMPLE-1:0];

// Values used for crosscorrelation calculations. The f and g refer to the symbols in the crosscorrelation formula.
// The add-values are used when introducing a new value to crosscorrelation estimate, and the sub-values are used when they are removed.
logic xCorrInputAddf [NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0];
logic xCorrInputSubf [NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0];
logic xCorrInputAddg [NUM_SLAVES-1:0][MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0];
logic xCorrInputSubg [NUM_SLAVES-1:0][MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0];

// Registers for storing the crosscorrelation values
reg xCorr [NUM_XCORRS-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0];

// Eunmeration for the different crosscorrelations
typedef enum logic [2:0] {xCorr01 = 0, xCorr02 = 1, xCorr03 = 2, xCorr12 = 3, xCorr13 = 4, xCorr23 = 5} xCorrIndex;

genvar slave, bufferLine;
generate
    for (slave = 0; slave < NUM_SLAVES; slave = slave + 1) begin

        // Sets up the inputBuffer shift register
        always @(posedge clk) begin
            if (rst) begin
                inputBuffer[slave] <= {NUM_SAMPLES{NUM_BITS_SAMPLE{1'b0}}};
            end else begin
                // Shift in new sample
                inputBuffer[slave][0] <= dataIn[slave];
                // Shift all other samples down
                for (bufferLine = 0; bufferLine <= NUM_SAMPLES; bufferLine = bufferLine + 1) begin
                    inputBuffer[slave][bufferLine+1] <= inputBuffer[slave][bufferLine];
                end
            end
        end

        // Assign the f- and g-values for the crosscorrelation calculations
        assign xCorrInputAddf[slave] = inputBuffer[slave][MAX_SAMPLES_DELAY];
        assign xCorrInputSubf[slave] = inputBuffer[slave][NUM_SAMPLES - MAX_SAMPLES_DELAY - 1];
        for (bufferLine = 0; bufferLine <= 2*MAX_SAMPLES_DELAY; bufferLine = bufferLine + 1) begin
            assign xCorrInputAddg[slave][bufferLine] = inputBuffer[slave][bufferLine];
            assign xCorrInputSubg[slave][bufferLine] = inputBuffer[slave][NUM_SAMPLES - 2*MAX_SAMPLES_DELAY - 1 + bufferLine];
        end

    end
endgenerate

// Instantiate the crosscorrelation iterators
// Will set up calculations for xcorr(0,1), xcorr(0,2), xcorr(0,3), xcorr(1,2), xcorr(1,3) and xcorr(2,3)
genvar xCorrIndex, fIndex, gIndex;
generate
    xCorrIndex = 0;
    for (fIndex = 0; fIndex < NUM_SLAVES; fIndex = fIndex + 1) begin
        for (gIndex = fIndex + 1; gIndex < NUM_SLAVES; gIndex = gIndex + 1) begin
            CrossorrelationIterator #(
                .NUM_BITS           (NUM_BITS_SAMPLE)
                .NUM_SAMPLES        (NUM_SAMPLES)
                .MAX_SAMPLES_DELAY  (MAX_SAMPLES_DELAY)
                .NUM_BITS_XCORR     (NUM_BITS_XCORR)
            ) u_CrossorrelationIterator (
                .clk                (clk),
                .rst                (rst),
                .xCorrInputAddf     (xCorrInputAddf[fIndex]),
                .xCorrInputSubf     (xCorrInputSubf[fIndex]),
                .xCorrInputAddg     (xCorrInputAddg[gIndex]),
                .xCorrInputSubg     (xCorrInputSubg[gIndex]),
                .xCorr              (xCorr[xCorrIndex])
            );
            xCorrIndex = xCorrIndex + 1;
        end
    end
endgenerate

endmodule
