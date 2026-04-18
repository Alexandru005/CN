// ============================================================
// Multiplexor 2:1 pe 8 biti
// sel=0 => out=A, sel=1 => out=B
// ============================================================
module mux_2to1_8b(
    input  [7:0] A,
    input  [7:0] B,
    input        sel,
    output [7:0] out
);
    wire [7:0] w_and0, w_and1;
    wire       sel_n;

    not NOT0(sel_n, sel);

    and AND0_0(w_and0[0], A[0], sel_n);
    and AND0_1(w_and0[1], A[1], sel_n);
    and AND0_2(w_and0[2], A[2], sel_n);
    and AND0_3(w_and0[3], A[3], sel_n);
    and AND0_4(w_and0[4], A[4], sel_n);
    and AND0_5(w_and0[5], A[5], sel_n);
    and AND0_6(w_and0[6], A[6], sel_n);
    and AND0_7(w_and0[7], A[7], sel_n);

    and AND1_0(w_and1[0], B[0], sel);
    and AND1_1(w_and1[1], B[1], sel);
    and AND1_2(w_and1[2], B[2], sel);
    and AND1_3(w_and1[3], B[3], sel);
    and AND1_4(w_and1[4], B[4], sel);
    and AND1_5(w_and1[5], B[5], sel);
    and AND1_6(w_and1[6], B[6], sel);
    and AND1_7(w_and1[7], B[7], sel);

    or OR0(out[0], w_and0[0], w_and1[0]);
    or OR1(out[1], w_and0[1], w_and1[1]);
    or OR2(out[2], w_and0[2], w_and1[2]);
    or OR3(out[3], w_and0[3], w_and1[3]);
    or OR4(out[4], w_and0[4], w_and1[4]);
    or OR5(out[5], w_and0[5], w_and1[5]);
    or OR6(out[6], w_and0[6], w_and1[6]);
    or OR7(out[7], w_and0[7], w_and1[7]);

endmodule
