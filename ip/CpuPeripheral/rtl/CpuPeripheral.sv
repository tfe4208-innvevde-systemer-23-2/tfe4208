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
    //  - MAX_LAGS        = 11          But we use 6 bits per channel
    //  - BITS_PER_XCORR  = 6,          $clog2(2*MAX_LAGS+1) 
    //  - CPU_BITS        = 32

    // -- Clock and reset
    input  logic                                        clk,            // Avalon slave CPU clock
    input  logic                                        reset,          // Avalon slave uses "reset" instead of "rst" :(

    // -- CPU interface (Avalon--MM Slave)
    input  logic                                        address,        // Avalon slave instruction selection
    output logic[31:0]                                  readdata,       // Avalon slave Data output
    
    // -- FPGA interface
    input  logic[35:0]                                  dataIn,         // Avalon slaves does not support 2D signals, merge into 1D.
                                                                        // ^ Also does not support parametrized signal width,
                                                                        //   we need 36 bit wide signal for MAX_LAGS < 32
    input  logic                                        dataInValid     // Data input is valid
);

    // Internal signals
    logic[5:0][5:0]         dataInInternal;         // [NUM_XCORRS-1:0][$clog2(2*MAX_LAGS+1)-1:0]

    // Instruction decoding
    always_comb begin
        case (address)
            0: begin // Transmit lags[2:0]. 13 bits unused right now
                readdata = {{1'b1, {13{1'b0}}}, dataInInternal[2], dataInInternal[1], dataInInternal[0]};
            end

            1: begin // Transmit lags[5:3]. 13 bits unused right now
                readdata = {{1'b1, {13{1'b0}}}, dataInInternal[5], dataInInternal[4], dataInInternal[3]};
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
    

endmodule