//////////////////////////////////////////////////
// Title:           CpuPeripheral
// Author:          Mathias Støle
// Date:            09.03.2023
// Description:     
////////////////////////////////////////////////////

module CpuPeripheral (
    // -- Parameters --
    // Avalon slaves does not support parametrized signals :(
    // Signal widths below use:
    //  - NUM_XCORRS      = 6
    //  - MAX_LAGS        = 11          
    //  - BITS_PER_XCORR  = 5,          $clog2(2*MAX_LAGS+1) 
    //  - CPU_BITS        = 32

    // -- Clock and reset
    input  logic                                        clk,            // Avalon slave CPU clock
    input  logic                                        reset,          // Avalon slave uses "reset" instead of "rst" :(

    // -- CPU interface (Avalon--MM Slave)
    input  logic                                        address,        // Avalon slave instruction selection
    output logic[31:0]                                  readdata,       // Avalon slave Data output
    
    // -- FPGA interface
    input  logic[29:0]                                  dataIn,         // Avalon slaves does not support 2D signals, merge into 1D.
                                                                        // ^ Also does not support parametrized signal width,
                                                                        //   we need 30 bit wide signal for MAX_LAGS < 16
    input  logic                                        dataInValid,    // Data input is valid

    input  logic[31:0]                                  debugData,
    input  logic                                        debugDataValid

);

    // Internal signals
    logic[29:0]         dataInInternal;         // [NUM_XCORRS-1:0][$clog2(2*MAX_LAGS+1)-1:0]
    logic[31:0]         debugDataInternal;

    // Instruction decoding
    always_comb begin
        case (address)
            0: begin // Transmit the calculated lags. 2 bits unused right now
                readdata = {1'b1, 1'b0, dataInInternal};
            end

            1: begin // Transmit debug data, whatever is on the 
                readdata = debugDataInternal;
            end

            default: readdata = '0;
        endcase
    end

    // Clock in new data on internal register
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dataInInternal <= '0;
        end
        else begin
            if (dataInValid) begin
                dataInInternal <= dataIn;
            end
            else begin
                dataInInternal <= dataInInternal;
            end
        end
    end

    // Clock in new debug info on internal register
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            debugDataInternal <= '0;
        end
        else begin
            if (debugDataValid) begin
                debugDataInternal <= debugData;
            end
            else begin
               debugDataInternal <= debugDataInternal;
            end
        end
    end
    

endmodule