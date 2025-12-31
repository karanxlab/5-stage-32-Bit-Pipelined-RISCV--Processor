module branch_control (
    input  wire [31:0] pc_curr,
    input  wire [31:0] imm_val,
    input  wire [31:0] rs1_val,
    input  wire        is_branch,
    input  wire        is_jump,
    input  wire [2:0]  funct3,
    input  wire        zero,
    input  wire        less,
    input  wire        greater_equal,
    output reg         take_branch,
    output reg  [31:0] next_pc,
    output reg         flush_pipe
);

    always @(*) begin
        take_branch = 1'b0;
        flush_pipe  = 1'b0;
        next_pc     = pc_curr + 32'd4;

        if (is_branch) begin
            case (funct3)
                3'b000: if (zero)           take_branch = 1'b1;
                3'b001: if (!zero)          take_branch = 1'b1;
                3'b100: if (less)           take_branch = 1'b1;
                3'b101: if (greater_equal)  take_branch = 1'b1;
                default: take_branch = 1'b0;
            endcase

            if (take_branch)
                next_pc = pc_curr + imm_val;
        end

        if (is_jump) begin
            take_branch = 1'b1;
            if (funct3 == 3'b000)
                next_pc = pc_curr + imm_val;
            else
                next_pc = (rs1_val + imm_val) & 32'hFFFFFFFE;
        end

        if (take_branch)
            flush_pipe = 1'b1;
    end

endmodule
