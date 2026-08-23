// Code your design here
module vending_machine (
    input  wire       clk,
    input  wire       reset,

    input  wire       coin_5,
    input  wire       coin_10,
    input  wire       coin_20,

    output reg        dispense,
    output reg        change_5,
    output reg        change_10
);

    //================================================
    // States
    //================================================
    parameter S0 = 2'b00;   // ₹0 collected
    parameter S5 = 2'b01;   // ₹5 collected

    reg [1:0] current_state;
    reg [1:0] next_state;

    //================================================
    // State Register
    //================================================
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    //================================================
    // Next State Logic
    //================================================
    always @(*) begin

        // Default
        next_state = current_state;

        case (current_state)

            //========================================
            // ₹0 State
            //========================================
            S0: begin

                if (coin_5)
                    next_state = S5;

                else if (coin_10 || coin_20)
                    next_state = S0;

                else
                    next_state = S0;

            end

            //========================================
            // ₹5 State
            //========================================
            S5: begin

                if (coin_5 || coin_10 || coin_20)
                    next_state = S0;

                else
                    next_state = S5;

            end

            default:
                next_state = S0;

        endcase

    end

    //================================================
    // Output Logic
    //================================================
    always @(*) begin

        // Default outputs
        dispense = 1'b0;
        change_5  = 1'b0;
        change_10 = 1'b0;

        case (current_state)

            //========================================
            // ₹0 State
            //========================================
            S0: begin

                // ₹10 inserted
                if (coin_10) begin
                    dispense = 1'b1;
                end

                // ₹20 inserted
                else if (coin_20) begin
                    dispense = 1'b1;
                    change_10 = 1'b1;
                end

            end

            //========================================
            // ₹5 State
            //========================================
            S5: begin

                // ₹5 + ₹5 = ₹10
                if (coin_5) begin
                    dispense = 1'b1;
                end

                // ₹5 + ₹10 = ₹15
                else if (coin_10) begin
                    dispense = 1'b1;
                    change_5 = 1'b1;
                end

                // ₹5 + ₹20 = ₹25
                else if (coin_20) begin
                    dispense = 1'b1;
                    change_5 = 1'b1;
                    change_10 = 1'b1;
                end

            end

        endcase

    end

endmodule
