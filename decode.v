module decode (
    input clk, reset,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input [31:0] wb_data,
    input [4:0] wb_rd,
    input wb_reg_write,
    input stall, flush,
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data, rs2_data,
    output reg [31:0] imm,
    output reg [4:0] rs1, rs2, rd,
    output reg [3:0] alu_op,
    output reg reg_write, mem_read, mem_write, alu_src, branch, jump,
    output reg [11:0] csr_addr,
    output reg csr_write
);

    reg [31:0] reg_file [0:31];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                reg_file[i] <= 0;
        end else if (wb_reg_write && wb_rd != 0) begin
            reg_file[wb_rd] <= wb_data;
        end
    end

    always @(*) begin
        rs1 = 0;
        rs2 = 0;
        rd  = 0;
        rs1_data = (instr_in[19:15] == 0) ? 0 : reg_file[instr_in[19:15]];
        rs2_data = (instr_in[24:20] == 0) ? 0 : reg_file[instr_in[24:20]];
        imm = 0;
        alu_op = 0;
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        alu_src = 0;
        branch = 0;
        jump = 0;
        csr_addr = 0;
        csr_write = 0;

        rs1 = instr_in[19:15];
        rs2 = instr_in[24:20];
        rd  = instr_in[11:7];

        case (instr_in[6:0])
            7'b0010011: begin
                imm = {{20{instr_in[31]}}, instr_in[31:20]};
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0000;
            end

            7'b0110011: begin
                reg_write = 1;
                if (instr_in[30] == 0 && instr_in[14:12] == 3'b000)
                    alu_op = 4'b0000;
                else if (instr_in[30] && instr_in[14:12] == 3'b000)
                    alu_op = 4'b0001;
            end

            7'b0000011: begin
                imm = {{20{instr_in[31]}}, instr_in[31:20]};
                alu_src = 1;
                mem_read = 1;
                reg_write = 1;
                alu_op = 4'b0000;
            end

            7'b0100011: begin
                imm = {{20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]};
                alu_src = 1;
                mem_write = 1;
                alu_op = 4'b0000;
            end

            7'b1100011: begin
                imm = {{19{instr_in[31]}}, instr_in[31], instr_in[7],
                       instr_in[30:25], instr_in[11:8], 1'b0};
                branch = 1;
                alu_op = 4'b0001;
            end

            7'b1101111: begin
                imm = {{12{instr_in[31]}}, instr_in[31],
                       instr_in[19:12], instr_in[20],
                       instr_in[30:21], 1'b0};
                jump = 1;
                reg_write = 1;
                alu_op = 4'b0000;
            end

            7'b1110011: begin
                csr_addr = instr_in[31:20];
                csr_write = 1;
                reg_write = 1;
            end
        endcase
    end

    always @(posedge clk) begin
        if (!stall && !flush)
            pc_out <= pc_in;
        else if (flush)
            pc_out <= 0;
    end

endmodule
