module regfile(
    input clk,
    input [4:0] rs1, rs2,
    input [4:0] wb_rd,
    input [31:0] wb_data,
    input wb_reg_write,
    output reg [31:0] read_data1, read_data2
);

    reg [31:0] registers [0:31];

    always @(posedge clk) begin
        read_data1 <= (rs1 == 0) ? 0 : registers[rs1];
        read_data2 <= (rs2 == 0) ? 0 : registers[rs2];

        if (wb_reg_write && wb_rd != 0) begin
            registers[wb_rd] <= wb_data;
        end
    end

endmodule
