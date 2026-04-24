// ============================================================
// ALU 8-BIT - Modul Top-Level
// Corespunde 1:1 cu schema hardware desenata
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
    output        div_by_zero
);

    // ── Semnale Control Unit ──
    wire       load_A, load_B, load_M, load_Q;
    wire       shift_en, mux_sel, counter_en;
    wire [1:0] alu_op;
    wire       mul_done, div_done;

    // ── Semnale interne ──
    wire [7:0] mux_A_out;
    wire [7:0] mux_B_out;
    wire       sub_sel;

    wire [7:0] reg_A_out;
    wire [7:0] reg_B_out;

    wire [7:0] addsub_result;
    wire       addsub_cout;
    wire       addsub_ovf;

    wire [15:0] mul_product;
    wire [7:0]  div_quotient;
    wire [7:0]  div_remainder;

    // ── 1. Control Unit (FSM) ──
    control_unit CU(
        .clk(clk), .reset(reset), .start(start), .opcode(opcode),
        .mul_done(mul_done), .div_done(div_done),
        .load_A(load_A), .load_B(load_B),
        .load_M(load_M), .load_Q(load_Q),
        .shift_en(shift_en), .mux_sel(mux_sel),
        .counter_en(counter_en), .alu_op(alu_op),
        .result_ready(result_ready)
    );

    // ── 2. ASU.A Mux 2:1 x 8bit ──
    mux_2to1_8b MUX_ASU_A(
        .A(input_A), .B(reg_A_out),
        .sel(mux_sel), .out(mux_A_out)
    );

    // ── 3. ASU Mux (selectie ADD/SUB) ──
    // opcode[0]=0 => ADD, opcode[0]=1 => SUB
    asu_mux ASU_MUX(
        .sel(opcode[0]),
        .sub(sub_sel)
    );

    // ── 4. Mux B 2:1 x 8bit ──
    mux_2to1_8b MUX_B(
        .A(input_B), .B(reg_B_out),
        .sel(mux_sel), .out(mux_B_out)
    );

    // ── 5. Reg A Accumulator 8b ──
    reg_8b REG_A(
        .clk(clk), .reset(reset),
        .load(load_A), .d(mux_A_out), .q(reg_A_out)
    );

    // ── 6. Reg B Operand B 8b ──
    reg_8b REG_B(
        .clk(clk), .reset(reset),
        .load(load_B), .d(mux_B_out), .q(reg_B_out)
    );

    // ── 7. Parallel Adder/Subtractor 8b ──
    // sub_sel vine de la ASU Mux (opcode[0])
    adder_subtractor_8b ASU(
        .A(input_A), .B(input_B),
        .sub(sub_sel),
        .result(addsub_result),
        .cout(addsub_cout),
        .overflow(addsub_ovf)
    );

    // ── 8. Booth Radix-2 (Inmultire) ──
    booth_mult MULT(
        .clk(clk), .reset(reset),
        .start(start && (opcode == 2'b10)),
        .multiplicand(input_A), .multiplier(input_B),
        .product(mul_product), .done(mul_done)
    );

    // ── 9. Restoring Division (Impartire) ──
    restoring_div DIV(
        .clk(clk), .reset(reset),
        .start(start && (opcode == 2'b11)),
        .dividend(input_A), .divisor(input_B),
        .quotient(div_quotient), .remainder(div_remainder),
        .done(div_done), .div_by_zero(div_by_zero)
    );

    // ── 10. Result Bus [15:0] ──
    assign result    = (opcode == 2'b10) ? mul_product :
                       (opcode == 2'b11) ? {8'b0, div_quotient} :
                                           {8'b0, addsub_result};
    assign quotient  = div_quotient;
    assign remainder = div_remainder;

endmodule
