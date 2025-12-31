module forwarding_unit(
    input  [4:0] EX_rs1, EX_rs2,
    input  [4:0] MEM_rd, WB_rd,
    input        MEM_RegWrite,
    input        WB_RegWrite,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs1))
            forwardA = 2'b01;
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs1))
            forwardA = 2'b10;

        if (MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs2))
            forwardB = 2'b01;
        else if (WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs2))
            forwardB = 2'b10;
    end

endmodule
