// Copyright

module fsm (
    parameter SAMPLE_TIME       = 2;                // Clock cycles needed for ADC sampling
    parameter NUM_BITS          = 12                // Excluding Null bit
) (
    input  logic            clk;
    input  logic            rst;

    output logic            dataInEnable;
    output logic            chipEnable;
    output logic            busClkEnable;
    output logic            dataOutValid
);

    // -- Internal signals
    logic[$clod2(NUM_BITS+1)-1:0] cnt;        // Counter for multi-cycle states

    // -- Main counter
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= '0;
        end
        else begin
            if (state != nextState) begin
                cnt <= '0;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end

    // -- FSM States
    enum logic[1:0] {INIT, CHIPENABLE, SAMPLE, TRANSFER} states;
    states state;
    states nextState;

    // -- Main FSM
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INIT;
        end else begin
            state <= nextState;
        end
    end

    always_comb begin
        case (state)
            INIT: begin
                nextState <= CHIPENABLE;

                dataInEnable = 0;
                chipEnable = 0;
                busClkEnable = 0;
                dataOutValid = 0;
            end

            CHIPENABLE: begin
                nextState <= SAMPLE;

                chipEnable = 1;
                busClkEnable = 0;
                dataInEnable = 0;
            end

            SAMPLE: begin
                if (cnt == SAMPLE_TIME-1) begin
                    nextState <= TRANSFER;
                end
                else begin
                    nextState <= SAMPLE;
                end

                dataInEnable = 0;
                chipEnable = 0;
                busClkEnable = 1;
            end

            TRANSFER: begin
                if (cnt == NUM_BITS) begin      // Including one null-bit cycle
                    nextState <= CHIPENABLE;
                    dataOutValid = 1;           // This might lead to latch, but oh well
                end 
                else begin
                    nextState <= TRANSFER;
                    dataOutValid = 0;
                end

                dataInEnable = 1;
                chipEnable = 0;
                busClkEnable = 1;
            end

            default: nextState = INIT;
        endcase
    end

endmodule