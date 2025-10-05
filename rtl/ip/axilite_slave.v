module axilite_slave (
    input s_axi_aclk,
    input s_axi_aresetn,
    input [3:0]s_axi_awaddr,
    input s_axi_awvalid,
    output s_axi_awready,
    input [31:0]s_axi_wdata,
    input [3:0]s_axi_wstrb,
    input s_axi_wvalid,
    output s_axi_wready,
    output [1:0]s_axi_bresp,
    output s_axi_bvalid,
    input s_axi_bready,
    input [3:0]s_axi_araddr,
    input s_axi_arvalid,
    output s_axi_arready,
    output [31:0]s_axi_rdata,
    output [1:0]s_axi_rresp,
    output s_axi_rvalid,
    input s_axi_rready
);

assign s_axi_awready = 1'b1;
assign s_axi_wready = 1'b1;
assign s_axi_arready = 1'b1;
assign s_axi_rvalid = 1'b0;
assign s_axi_bvalid = 1'b0;

endmodule
