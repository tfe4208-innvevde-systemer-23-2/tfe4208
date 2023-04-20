// Based on https://www.chipverify.com/verilog/verilog-positive-edge-detector


module edgeDetector #() (
    input  logic    in, // The signal we are looking for positive edges in
    input  logic    clk,

    output logic    positiveEdge // Gives a pulse when a positive edge is detected
);  

    logic inDelay;

    assign positiveEdge = in & !inDelay;

    // Delay the input with one cycle
    always_ff @(posedge clk) begin
        inDelay <= in;
    end
    
endmodule