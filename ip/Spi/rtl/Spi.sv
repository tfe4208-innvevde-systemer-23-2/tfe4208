//////////////////////////////////////////////////
// Title:           Spi
// Author:          Mathias Støle
// Date:            09.03.2023
// Description:     
////////////////////////////////////////////////////


module Spi #(
    // -- Parameters --
    parameter NUM_SLAVES = 5,                // Number of SPI channels
    parameter NUM_BITS = 12,                 // Number of bits in SPI word
    parameter SAMPLE_TIME = 2,               // Number of cycles to wait for ADCs to sample data
    parameter FREQ_SCALE = 10                // Board-to-SPI clock frequency scale 
) (
    // -- Clock and reset
    input  logic                                    clk,
    input  logic                                    rst,

    // -- Serial SPI data in
    input  logic[NUM_SLAVES-1:0]                    dataIn,

    // -- SPI control signals
    output logic                                    chipEnable,
    output logic                                    busClk,

    // -- Parallel data out
    output logic                                    dataOutValid,
    output logic[NUM_SLAVES-1:0][NUM_BITS-1:0]      dataOut 
);

    // -- Internal signals
    logic clkInternal;
    logic busClkEnable;
    logic dataInEnable;

    // -- Assign statements
    assign busClk = clkInternal & busClkEnable;            // Gating SPI bus clock

    // -- Generate SiPo registers
    genvar i;
    generate
        for (i = 0; i < NUM_SLAVES; i++) begin : sipoGen
            SiPo #(
                .NUM_BITS   (NUM_BITS)
            ) u_SiPo (
                .clk        (clkInternal),
                .dataIn     (dataIn[i]),
                .enable     (dataInEnable),
                .dataOut    (dataOut[i])
            );
    end
    endgenerate

    // -- FSM
    Fsm #(
        .SAMPLE_TIME        (SAMPLE_TIME),
        .NUM_BITS           (NUM_BITS)
    ) u_fsm (
        .clk                (clkInternal),
        .rst                (rst),
        .dataInEnable       (dataInEnable),
        .chipEnable         (chipEnable),
        .busClkEnable       (busClkEnable),
        .dataOutValid       (dataOutValid)
    );

    // -- ClockScaler           TODO: This can be improved
    ClockScaler #(
        .FREQ_SCALE         (FREQ_SCALE)
    ) u_ClockScaler (
        .clkIn              (clk),
        .rst                (rst),
        .clkEnable          (1'b1),
        .clkOut             (clkInternal)
    );
    
endmodule