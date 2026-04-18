// ============================================================
// Unitate de Inmultire - Booth Radix-2 (FIXED)
// Un singur always block pentru a evita conflicte
// ============================================================
module booth_mult(
    input        clk,
    input        reset,
    input        start,
    input  [7:0] multiplicand,
    input  [7:0] multiplier,
    output reg [15:0] product,
    output reg        done
);
    reg [8:0] A;      // 9 biti (bit extra pentru semn la add/sub)
    reg [7:0] Q;
    reg       Q1;
    reg [7:0] M;
    reg [3:0] count;
    reg       running;

    wire [8:0] M_ext  = {{1{multiplicand[7]}}, multiplicand}; // sign extend M la 9 biti

    always @(posedge clk) begin
        if (reset) begin
            A       <= 9'b0;
            Q       <= 8'b0;
            M       <= 8'b0;
            Q1      <= 1'b0;
            count   <= 4'd0;
            running <= 1'b0;
            done    <= 1'b0;
            product <= 16'b0;
        end
        else if (start && !running) begin
            A       <= 9'b0;
            Q       <= multiplier;
            M       <= multiplicand;
            Q1      <= 1'b0;
            count   <= 4'd0;
            running <= 1'b1;
            done    <= 1'b0;
            product <= 16'b0;
        end
        else if (running) begin
            // --- Pasul 1: Operatie Booth pe A ---
            case ({Q[0], Q1})
                2'b01: begin  // +M
                    // Shift aritmetic dupa adunare
                    begin : add_shift
                        reg [8:0] A_new;
                        A_new = A + {{1{M[7]}}, M};
                        Q1 <= Q[0];
                        Q  <= {A_new[0], Q[7:1]};
                        A  <= {A_new[8], A_new[8:1]};
                    end
                end
                2'b10: begin  // -M
                    begin : sub_shift
                        reg [8:0] A_new;
                        A_new = A - {{1{M[7]}}, M};
                        Q1 <= Q[0];
                        Q  <= {A_new[0], Q[7:1]};
                        A  <= {A_new[8], A_new[8:1]};
                    end
                end
                default: begin  // 00 sau 11 - doar shift
                    Q1 <= Q[0];
                    Q  <= {A[0], Q[7:1]};
                    A  <= {A[8], A[8:1]};
                end
            endcase

            count <= count + 4'd1;

            if (count == 4'd7) begin
                running <= 1'b0;
                done    <= 1'b1;
            end
        end
        else if (done) begin
            product <= {A[7:0], Q};
            done    <= 1'b0;
        end
    end

endmodule
