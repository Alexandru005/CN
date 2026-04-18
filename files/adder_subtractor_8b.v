// ============================================================
// 8-bit Adder/Subtractor
// sub=0 => A+B, sub=1 => A-B (prin complementul fata de 2)
// ============================================================
module adder_subtractor_8b(
    input  [7:0] A,
    input  [7:0] B,
    input        sub,       // 0=adunare, 1=scadere
    output [7:0] result,
    output       cout,
    output       overflow
);
    wire [7:0] B_xor;
    wire [7:0] carry;
    wire       c_in;

    // Daca sub=1, inversam B (XOR cu 1) si cin=1 => complement fata de 2
    assign c_in = sub;

    xor XB0(B_xor[0], B[0], sub);
    xor XB1(B_xor[1], B[1], sub);
    xor XB2(B_xor[2], B[2], sub);
    xor XB3(B_xor[3], B[3], sub);
    xor XB4(B_xor[4], B[4], sub);
    xor XB5(B_xor[5], B[5], sub);
    xor XB6(B_xor[6], B[6], sub);
    xor XB7(B_xor[7], B[7], sub);

    full_adder FA0(A[0], B_xor[0], c_in,     result[0], carry[0]);
    full_adder FA1(A[1], B_xor[1], carry[0], result[1], carry[1]);
    full_adder FA2(A[2], B_xor[2], carry[1], result[2], carry[2]);
    full_adder FA3(A[3], B_xor[3], carry[2], result[3], carry[3]);
    full_adder FA4(A[4], B_xor[4], carry[3], result[4], carry[4]);
    full_adder FA5(A[5], B_xor[5], carry[4], result[5], carry[5]);
    full_adder FA6(A[6], B_xor[6], carry[5], result[6], carry[6]);
    full_adder FA7(A[7], B_xor[7], carry[6], result[7], cout);

    // Overflow: carry in != carry out la bitul de semn
    xor OVF(overflow, carry[6], cout);

endmodule
