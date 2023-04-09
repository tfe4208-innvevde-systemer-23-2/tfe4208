// https://www.chipverify.com/verilog/verilog-positive-edge-detector
// Not made by us

module edgeDetector (
    input  logic    In,
    input  logic    clk,

    output logic    pe, 
);  

    logic InDelay;

    assign pe = In & ~InDelay;

    // Delay the input with one cycle
    always_ff @(positive clk) begin
        InDelay <= In;
    end
    
endmodule