// Copyright

module Mem #(
    parameter NUM_BITS                  = 12;
    parameter NUM_SLAVES                = 5;
    parameter 
) (
    input  logic                                    clk;
    input  logic                                    rst;
    input  logic[NUM_SLAVES-1:0][NUM_BITS-1:0]      dataIn;
);

// Need edge detector???

endmodule