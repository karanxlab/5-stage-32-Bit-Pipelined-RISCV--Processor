module hazard_unit(
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    input [4:0] id_ex_rd,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input id_ex_mem_read,
    input ex_mem_branch,
    output reg stall,
    output reg flush
);

    always @(*) begin

        stall = 0;
        flush = 0;


        if (id_ex_mem_read && ((id_ex_rs1 == id_ex_rd && id_ex_rd != 0) || 
                               (id_ex_rs2 == id_ex_rd && id_ex_rd != 0))) begin
            stall = 1;
        end

        if (ex_mem_branch) begin
            flush = 1;
        end
    end

endmodule
