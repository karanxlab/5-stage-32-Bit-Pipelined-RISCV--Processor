module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] alu_sel
);

    // ALU operation encoding
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam AND  = 4'b0010;
    localparam OR   = 4'b0011;
    localparam XOR  = 4'b0100;
    localparam SLL  = 4'b0101;
    localparam SRL  = 4'b0110;
    localparam SRA  = 4'b0111;
    localparam SLT  = 4'b1000;
    localparam SLTU = 4'b1001;

    always @(*) begin
        // default
        alu_sel = ADD;

        case (alu_op)

            // Load / Store / AUIPC
            2'b00: alu_sel = ADD;

            // Branch instructions
            2'b01: alu_sel = SUB;

            // R-type instructions
            2'b10: begin
                case (funct3)
                    3'b000: alu_sel = (funct7[5]) ? SUB : ADD;
                    3'b111: alu_sel = AND;
                    3'b110: alu_sel = OR;
                    3'b100: alu_sel = XOR;
                    3'b001: alu_sel = SLL;
                    3'b101: alu_sel = (funct7[5]) ? SRA : SRL;
                    3'b010: alu_sel = SLT;
                    3'b011: alu_sel = SLTU;
                    default: alu_sel = ADD;
                endcase
            end

            // I-type ALU instructions
            2'b11: begin
                case (funct3)
                    3'b000: alu_sel = ADD;
                    3'b111: alu_sel = AND;
                    3'b110: alu_sel = OR;
                    3'b100: alu_sel = XOR;
                    3'b001: alu_sel = SLL;
                    3'b101: alu_sel = (funct7[5]) ? SRA : SRL;
                    3'b010: alu_sel = SLT;
                    3'b011: alu_sel = SLTU;
                    default: alu_sel = ADD;
                endcase
            end

            default: alu_sel = ADD;
        endcase
    end

endmodule
