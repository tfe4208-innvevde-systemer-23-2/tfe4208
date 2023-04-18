//////////////////////////////////////////////////
// Title:           CpuPeripheralVerifier
// Author:          Mathias Støle
// Date:            02.04.2023
// Description:     
////////////////////////////////////////////////////

module CpuPeripheralVerifier #(
    // -- Parameters
    parameter LOAD_SPI              = 1,                
    parameter DATA_0                = 6'h12,
    parameter DATA_1                = 6'h05,
    parameter DATA_2                = 6'h24,
    parameter DATA_3                = 6'h28,
    parameter DATA_4                = 6'h02,
    parameter DATA_5                = 6'h11
) (
    // -- Inputs
    input  logic[3:0][11:0]      SpiOut,
    input  logic                 SpiOutValid,

    // -- Outputs
    output logic[35:0]           PeripheralIn,
    output logic                 PeripheralInValid
);

    generate
        if (LOAD_SPI == 1) begin
            // Load data[2:0] from SPI driver to Peripheral
            assign PeripheralInValid = SpiOutValid;
            assign PeripheralIn = {SpiOut[2], SpiOut[1], SpiOut[0]};
        end
        else begin
            // Load Parameter data to Peripheral
            assign PeripheralInValid = 1'b1;
            assign PeripheralIn = {DATA_5, DATA_4, DATA_3, DATA_2, DATA_1, DATA_0};
        end
    endgenerate

endmodule