// ============================================================
// Control Unit - FSM
// OpCode: 00=ADD, 01=SUB, 10=MUL (Booth), 11=DIV (Restoring)
// ============================================================
module control_unit(
    input      clk,
    input      reset,
    input      start,
    input [1:0] opcode,
    input      mul_done,
    input      div_done,

    output reg load_A,
    output reg load_B,
    output reg load_M,
    output reg load_Q,
    output reg shift_en,
    output reg mux_sel,
    output reg counter_en,
    output reg [1:0] alu_op,   // 00=add, 01=sub, 10=mul, 11=div
    output reg result_ready
);
    // State encoding
    parameter IDLE    = 3'd0;
    parameter LOAD    = 3'd1;
    parameter EXEC_AS = 3'd2;  // Add/Sub (1 ciclu)
    parameter EXEC_MU = 3'd3;  // Multiply (iterativ)
    parameter EXEC_DV = 3'd4;  // Divide (iterativ)
    parameter DONE    = 3'd5;

    reg [2:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:    if (start)           next_state = LOAD;
            LOAD:                         next_state = (opcode == 2'b00 || opcode == 2'b01) ?
                                                        EXEC_AS :
                                                       (opcode == 2'b10) ? EXEC_MU : EXEC_DV;
            EXEC_AS:                      next_state = DONE;
            EXEC_MU: if (mul_done)        next_state = DONE;
            EXEC_DV: if (div_done)        next_state = DONE;
            DONE:                         next_state = IDLE;
            default:                      next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        // Valori default
        load_A      = 1'b0;
        load_B      = 1'b0;
        load_M      = 1'b0;
        load_Q      = 1'b0;
        shift_en    = 1'b0;
        mux_sel     = 1'b0;
        counter_en  = 1'b0;
        alu_op      = opcode;
        result_ready = 1'b0;

        case (state)
            LOAD: begin
                load_A = 1'b1;
                load_B = 1'b1;
                load_M = (opcode == 2'b10 || opcode == 2'b11) ? 1'b1 : 1'b0;
                load_Q = (opcode == 2'b10 || opcode == 2'b11) ? 1'b1 : 1'b0;
            end
            EXEC_AS: begin
                mux_sel = (opcode == 2'b01) ? 1'b1 : 1'b0; // 1=sub
            end
            EXEC_MU: begin
                shift_en   = 1'b1;
                counter_en = 1'b1;
            end
            EXEC_DV: begin
                shift_en   = 1'b1;
                counter_en = 1'b1;
            end
            DONE: begin
                result_ready = 1'b1;
            end
        endcase
    end

endmodule
