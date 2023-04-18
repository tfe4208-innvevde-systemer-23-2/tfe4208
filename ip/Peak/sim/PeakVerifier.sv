//////////////////////////////////////////////////
// Title:           PeakVerifier
// Author:          Mathias Støle
// Date:            17.04.2023
// Description:     
////////////////////////////////////////////////////

module PeakVerifier #(
    // -- Parameters
    parameter NUM_BITS_XCORRS   =  32,
    parameter MAX_LAGS          =  17,

    parameter XCORR5_MAX    	=  19,
    parameter XCORR4_MAX    	=  6,
    parameter XCORR3_MAX    	=  17,
    parameter XCORR2_MAX    	=  24,
    parameter XCORR1_MAX    	=  31,
    parameter XCORR0_MAX    	=  2
) (
    // -- Inputs

    // -- Outputs
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut0,
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut1,
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut2,
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut3,
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut4,
    output logic[2*MAX_LAGS:0][NUM_BITS_XCORRS-1:0]                 dataOut5,
    output logic                                                    dataOutValid

);

    assign dataOutValid = 1'b1;
    genvar lag;
    generate
        for (lag = 0; lag < ((2 * MAX_LAGS) + 1); lag++) begin : PeakVerifierGen
        
            // Once again thank you Intel...
            if (lag == XCORR0_MAX) begin
                assign dataOut0[lag] = 99999;
            end
            else begin
                assign dataOut0[lag] = 245;
            end

            if (lag == XCORR1_MAX) begin
                assign dataOut1[lag] = 99999;
            end
            else begin
                assign dataOut1[lag] = 245;
            end

            if (lag == XCORR2_MAX) begin
                assign dataOut2[lag] = 99999;
            end
            else begin
                assign dataOut2[lag] = 245;
            end

            if (lag == XCORR3_MAX) begin
                assign dataOut3[lag] = 99999;
            end
            else begin
                assign dataOut3[lag] = 245;
            end

            if (lag == XCORR4_MAX) begin
                assign dataOut4[lag] = 99999;
            end
            else begin
                assign dataOut4[lag] = 245;
            end

            if (lag == XCORR5_MAX) begin
                assign dataOut5[lag] = 99999;
            end
            else begin
                assign dataOut5[lag] = 245;
            end
        end
    endgenerate
    

endmodule