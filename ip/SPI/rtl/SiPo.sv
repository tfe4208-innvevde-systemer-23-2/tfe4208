// Copyright

// Blablabbla
// Left to right shifting => MSB first on dataIn, LSB last on dataIn

module SiPo #(
    parameter NUM_BITS = 12               // Number of bits in SPI word
) (
    input  logic                    clk,
    input  logic                    dataIn,
    input  logic                    enable,

    output logic [NUM_BITS-1:0]    dataOut
);

    always_ff @(posedge clk) begin
        if (enable) begin
            dataOut <= {dataOut[NUM_BITS-2:0], dataIn};
        end
        else begin
            dataOut <= dataOut;
        end
    end

endmodule