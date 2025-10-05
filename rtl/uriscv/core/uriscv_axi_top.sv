module uriscv_axi_top (
    input   logic               clk,
    input   logic               rst_n,
    input   logic               intr_i,
    output  logic   [7:0]       awlen,
    output  logic   [2:0]       awsize,
    output  logic   [1:0]       awburst,
    output  logic   [31:0]      awaddr,
    output  logic               awvalid,
    input   logic               awready,
    output  logic   [31:0]      wdata,
    output  logic   [3:0]       wstrb,
    output  logic               wlast,
    output  logic               wvalid,
    input   logic               wready,
    input   logic   [1:0]       bresp,
    input   logic               bvalid,
    output  logic               bready,
    output  logic   [7:0]       arlen,
    output  logic   [2:0]       arsize,
    output  logic   [1:0]       arburst,
    output  logic   [31:0]      araddr,
    output  logic               arvalid,
    input   logic               arready,
    input   logic   [31:0]      rdata,
    input   logic               rlast,
    input   logic   [1:0]       rresp,
    input   logic               rvalid,
    output  logic               rready
);

logic               msel;
logic               grant;

logic               mem_i_rd_w;
logic   [31:0]      mem_i_pc_w;
logic   [31:0]      mem_i_inst_w;
logic               mem_i_accept_w;
logic               mem_i_valid_w;
logic               mem_d_rd_w;
logic   [ 3:0]      mem_d_wr_w;
logic   [31:0]      mem_d_addr_w;
logic   [31:0]      mem_d_data_wr_w;
logic   [31:0]      mem_d_data_rd_w;
logic               mem_d_accept_w;
logic               mem_d_ack_w;

uriscv_core #(
    .SUPPORT_BRAM_REGFILE (1),
    .RST_VECTOR           (32'h2000_0000)
) u_uriscv_core (
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    .intr_i                 (intr_i                 ),
    .mem_i_rd_o             (mem_i_rd_w             ),
    .mem_i_pc_o             (mem_i_pc_w             ),
    .mem_i_inst_i           (mem_i_inst_w           ),
    .mem_i_accept_i         (mem_i_accept_w         ),
    .mem_i_valid_i          (mem_i_valid_w          ),
    .mem_d_rd_o             (mem_d_rd_w             ),
    .mem_d_wr_o             (mem_d_wr_w             ),
    .mem_d_addr_o           (mem_d_addr_w           ),
    .mem_d_data_rd_i        (mem_d_data_rd_w        ),
    .mem_d_data_wr_o        (mem_d_data_wr_w        ),
    .mem_d_accept_i         (mem_d_accept_w         ),
    .mem_d_ack_i            (mem_d_ack_w            )
);

// Read Channel Arbiter
always_ff @(posedge clk, negedge rst_n)
begin
    if (rst_n == 1'b0)
        grant <= 1'b0;
    else if (mem_i_valid_w)
        grant <= 1'b1;
    else if (rvalid & rready & (msel == 1'b1))
        grant <= 1'b0;
end

// Read Channel
always_ff @(posedge clk, negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        msel    <= 1'b0;
        arsize  <= 3'h2;
        arburst <= 2'h1;
        araddr  <= 32'h0;
        arvalid <= 1'b0;
    end
    else begin
        if (arvalid & arready) begin
            arvalid <= 1'b0;
        end
        else if (mem_i_rd_w | mem_d_rd_w)
        begin
            arvalid <= 1'b1;
            if (mem_i_rd_w & mem_d_rd_w)
            begin
                msel   <= grant;
                araddr <= grant ? mem_d_addr_w : mem_i_pc_w;
            end
            else if (mem_i_rd_w)
            begin
                msel   <= 1'b0;
                araddr <= mem_i_pc_w;
            end
            else begin
                msel   <= 1'b1;
                araddr <= mem_d_addr_w;
            end
        end
    end
end

assign arlen = 8'h0;
assign rready = 1'b1;
assign mem_i_accept_w = arvalid & arready & (msel == 1'b0);
assign mem_i_inst_w = rdata;
assign mem_i_valid_w = rvalid & rready & rlast & (msel == 1'b0);

// Write Addr Channel
always_ff @(posedge clk, negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        awsize  <= 3'h0;
        awburst <= 2'h1;
        awaddr  <= 32'h0;
        awvalid <= 1'b0;
    end
    else begin
        if (awvalid & awready) begin
            awvalid <= 1'b0;
            awsize  <= 3'h0;
            awaddr  <= 32'h0;
        end
        else if (|mem_d_wr_w)
        begin
            awvalid <= 1'b1;
            awsize  <= (mem_d_wr_w == 4'hF) ? 3'h2 : ((mem_d_wr_w == 4'h3 || mem_d_wr_w == 4'hC) ? 3'h1 : 3'h0);
            awaddr  <= mem_d_addr_w;
        end
    end
end

assign awlen = 8'h0;
assign mem_d_accept_w = (|mem_d_wr_w & awvalid & awready) | (mem_d_rd_w & arvalid & arready & (msel == 1'b1));

// Write Data Channel
always_ff @(posedge clk, negedge rst_n)
begin
    if (rst_n == 1'b0)
    begin
        wdata  <= 32'h0;
        wstrb  <= 4'h0;
        wlast  <= 1'b0;
        wvalid <= 1'b0;
        bready <= 1'b1;
    end
    else begin
        if (wvalid & wready)
        begin
            wlast  <= 1'b0;
            wvalid <= 1'b0;
        end
        else if (|mem_d_wr_w)
        begin
            wstrb  <= mem_d_wr_w;
            wdata  <= mem_d_data_wr_w;
            wlast  <= 1'b1;
            wvalid <= 1'b1;
        end
    end
end

assign mem_d_ack_w = (bvalid & bready) | (rvalid & rready & (msel == 1'b1));
assign mem_d_data_rd_w = rdata;

endmodule

