// ============================================================
// Registru 1-bit (Q-1 FF pentru Booth Radix-2)
// ============================================================
module reg_1b(
    input      clk,
    input      reset,
    input      load,
    input      d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (load)
            q <= d;
    end
endmodule
