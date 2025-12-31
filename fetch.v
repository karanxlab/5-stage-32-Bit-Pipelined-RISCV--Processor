module fetch (
    input clk, reset,
    input [31:0] pc_next,
    input stall, flush,
    output reg [31:0] pc,
    output reg [31:0] instr,
    output [31:0] pc_out,
    input [31:0] mem_data
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else if (flush)
            pc <= 0;
        else if (!stall)
            pc <= pc_next;
    end

    always @(posedge clk) begin
        if (!stall && !flush)
            instr <= mem_data;
    end

    assign pc_out = pc;

endmodule
