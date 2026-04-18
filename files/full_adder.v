// ============================================================
// Full Adder - 1 bit
// ============================================================
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire w1, w2, w3;

    xor U1(w1, a, b);
    xor U2(sum, w1, cin);
    and U3(w2, a, b);
    and U4(w3, w1, cin);
    or  U5(cout, w2, w3);

endmodule
