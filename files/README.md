# ALU 8-BIT - Verilog
## Structura fisiere

| Fisier               | Descriere                              |
|----------------------|----------------------------------------|
| full_adder.v         | Full Adder 1-bit                       |
| adder_subtractor_8b.v| Adder/Subtractor 8-bit (8xFA + XOR)   |
| reg_8b.v             | Registru 8-bit cu Load/Reset           |
| reg_1b.v             | Registru 1-bit (Q-1 FF)               |
| mux_2to1_8b.v        | Multiplexor 2:1 pe 8 biti              |
| counter_3b.v         | Counter 3-bit (8 iteratii)             |
| dsr_shift.v          | DSR Arithmetic Shift Right             |
| booth_mult.v         | Inmultire Booth Radix-2                |
| restoring_div.v      | Impartire Restoring Division           |
| control_unit.v       | Control Unit FSM                       |
| alu_8bit.v           | Top-Level ALU                          |
| tb_alu_8bit.v        | Testbench complet                      |

## OpCodes
| OpCode | Operatie        |
|--------|-----------------|
| 00     | Adunare (ADD)   |
| 01     | Scadere (SUB)   |
| 10     | Inmultire (MUL) - Booth Radix-2    |
| 11     | Impartire (DIV) - Restoring Division |

## Cum rulezi in VSCode cu Icarus Verilog

### 1. Instaleaza Icarus Verilog
- Windows: https://bleyer.org/icarus/
- Linux:   sudo apt install iverilog
- Mac:     brew install icarus-verilog

### 2. Instaleaza extensia in VSCode
- Cauta: "Verilog-HDL/SystemVerilog" (mshr-h)

### 3. Compileaza din terminal (in folderul proiectului)
```bash
iverilog -o alu_sim full_adder.v adder_subtractor_8b.v reg_8b.v reg_1b.v mux_2to1_8b.v counter_3b.v dsr_shift.v booth_mult.v restoring_div.v control_unit.v alu_8bit.v tb_alu_8bit.v
```

### 4. Ruleaza simularea
```bash
vvp alu_sim
```

### 5. Vezi waveforms (optional)
```bash
gtkwave tb_alu_8bit.vcd
```

## Algoritmi implementati
- **Inmultire**: Booth Radix-2
- **Impartire**: Restoring Division
