// ============================================================
// Unitate de Impartire - Restoring Division (FIXED)
// Dividend: 8-bit unsigned, Divisor: 8-bit unsigned
// ============================================================
module restoring_div(
    input        clk,
    input        reset,
    input        start,
    input  [7:0] dividend,
    input  [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg       done,
    output           div_by_zero
);
    reg [7:0]  A;       // Remainder partial (acumulator)
    reg [7:0]  Q;       // Quotient (initial = dividend)
    reg [7:0]  M;       // Divisor
    reg [3:0]  count;
    reg        running;

    assign div_by_zero = (divisor == 8'b0);

    always @(posedge clk) begin
        if (reset) begin
            A         <= 8'b0;
            Q         <= 8'b0;
            M         <= 8'b0;
            count     <= 4'd0;
            running   <= 1'b0;
            done      <= 1'b0;
            quotient  <= 8'b0;
            remainder <= 8'b0;
        end
        else if (start && !running && !div_by_zero) begin
            A         <= 8'b0;
            Q         <= dividend;
            M         <= divisor;
            count     <= 4'd0;
            running   <= 1'b1;
            done      <= 1'b0;
        end
        else if (running) begin
            // --- Pas Restoring Division ---
            // 1. Shift stanga A:Q cu 1 bit
            // 2. A = A - M
            // 3. Daca A[7]=1 (negativ): restore A (A = A + M), Q[0] = 0
            //    Daca A[7]=0 (pozitiv): Q[0] = 1
            begin : div_step
                reg [7:0] A_shift;
                reg [7:0] A_sub;
                reg [7:0] A_next;
                reg       q_bit;

                // Shift stanga A:Q
                A_shift = {A[6:0], Q[7]};
                Q       <= {Q[6:0], 1'b0};

                // Scadere
                A_sub = A_shift - M;

                if (A_sub[7] == 1'b1) begin
                    // Negativ => restore
                    A_next = A_shift;  // restore
                    q_bit  = 1'b0;
                end else begin
                    A_next = A_sub;
                    q_bit  = 1'b1;
                end

                A    <= A_next;
                Q[0] <= q_bit;
            end

            count <= count + 4'd1;

            if (count == 4'd7) begin
                running <= 1'b0;
                done    <= 1'b1;
            end
        end
        else if (done) begin
            quotient  <= Q;
            remainder <= A;
            done      <= 1'b0;
        end
    end

endmodule
