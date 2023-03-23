// Copyright

module Fsm #(
    // -- Parameters
    parameter MAX_LAGS = 17
) (
    // -- Clock and reset
    input  logic                            clk,
    input  logic                            rst,

    // --
    input  logic                            enable,

    // --
    output logic[$clog2(2*MAX_LAGS)-1:0]    iterator,
    output logic                            dataOutValid,
    output logic                            rstInternal
);

    // -- FSM States --
    typedef enum logic[1:0] {IDLE, CALCULATING, DONE} states;
    states state;
    states nextState;

    // -- Internal signals --
    logic[$clog2(2*MAX_LAGS)-1:0]   cnt;                        // Counter for multi-cycle states

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
                if (enable) begin
                    nextState <= CALCULATING;
                end
                else begin
                    nextState <= IDLE;
                end

                dataOutValid <= 1'b0;
                rstInternal <= 1'b0;
            end

            CALCULATING: begin
                if (cnt == (2*MAX_LAGS-1)) begin
                    nextState <= DONE;
                end
                else begin
                    nextState <= CALCULATING;
                end

                dataOutValid <= 1'b0;
                rstInternal <= 1'b0;
            end

            DONE: begin
                nextState <= IDLE;

                dataOutValid <= 1'b1;
                rstInternal <= 1'b1;
            end

            default: nextState = IDLE;
        endcase
    end

endmodule