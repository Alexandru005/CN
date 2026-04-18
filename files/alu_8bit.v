// ============================================================
// ALU 8-BIT - Modul Top-Level (FIXED)
// OpCode: 00=ADD, 01=SUB, 10=MUL (Booth R2), 11=DIV (Restoring)
// ============================================================
module alu_8bit(
    input        clk,
    input        reset,
    input        start,
    input  [1:0] opcode,
    input  [7:0] input_A,
    input  [7:0] input_B,

    output [15:0] result,
    output [7:0]  quotient,
    output [7:0]  remainder,
    output        result_ready,
    output        div_by_zero,

    output        flag_N,
    output        flag_Z,
    output        flag_C,
    output        flag_V
);
    // ---- Semnale interne ----
    wire       load_A, load_B, load_M, load_Q;
    wire       shift_en, mux_sel, counter_en;
    wire [1:0] alu_op;
    wire       mul_done, div_done;

    wire [7:0] addsub_result;
    wire       addsub_cout, addsub_ovf;
    wire [15:0] mul_product;
    wire [7:0]  div_quotient, div_remainder;

    // ---- Control Unit ----
    control_unit CU(
        .clk(clk), .reset(reset), .start(start), .opcode(opcode),
        .mul_done(mul_done), .div_done(div_done),
        .load_A(load_A), .load_B(load_B),
        .load_M(load_M), .load_Q(load_Q),
        .shift_en(shift_en), .mux_sel(mux_sel),
        .counter_en(counter_en), .alu_op(alu_op),
        .result_ready(result_ready)
    );

    // ---- Adder/Subtractor 8b (combinational, foloseste input direct) ----
    adder_subtractor_8b ASU(
        .A(input_A),
        .B(input_B),
        .sub(opcode[0]),   // opcode=01 => sub=1
        .result(addsub_result),
        .cout(addsub_cout),
        .overflow(addsub_ovf)
    );

    // ---- Inmultire Booth Radix-2 ----
    booth_mult MULT(
        .clk(clk), .reset(reset),
        .start(start && (opcode == 2'b10)),
        .multiplicand(input_A),
        .multiplier(input_B),
        .product(mul_product),
        .done(mul_done)
    );

    // ---- Impartire Restoring ----
    restoring_div DIV(
        .clk(clk), .reset(reset),
        .start(start && (opcode == 2'b11)),
        .dividend(input_A),
        .divisor(input_B),
        .quotient(div_quotient),
        .remainder(div_remainder),
        .done(div_done),
        .div_by_zero(div_by_zero)
    );

    // ---- Result Bus ----
    assign result = (opcode == 2'b10) ? mul_product :
                    (opcode == 2'b11) ? {8'b0, div_quotient} :
                                        {8'b0, addsub_result};

    assign quotient  = div_quotient;
    assign remainder = div_remainder;

    // ---- Status Flags ----
    assign flag_N = addsub_result[7];
    assign flag_Z = (addsub_result == 8'b0);
    assign flag_C = addsub_cout;
    assign flag_V = addsub_ovf;

endmodule
