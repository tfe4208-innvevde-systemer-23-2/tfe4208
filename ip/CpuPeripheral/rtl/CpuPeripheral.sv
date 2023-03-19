//////////////////////////////////////////////////
// Title:           CpuPeripheral
// Author:          Mathias Støle
// Date:            09.03.2023
// Description:     
////////////////////////////////////////////////////

module CpuPeripheral #(
    // -- Parameters --
    parameter NUM_SLAVES = 4,                // Number of SPI channels
    parameter MAX_LAGS = 17,                 // Maximum Correlation delay in num of samples (has to be < 32)
    parameter CPU_BITS = 32                  // Number of bits used for CPU communication
) (
    // -- Clock and reset
    input  logic                                        clk,
    input  logic                                        reset,          // Avalon Slave uses "reset" instead of "rst" :(

    // -- CPU interface (Avalon--MM Slave)
    output logic[31:0]                                  readdata,
    
    // -- FPGA interface
    input  logic[23:0]                                  dataIn,         // Avalog Slaves does not support 2D signals, merge into 1D.
                                                                        // ^ Also does not support parametrized signal width,
                                                                        //   we need 24 bit wide signal for MAX_LAGS < 32
    input  logic                                        dataInValid       
);

    // -- Assign statements
    assign readdata = {dataInValid, {(CPU_BITS-NUM_SLAVES*$clog2(2*MAX_LAGS)-1){1'b0}}, dataIn};
    // This solution might be too simple
    // Might have to have edge detectors and syncronizers
    

endmodule