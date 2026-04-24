// ============================================================
// Testbench - ALU 8-BIT
// Fara flags N,Z,C,V (conform schema hardware)
// ============================================================
`timescale 1ns/1ps

module tb_alu_8bit;

    reg        clk, reset, start;
    reg  [1:0] opcode;
    reg  [7:0] input_A, input_B;

    wire [15:0] result;
    wire [7:0]  quotient, remainder;
    wire        result_ready, div_by_zero;

    alu_8bit DUT(
        .clk(clk), .reset(reset), .start(start),
        .opcode(opcode), .input_A(input_A), .input_B(input_B),
        .result(result), .quotient(quotient), .remainder(remainder),
        .result_ready(result_ready), .div_by_zero(div_by_zero)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task wait_cycles;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1)
                @(posedge clk);
            #1;
        end
    endtask

    task do_start;
        begin
            @(posedge clk); #1;
            start = 1;
            @(posedge clk); #1;
            start = 0;
        end
    endtask

    integer pass_count;
    integer fail_count;

    initial begin
        $dumpfile("tb_alu_8bit.vcd");
        $dumpvars(0, tb_alu_8bit);

        pass_count = 0;
        fail_count = 0;

        reset = 1; start = 0;
        opcode = 2'b00; input_A = 0; input_B = 0;
        wait_cycles(3);
        reset = 0;
        wait_cycles(2);

        // ==========================================
        // ADUNARE (opcode = 00)
        // ==========================================
        $display("\n========== ADUNARE (ADD) ==========");

        input_A = 8'd15; input_B = 8'd27; opcode = 2'b00;
        do_start; wait_cycles(3);
        if (result[7:0] == 8'd42) begin
            $display("[PASS] ADD  15 + 27 = %0d", result[7:0]);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] ADD  15 + 27 = %0d (asteptat 42)", result[7:0]);
            fail_count = fail_count + 1;
        end

        input_A = 8'd0; input_B = 8'd0; opcode = 2'b00;
        do_start; wait_cycles(3);
        if (result[7:0] == 8'd0) begin
            $display("[PASS] ADD   0 +  0 = %0d", result[7:0]);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] ADD   0 +  0 = %0d (asteptat 0)", result[7:0]);
            fail_count = fail_count + 1;
        end

        input_A = 8'd100; input_B = 8'd55; opcode = 2'b00;
        do_start; wait_cycles(3);
        if (result[7:0] == 8'd155) begin
            $display("[PASS] ADD 100 + 55 = %0d", result[7:0]);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] ADD 100 + 55 = %0d (asteptat 155)", result[7:0]);
            fail_count = fail_count + 1;
        end

        // ==========================================
        // SCADERE (opcode = 01)
        // ==========================================
        $display("\n========== SCADERE (SUB) ==========");

        input_A = 8'd50; input_B = 8'd20; opcode = 2'b01;
        do_start; wait_cycles(3);
        if (result[7:0] == 8'd30) begin
            $display("[PASS] SUB  50 - 20 = %0d", result[7:0]);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] SUB  50 - 20 = %0d (asteptat 30)", result[7:0]);
            fail_count = fail_count + 1;
        end

        input_A = 8'd10; input_B = 8'd10; opcode = 2'b01;
        do_start; wait_cycles(3);
        if (result[7:0] == 8'd0) begin
            $display("[PASS] SUB  10 - 10 = %0d", result[7:0]);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] SUB  10 - 10 = %0d (asteptat 0)", result[7:0]);
            fail_count = fail_count + 1;
        end

        input_A = 8'd10; input_B = 8'd30; opcode = 2'b01;
        do_start; wait_cycles(3);
        if ($signed(result[7:0]) == -8'sd20) begin
            $display("[PASS] SUB  10 - 30 = %0d (negativ)", $signed(result[7:0]));
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] SUB  10 - 30 = %0d (asteptat -20)", $signed(result[7:0]));
            fail_count = fail_count + 1;
        end

        // ==========================================
        // INMULTIRE - Booth Radix-2 (opcode = 10)
        // ==========================================
        $display("\n========== INMULTIRE - Booth Radix-2 ==========");

        input_A = 8'd6; input_B = 8'd7; opcode = 2'b10;
        do_start; wait_cycles(20);
        if (result == 16'd42) begin
            $display("[PASS] MUL   6 x  7 = %0d", result);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] MUL   6 x  7 = %0d (asteptat 42)", result);
            fail_count = fail_count + 1;
        end

        input_A = 8'd0; input_B = 8'd255; opcode = 2'b10;
        do_start; wait_cycles(20);
        if (result == 16'd0) begin
            $display("[PASS] MUL   0 x255 = %0d", result);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] MUL   0 x255 = %0d (asteptat 0)", result);
            fail_count = fail_count + 1;
        end

        input_A = 8'hFC; input_B = 8'd3; opcode = 2'b10;
        do_start; wait_cycles(20);
        if ($signed(result) == -16'sd12) begin
            $display("[PASS] MUL  -4 x  3 = %0d", $signed(result));
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] MUL  -4 x  3 = %0d (asteptat -12)", $signed(result));
            fail_count = fail_count + 1;
        end

        input_A = 8'd15; input_B = 8'd15; opcode = 2'b10;
        do_start; wait_cycles(20);
        if (result == 16'd225) begin
            $display("[PASS] MUL  15 x 15 = %0d", result);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] MUL  15 x 15 = %0d (asteptat 225)", result);
            fail_count = fail_count + 1;
        end

        // ==========================================
        // IMPARTIRE - Restoring Division (opcode = 11)
        // ==========================================
        $display("\n========== IMPARTIRE - Restoring Division ==========");

        input_A = 8'd42; input_B = 8'd6; opcode = 2'b11;
        do_start; wait_cycles(20);
        if (quotient == 8'd7 && remainder == 8'd0) begin
            $display("[PASS] DIV  42 /  6 = %0d rest %0d", quotient, remainder);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] DIV  42 /  6 = %0d rest %0d (asteptat 7 rest 0)", quotient, remainder);
            fail_count = fail_count + 1;
        end

        input_A = 8'd17; input_B = 8'd5; opcode = 2'b11;
        do_start; wait_cycles(20);
        if (quotient == 8'd3 && remainder == 8'd2) begin
            $display("[PASS] DIV  17 /  5 = %0d rest %0d", quotient, remainder);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] DIV  17 /  5 = %0d rest %0d (asteptat 3 rest 2)", quotient, remainder);
            fail_count = fail_count + 1;
        end

        input_A = 8'd100; input_B = 8'd10; opcode = 2'b11;
        do_start; wait_cycles(20);
        if (quotient == 8'd10 && remainder == 8'd0) begin
            $display("[PASS] DIV 100 / 10 = %0d rest %0d", quotient, remainder);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] DIV 100 / 10 = %0d rest %0d (asteptat 10 rest 0)", quotient, remainder);
            fail_count = fail_count + 1;
        end

        input_A = 8'd10; input_B = 8'd0; opcode = 2'b11;
        do_start; wait_cycles(5);
        if (div_by_zero == 1) begin
            $display("[PASS] DIV  10 /  0 => div_by_zero=%b", div_by_zero);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] DIV  10 /  0 => div_by_zero=%b (asteptat 1)", div_by_zero);
            fail_count = fail_count + 1;
        end

        $display("\n==========================================");
        $display("REZULTATE: %0d PASS / %0d FAIL", pass_count, fail_count);
        $display("==========================================\n");

        $finish;
    end

endmodule
