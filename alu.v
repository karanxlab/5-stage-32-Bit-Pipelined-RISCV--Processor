module alu (
    input  wire [31:0] op_a,
    input  wire [31:0] op_b,
    input  wire [3:0]  alu_sel,
    output reg  [31:0] alu_out,
    output wire        zero,
    output wire        less,
    output wire        greater_equal
);

    wire signed [31:0] sA = op_a;
    wire signed [31:0] sB = op_b;
    wire [4:0] shift_amt = op_b[4:0];

    always @(*) begin
        case (alu_sel)
            4'b0000: alu_out = op_a + op_b;            // ADD
            4'b0001: alu_out = op_a - op_b;            // SUB
            4'b0010: alu_out = op_a & op_b;            // AND
            4'b0011: alu_out = op_a | op_b;            // OR
            4'b0100: alu_out = op_a ^ op_b;            // XOR
            4'b0101: alu_out = op_a << shift_amt;      // SLL
            4'b0110: alu_out = op_a >> shift_amt;      // SRL
            4'b0111: alu_out = sA >>> shift_amt;       // SRA
            4'b1000: alu_out = (sA < sB) ? 32'd1 : 32'd0; // SLT
            4'b1001: alu_out = (op_a < op_b) ? 32'd1 : 32'd0; // SLTU
            default: alu_out = 32'd0;
        endcase
    end

    assign zero          = (op_a == op_b);
    assign less          = (sA < sB);
    assign greater_equal = (sA >= sB);

endmodule
