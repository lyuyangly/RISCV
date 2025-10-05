module ram (
    input           clk_i,
    input   [3:0]   wr_i,
    input           rd_i,
    input   [11:0]  addr_i,
    input   [31:0]  data_i,
    output  [31:0]  data_o,
    output          accept_o
);

/* verilator lint_off MULTIDRIVEN */
reg [31:0]   ram [4095:0];
initial $readmemh("../frw/app_test/app_test.txt", ram);
/* verilator lint_on MULTIDRIVEN */

reg     [31:0]  ram_read_q;

always @ (posedge clk_i)
begin
    if (wr_i[0])
        ram[addr_i][7:0] <= data_i[7:0];
    if (wr_i[1])
        ram[addr_i][15:8] <= data_i[15:8];
    if (wr_i[2])
        ram[addr_i][23:16] <= data_i[23:16];
    if (wr_i[3])
        ram[addr_i][31:24] <= data_i[31:24];
    ram_read_q <= ram[addr_i];
end

assign data_o = ram_read_q;

assign accept_o = 1'b1;

endmodule
