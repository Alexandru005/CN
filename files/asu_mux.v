// ============================================================
// ASU MUX - Selecteaza operatia ADD sau SUB
// sel=0 => ADD (sub=0), sel=1 => SUB (sub=1)
// Corespunde "ASU Mux" din schema hardware
// ============================================================
module asu_mux(
    input      sel,
    output     sub
);
    assign sub = sel;
endmodule
