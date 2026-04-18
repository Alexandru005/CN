// ============================================================
// Counter 3-bit (0..7) pentru iteratii Booth / Restoring Div
// ============================================================
module counter_3b(
    input      clk,
    input      reset,
    input      enable,
    output reg [2:0] count,
    output     done        // done=1 cand count==7
);
    assign done = (count == 3'd7);

    always @(posedge clk) begin
        if (reset)
            count <= 3'd0;
        else if (enable)
            count <= count + 3'd1;
    end
endmodule
