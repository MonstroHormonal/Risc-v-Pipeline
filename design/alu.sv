`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
        // R-type or I-type
            4'b0000: // AND
                ALUResult = SrcA & SrcB;
            4'b0001: // OR
                ALUResult = SrcA | SrcB;
            4'b0101: // XOR
                ALUResult = SrcA ^ SrcB;
            4'b0110: // SUB
                ALUResult = SrcA - SrcB;
            4'b0010: // ADD/ADDI
                ALUResult = SrcA + SrcB;
            4'b0111: // SLL/SLLI
                ALUResult = SrcA << SrcB[4:0];
            4'b1100: // SLT and BLT
                if (SrcA[31] == 1 && SrcB[31] == 0)
                    ALUResult = 1;
                else if (SrcA[31] == 0 && SrcB[31] == 1)
                    ALUResult = 0;
                else
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b1110: // SRA/SRAI
                ALUResult = SrcA >>> SrcB[4:0];
            4'b1111: // SRL/SRLI
                ALUResult = SrcA >> SrcB[4:0];
                
        //Branch
            4'b1000: // BEQ
                ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001: // BNE
                ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1010: // BGE
                if (SrcA[31] == 1 && SrcB[31] == 0)
                    ALUResult = 0;
                else if (SrcA[31] == 0 && SrcB[31] == 1)
                    ALUResult = 1;
                else
                    ALUResult = (SrcA >= SrcB) ? 1 : 0;

        //LUI/JAL/JALR
            4'b1011: // LUI
                ALUResult = {SrcB, 12'b0};
            4'b0011: // Jal/jalr
                ALUResult = SrcA;
        
            default: 
                ALUResult = 0;
            endcase
        end
endmodule