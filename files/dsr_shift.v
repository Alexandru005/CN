// ============================================================
// DSR - Arithmetic Shift Right pe perechea A:Q (16 biti total)
// Shift dreapta aritmetic: A[7] (MSB) se pastreaza (semn)
// Q-1 primeste Q[0]
// ============================================================
module dsr_shift(
    input  [7:0] A_in,
    input  [7:0] Q_in,
    output [7:0] A_out,
    output [7:0] Q_out,
    output       Q1_out   // noul Q-1
);
    // A_out: shift dreapta aritmetic (bitul de semn A[7] se pastreaza)
    assign A_out[7] = A_in[7];          // semn se pastreaza
    assign A_out[6] = A_in[7];
    assign A_out[5] = A_in[6];
    assign A_out[4] = A_in[5];
    assign A_out[3] = A_in[4];
    assign A_out[2] = A_in[3];
    assign A_out[1] = A_in[2];
    assign A_out[0] = A_in[1];

    // Q_out: A[0] intra in MSB, restul se shifteaza dreapta
    assign Q_out[7] = A_in[0];
    assign Q_out[6] = Q_in[7];
    assign Q_out[5] = Q_in[6];
    assign Q_out[4] = Q_in[5];
    assign Q_out[3] = Q_in[4];
    assign Q_out[2] = Q_in[3];
    assign Q_out[1] = Q_in[2];
    assign Q_out[0] = Q_in[1];

    // Q-1 primeste fostul Q[0]
    assign Q1_out = Q_in[0];

endmodule
