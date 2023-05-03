//////////////////////////////////////////////////
// Title:           Crosscorrelation
// Author:          Daniel Vorhaug
// Date:            17.03.2023
// Description:     
////////////////////////////////////////////////////

module Correlation #(
    parameter NUM_BITS_SAMPLE           = 12,
    parameter NUM_SLAVES                = 4,
    parameter NUM_SAMPLES               = 1024,
    parameter MAX_SAMPLES_DELAY         = 11,
    parameter NUM_BITS_XCORR            = 32, // 2 * NUM_BITS_SAMPLE + $clog2(NUM_SAMPLES),
    parameter NUM_XCORRS                = 6
) (
    input  logic                                            clk,
    input  logic                                            rst,
    input  logic                                            validIn,
    input  logic[NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0]       dataIn,

    output logic                                                    validOut,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut0,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut1,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut2,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut3,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut4,
    output logic signed [2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorrOut5,

    output logic signed [NUM_SLAVES-1:0][31:0] dataInAverage
);

logic positiveEdge;

logic signed [NUM_SLAVES-1:0][NUM_BITS_SAMPLE:0] dataInDetrended;
logic signed [NUM_SLAVES-1:0][31:0] dataInDetrendedPadded;
logic signed [NUM_SLAVES-1:0][NUM_BITS_SAMPLE:0] dataInOffset;

logic signed [NUM_SLAVES-1:0][NUM_BITS_SAMPLE:0] dataInSigned;

// Shift register for storing the input data
logic signed [NUM_SLAVES-1:0][NUM_SAMPLES-1:0][NUM_BITS_SAMPLE-1:0] inputBuffer;
logic signed [NUM_SLAVES-1:0][31:0] inputBufferEndPadded;

// Values used for crosscorrelation calculations. The f and g refer to the symbols in the crosscorrelation formula.
// The add-values are used when introducing a new value to crosscorrelation estimate, and the sub-values are used when they are removed.
logic signed [NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0] xCorrInputAddf;
logic signed [NUM_SLAVES-1:0][NUM_BITS_SAMPLE-1:0] xCorrInputSubf;
logic signed [NUM_SLAVES-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputAddg;
logic signed [NUM_SLAVES-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_SAMPLE-1:0] xCorrInputSubg;

// Registers for storing the crosscorrelation values
logic signed [NUM_XCORRS-1:0][2*MAX_SAMPLES_DELAY:0][NUM_BITS_XCORR-1:0] xCorr;

// int detrendCounter = -1;
logic [15:0] detrendCounter; // 14 bits is enough to count to 14336


// Offset for the input data. Used to center the data around 0
// Values found experimentally
// assign dataInOffset = {12'b0111_1110_1101, 12'b1000_0000_1010, 12'b0111_1111_1100, 12'b1000_0000_1100};


always @(posedge clk or posedge rst) begin
    // detrendCounter <= ((detrendCounter == NUM_SAMPLES) || rst) ? 0 : detrendCounter + 1;
    if (rst) begin
        detrendCounter <= 0;
    end else if (positiveEdge) begin
        if (detrendCounter > NUM_SAMPLES) begin
            detrendCounter <= 1;
        end else begin
            detrendCounter <= detrendCounter + 1;
        end
    end
end

genvar slave, bufferLine;
generate
    for (slave = 0; slave < NUM_SLAVES; slave++) begin : slaveBuffer

        assign dataInSigned[slave] = signed'({1'b0, dataIn[slave]});
        assign dataInDetrended[slave] = dataInSigned[slave] + dataInOffset[slave];

        // Sets up the inputBuffer shift register
        always @(posedge clk or posedge rst) begin
            // detrendCounter <= ((detrendCounter == NUM_SAMPLES) || rst) ? 0 : detrendCounter + 1;
            if (rst) begin
                inputBuffer[slave] <= '0;
                dataInAverage[slave] <= '0;
                dataInOffset[slave] <= -2048;
                
            end else if (positiveEdge) begin
                // Shift in new sample
                inputBuffer[slave] <= {inputBuffer[slave][NUM_SAMPLES-2:0], dataInDetrended[slave][NUM_BITS_SAMPLE-1:0]};
                dataInAverage[slave] <= dataInAverage[slave] + dataInDetrendedPadded[slave][NUM_BITS_SAMPLE-1:0] - inputBufferEndPadded[slave];

                if (detrendCounter > NUM_SAMPLES) begin
                    if (dataInAverage[slave] > 0) begin
                        dataInOffset[slave] <= dataInOffset[slave] - 1;
                    end else begin
                        dataInOffset[slave] <= dataInOffset[slave] + 1;
                    end
                end else if (detrendCounter == 0) begin
                    dataInOffset[slave] <= -2048;
                end
            end else begin
                // Keep old values
                inputBuffer[slave] <= inputBuffer[slave];
            end
        end

        assign dataInDetrendedPadded[slave] = {{32-NUM_BITS_SAMPLE{dataInDetrended[slave][NUM_BITS_SAMPLE-1]}}, dataInDetrended[slave][NUM_BITS_SAMPLE-1:0]};
        assign inputBufferEndPadded[slave] = {{32-NUM_BITS_SAMPLE{inputBuffer[slave][NUM_SAMPLES-1][NUM_BITS_SAMPLE-1]}}, inputBuffer[slave][NUM_SAMPLES-1]};

        // Assign the f- and g-values for the crosscorrelation calculations
        assign xCorrInputAddf[slave] = inputBuffer[slave][MAX_SAMPLES_DELAY];
        assign xCorrInputSubf[slave] = inputBuffer[slave][NUM_SAMPLES - MAX_SAMPLES_DELAY - 1];
        for (bufferLine = 0; bufferLine <= 2*MAX_SAMPLES_DELAY; bufferLine++) begin : bufferLineAssign
            assign xCorrInputAddg[slave][bufferLine] = inputBuffer[slave][bufferLine];
            assign xCorrInputSubg[slave][bufferLine] = inputBuffer[slave][NUM_SAMPLES - 2*MAX_SAMPLES_DELAY - 1 + bufferLine];
        end

    end
