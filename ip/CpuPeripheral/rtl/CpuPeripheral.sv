//////////////////////////////////////////////////
// Title:           CpuPeripheral
// Author:          Mathias Støle
// Date:            09.03.2023
// Description:     
////////////////////////////////////////////////////

module CpuPeripheral #(
    // -- Parameters --
    parameter NUM_SLAVES = 5,                // Number of SPI channels
    parameter NUM_BITS = 12,                 // Number of bits in SPI word
    parameter SAMPLE_TIME = 2,               // Number of cycles to wait for ADCs to sample data
    parameter FREQ_SCALE = 10                // Board-to-SPI clock frequency scale 
    parameter MAX_LAGS = 17                  // Maximum Correlation delay in num of samples
    parameter CPU_BITS = 32                  // Number of bits used for CPU communication
) (
    // -- Clock and reset
    input  logic                                        clk,
    input  logic                                        rst,

    // -- CPU interface (Avalon--MM Slave)
    output logic[CPU_BITS-1:0]                          result,
    
    // -- FPGA interface
    input  logic[NUM_SLAVES-1:0][$clog2(MAX_LAGS):0]    lags,
    input  logic                                        //Something here
);

    // -- Assign statements
    

endmodule