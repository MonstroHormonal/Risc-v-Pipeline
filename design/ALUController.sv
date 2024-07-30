`timescale 1ns / 1ps

module ALUController (
    // Inputs
    input logic [1:0] ALUOp,   // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01: Branch; 10: Rtype/Itype; 11: JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    // Output
    output logic [3:0] Operation  // operation selection for ALU
);

always_comb begin
    // Default value for Operation to ensure it is always assigned
    Operation = 4'b0000;

    // LW/SW/AUIPC
    if (ALUOp == 2'b00) begin
        Operation = 4'b0010; // LW/SW/AUIPC mapped to ADD operation
    end

    // Branch
    else if (ALUOp == 2'b01) begin
        case (Funct3)
            3'b000: Operation = 4'b1000; // BEQ
            3'b001: Operation = 4'b1001; // BNE
            3'b101: Operation = 4'b1010; // BGE
            3'b100: Operation = 4'b1011; // BLT
            default: Operation = 4'b0000;
        endcase
    end

    // Rtype/Itype
    else if (ALUOp == 2'b10) begin
        case (Funct3)
            3'b000: Operation = (Funct7 == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB ou ADD/ADDI
            3'b001: Operation = (Funct7 == 7'b0000000) ? 4'b0111 : 4'b0000; // SLL/SLLI
            3'b010: Operation = 4'b1100; // SLT/BLT
            3'b100: Operation = 4'b0101; // XOR
            3'b101: Operation = (Funct7 == 7'b0000000) ? 4'b1111 : // SRL/SRLI
                                 (Funct7 == 7'b0100000) ? 4'b1110 : 4'b0000; // SRA/SRAI
            3'b110: Operation = 4'b0001; // OR
            3'b111: Operation = 4'b0000; // AND
            default: Operation = 4'b0000;
        endcase
    end

    // JAL/LUI
    else if (ALUOp == 2'b11) begin
        case (Funct3)
            3'b000: Operation = 4'b1011; // LUI
            3'b001: Operation = 4'b0011; // JAL/JALR
            default: Operation = 4'b0000;
        endcase
    end
end

endmodule
