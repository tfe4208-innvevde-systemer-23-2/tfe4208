// Copyright

module fsm #(
    parameter SAMPLE_TIME       = 2,                // Clock cycles needed for ADC sampling
    parameter NUM_BITS          = 12                // Excluding Null bit
) (
    input  logic            clk,
    input  logic            rst,

    output logic            dataInEnable,
    output logic            chipEnable,
    output logic            busClkEnable,
    output logic            dataOutValid
);

    // -- FSM States --
    typedef enum logic[1:0] {IDLE, CHIPENABLE, SAMPLE, TRANSFER} states;
    states state;
    states nextState;

    // -- Internal signals --
    logic[$clog2(NUM_BITS+1)-1:0]   cnt;                        // Counter for multi-cycle states
    logic                           dataOutValidInternal;       // Combinatorial signal for dataOutValid
                                                                //  ^ This also removes any risk of glitches on the output 

    // -- Main counter --
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= '0;
        end
        else begin
            if (state != nextState) begin
                cnt <= '0;
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    // -- DataOutValid control --
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            dataOutValid <= 1'b0;
        end
        else begin
            if (state == TRANSFER) begin
                if (nextState == CHIPENABLE) begin
                    dataOutValid <= 1'b1;
                end
                else begin
                    dataOutValid <= 1'b0;
                end
            end
            else begin
                dataOutValid <= dataOutValid;
            end
        end
    end
    
    // -- Main FSM --
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= nextState;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                nextState <= CHIPENABLE;

                dataInEnable = 0;
                chipEnable = 0;
                busClkEnable = 0;
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
                end 
                else begin
                    nextState <= TRANSFER;
                end

                dataInEnable = 1;
                chipEnable = 0;
                busClkEnable = 1;
            end

            default: nextState = IDLE;
        endcase
    end

endmodule