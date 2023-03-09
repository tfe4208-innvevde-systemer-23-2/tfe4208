// Copyright

module Spi_test;

    // Parameters 
    parameter NUM_SLAVES = 1;                // Number of SPI channels
    parameter NUM_BITS = 12;                 // Number of bits in SPI word
    parameter SAMPLE_TIME = 2;               // Number of cycles to wait for ADCs to sample data
    parameter FREQ_SCALE = 4;               // Board-to-SPI clock frequency scale 

    // Clock and reset
    logic                                   clk50M;     // Main clock
    logic                                   rst;

    // SPI bus signals
    logic                                   busClk;
    logic[NUM_SLAVES-1:0]                   dataIn;
    logic                                   chipEnable;

    // Output signals
    logic                                   dataOutValid;
    logic[NUM_SLAVES-1:0][NUM_BITS-1:0]     dataOut;

    // DUT
    Spi #(
        .NUM_SLAVES     (NUM_SLAVES),
        .NUM_BITS       (NUM_BITS),
        .SAMPLE_TIME    (SAMPLE_TIME),
        .FREQ_SCALE     (FREQ_SCALE)
    ) dut (
        .clk            (clk50M),
        .rst            (rst),

        .dataIn         (dataIn),

        .chipEnable     (chipEnable),
        .busClk         (busClk),
        
        .dataOutValid   (dataOutValid),
        .dataOut        (dataOut)
    );
    
    initial begin
        clk50M = 1'b0;
        stim;
        //@(posedge clk50M); $finish(2);
    end

    // Generate clock
    always #10 clk50M=!clk50M;

    always #80 dataIn=!dataIn;

    always @(posedge clk50M) 
        $display($stime,,,"rst=%b busClk=%b DIN=%0b CE=%b Valid_out=%b DataOut=%b state=%b sipoEn=%b",
	        rst, busClk, dataIn, chipEnable, dataOutValid, dataOut, dut.u_fsm.state, dut.dataInEnable);
   

    task stim;
        rst=1'b0; dataIn = 1'b0;
        @(negedge clk50M) rst=1'b1;
        @(negedge clk50M) rst=1'b0;
    endtask

endmodule