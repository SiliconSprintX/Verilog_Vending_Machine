// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_vending_machine;

    //================================================
    // Testbench Signals
    //================================================
    reg clk;
    reg reset;

    reg coin_5;
    reg coin_10;
    reg coin_20;

    wire dispense;
    wire change_5;
    wire change_10;

    //================================================
    // DUT
    //================================================
    vending_machine DUT (
        .clk       (clk),
        .reset     (reset),
        .coin_5    (coin_5),
        .coin_10   (coin_10),
        .coin_20   (coin_20),
        .dispense  (dispense),
        .change_5  (change_5),
        .change_10 (change_10)
    );

    //================================================
    // Clock Generation
    //================================================
    always #5 clk = ~clk;

    //================================================
    // Waveform Generation
    //================================================
    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, tb_vending_machine);
    end

    //================================================
    // Task: Insert ₹5
    //================================================
    task insert_5;
        begin
            coin_5 = 1'b1;

            @(posedge clk);
            #1;

            coin_5 = 1'b0;

            display_result("₹5");
        end
    endtask

    //================================================
    // Task: Insert ₹10
    //================================================
    task insert_10;
        begin
            coin_10 = 1'b1;

            @(posedge clk);
            #1;

            coin_10 = 1'b0;

            display_result("₹10");
        end
    endtask

    //================================================
    // Task: Insert ₹20
    //================================================
    task insert_20;
        begin
            coin_20 = 1'b1;

            @(posedge clk);
            #1;

            coin_20 = 1'b0;

            display_result("₹20");
        end
    endtask

    //================================================
    // Display Results
    //================================================
    task display_result;
        input [31:0] coin_value;

        begin
            $display(
                "Time=%0t | Coin=%s | State=%b | Dispense=%b | Change5=%b | Change10=%b",
                $time,
                coin_value,
                DUT.current_state,
                dispense,
                change_5,
                change_10
            );
        end
    endtask

    //================================================
    // Test Cases
    //================================================
    initial begin

        // Initial values
        clk     = 1'b0;
        reset   = 1'b1;

        coin_5  = 1'b0;
        coin_10 = 1'b0;
        coin_20 = 1'b0;

        // Reset
        #12;
        reset = 1'b0;

        $display("\n==========================================");
        $display("       VENDING MACHINE TEST");
        $display("       Product Price = ₹10");
        $display("==========================================\n");

        //================================================
        // TEST 1
        // ₹10 → Product
        //================================================

        $display("TEST 1: Insert ₹10");

        insert_10;

        //================================================
        // TEST 2
        // ₹5 + ₹5 → Product
        //================================================

        $display("\nTEST 2: Insert ₹5 + ₹5");

        insert_5;
        insert_5;

        //================================================
        // TEST 3
        // ₹20 → Product + ₹10 Change
        //================================================

        $display("\nTEST 3: Insert ₹20");

        insert_20;

        //================================================
        // TEST 4
        // ₹5 + ₹10 → Product + ₹5 Change
        //================================================

        $display("\nTEST 4: Insert ₹5 + ₹10");

        insert_5;
        insert_10;

        //================================================
        // TEST 5
        // ₹5 + ₹20 → Product + ₹15 Change
        //================================================

        $display("\nTEST 5: Insert ₹5 + ₹20");

        insert_5;
        insert_20;

        #20;

        $display("\n==========================================");
        $display("          SIMULATION COMPLETED");
        $display("==========================================\n");

        $finish;

    end

endmodule