endgenerate

edgeDetector u_edgeDetector (
    .in(validIn),
    .clk(clk),
    .positiveEdge(positiveEdge)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        validOut <= '0;
    end else begin
        validOut <= positiveEdge;
    end
end

// Instantiate the crosscorrelation iterators
// Will set up calculations for xcorr(0,1), xcorr(0,2), xcorr(0,3), xcorr(1,2), xcorr(1,3) and xcorr(2,3)
genvar fIndex, gIndex;
generate
    // xCorrIndex = 0;
    for (fIndex = 0; fIndex < NUM_SLAVES; fIndex++) begin : CrosscorrelationIteratorInitf
        for (gIndex = fIndex + 1; gIndex < NUM_SLAVES; gIndex++) begin : CrosscorrelationIteratorInitg
            CrossorrelationIterator #(
                .NUM_BITS_SAMPLE    (NUM_BITS_SAMPLE),
                .NUM_SAMPLES        (NUM_SAMPLES),
                .MAX_SAMPLES_DELAY  (MAX_SAMPLES_DELAY),
                .NUM_BITS_XCORR     (NUM_BITS_XCORR)
            ) u_CrossorrelationIterator (
                .clk                (clk),
                .enable             (positiveEdge),
                .rst                (rst),
                .xCorrInputAddf     (xCorrInputAddf[fIndex]),
                .xCorrInputSubf     (xCorrInputSubf[fIndex]),
                .xCorrInputAddg     (xCorrInputAddg[gIndex]),
                .xCorrInputSubg     (xCorrInputSubg[gIndex]),
                // Index is a dirty hack to assign in order 0,1,2,3,4,5
                .xCorr              (xCorr[(fIndex == 0) ? gIndex-1 : ((fIndex == 1) ? gIndex+1 : gIndex+2)])
            );
        end
    end
endgenerate


// Assign the outputs, Quartus only supports 2D arrays
assign xCorrOut0 = xCorr[0];
assign xCorrOut1 = xCorr[1];
assign xCorrOut2 = xCorr[2];
assign xCorrOut3 = xCorr[3];
assign xCorrOut4 = xCorr[4];
assign xCorrOut5 = xCorr[5];

endmodule
