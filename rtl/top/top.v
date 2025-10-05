module top (
    input           clk,
    input           rst_n,
    input           intr_i,
    output  [31:0]  pio
);

`ifdef URISCV_AHB_TEST
wire            hsel_ram;
wire            hsel_pio;
wire    [1:0]   htrans;
wire    [2:0]   hsize;
wire    [2:0]   hburst;
wire            hwrite;
wire    [31:0]  haddr;
wire    [31:0]  hwdata;
wire    [31:0]  hrdata;
wire            hready;
wire            hready_ram;
wire            hready_pio;
wire    [1:0]   hresp;

uriscv_ahb_top u_riscv (
    .hclk           (clk            ),
    .hreset_n       (rst_n          ),
    .intr_i         (intr_i         ),
    .htrans         (htrans         ),
    .hsize          (hsize          ),
    .hburst         (hburst         ),
    .hwrite         (hwrite         ),
    .haddr          (haddr          ),
    .hwdata         (hwdata         ),
    .hrdata         (hrdata         ),
    .hready_in      (hready         ),
    .hresp          (hresp          )
);

ahb_ram u_ram (
    .hclk           (clk            ),
    .hreset_n       (rst_n          ),
    .hsel           (hsel_ram       ),
    .htrans         (htrans         ),
    .hsize          (hsize          ),
    .hwrite         (hwrite         ),
    .haddr          (haddr[13:0]    ),
    .hwdata         (hwdata         ),
    .hrdata         (hrdata         ),
    .hready_in      (hready         ),
    .hready_out     (hready_ram     ),
    .hresp          ()
);

ahb_pio u_pio (
    .hclk           (clk            ),
    .hreset_n       (rst_n          ),
    .hsel           (hsel_pio       ),
    .htrans         (htrans         ),
    .hsize          (hsize          ),
    .hwrite         (hwrite         ),
    .haddr          (haddr          ),
    .hwdata         (hwdata         ),
    .hrdata         (),
    .hready_in      (hready         ),
    .hready_out     (hready_pio     ),
    .hresp          (),
    .pio            (pio            )
);

assign hready   = hready_ram | hready_pio;
assign hresp    = 2'h0;
assign hsel_ram = (haddr[31:28] == 4'h8);
assign hsel_pio = (haddr[31:28] == 4'hF);

`else
wire    [7:0]       cpu_arlen;
wire    [2:0]       cpu_arsize;
wire    [1:0]       cpu_arburst;
wire    [31:0]      cpu_araddr;
wire                cpu_arready;
wire                cpu_arvalid;
wire    [7:0]       cpu_awlen;
wire    [2:0]       cpu_awsize;
wire    [1:0]       cpu_awburst;
wire    [31:0]      cpu_awaddr;
wire                cpu_awready;
wire                cpu_awvalid;
wire                cpu_rlast;
wire                cpu_rready;
wire                cpu_rvalid;
wire    [31:0]      cpu_rdata;
wire    [1:0]       cpu_rresp;
wire                cpu_wready;
wire                cpu_wvalid;
wire    [3:0]       cpu_wstrb;
wire    [31:0]      cpu_wdata;
wire                cpu_wlast;
wire                cpu_bvalid;
wire                cpu_bready;
wire    [1:0]       cpu_bresp;

wire    [3:0]       ddr_arid;
wire    [7:0]       ddr_arlen;
wire    [2:0]       ddr_arsize;
wire    [1:0]       ddr_arburst;
wire    [31:0]      ddr_araddr;
wire                ddr_arready;
wire                ddr_arvalid;
wire    [3:0]       ddr_awid;
wire    [7:0]       ddr_awlen;
wire    [2:0]       ddr_awsize;
wire    [1:0]       ddr_awburst;
wire    [31:0]      ddr_awaddr;
wire                ddr_awready;
wire                ddr_awvalid;
wire    [3:0]       ddr_rid;
wire                ddr_rlast;
wire                ddr_rready;
wire                ddr_rvalid;
wire    [31:0]      ddr_rdata;
wire    [1:0]       ddr_rresp;
wire                ddr_wready;
wire                ddr_wvalid;
wire    [3:0]       ddr_wstrb;
wire    [31:0]      ddr_wdata;
wire                ddr_wlast;
wire    [3:0]       ddr_bid;
wire                ddr_bvalid;
wire                ddr_bready;
wire    [1:0]       ddr_bresp;

wire    [3:0]       ram_arid;
wire    [7:0]       ram_arlen;
wire    [2:0]       ram_arsize;
wire    [1:0]       ram_arburst;
wire    [31:0]      ram_araddr;
wire                ram_arready;
wire                ram_arvalid;
wire    [3:0]       ram_awid;
wire    [7:0]       ram_awlen;
wire    [2:0]       ram_awsize;
wire    [1:0]       ram_awburst;
wire    [31:0]      ram_awaddr;
wire                ram_awready;
wire                ram_awvalid;
wire    [3:0]       ram_rid;
wire                ram_rlast;
wire                ram_rready;
wire                ram_rvalid;
wire    [31:0]      ram_rdata;
wire    [1:0]       ram_rresp;
wire                ram_wready;
wire                ram_wvalid;
wire    [3:0]       ram_wstrb;
wire    [31:0]      ram_wdata;
wire                ram_wlast;
wire    [3:0]       ram_bid;
wire                ram_bvalid;
wire                ram_bready;
wire    [1:0]       ram_bresp;

wire    [3:0]       uart_awid;
wire    [7:0]       uart_awlen;
wire    [2:0]       uart_awsize;
wire    [1:0]       uart_awburst;
wire    [31:0]      uart_awaddr;
wire                uart_awvalid;
wire                uart_awready;
wire    [3:0]       uart_wstrb;
wire    [31:0]      uart_wdata;
wire                uart_wlast;
wire                uart_wvalid;
wire                uart_wready;
wire    [1:0]       uart_bresp;
wire                uart_bvalid;
wire                uart_bready;
wire    [3:0]       uart_arid;
wire    [7:0]       uart_arlen;
wire    [2:0]       uart_arsize;
wire    [1:0]       uart_arburst;
wire    [31:0]      uart_araddr;
wire                uart_arvalid;
wire                uart_arready;
wire    [31:0]      uart_rdata;
wire    [1:0]       uart_rresp;
wire                uart_rvalid;
wire                uart_rready;

wire    [3:0]       gpio_awid;
wire    [7:0]       gpio_awlen;
wire    [2:0]       gpio_awsize;
wire    [1:0]       gpio_awburst;
wire    [31:0]      gpio_awaddr;
wire                gpio_awvalid;
wire                gpio_awready;
wire    [3:0]       gpio_wstrb;
wire    [31:0]      gpio_wdata;
wire                gpio_wlast;
wire                gpio_wvalid;
wire                gpio_wready;
wire    [1:0]       gpio_bresp;
wire                gpio_bvalid;
wire                gpio_bready;
wire    [3:0]       gpio_arid;
wire    [7:0]       gpio_arlen;
wire    [2:0]       gpio_arsize;
wire    [1:0]       gpio_arburst;
wire    [31:0]      gpio_araddr;
wire                gpio_arvalid;
wire                gpio_arready;
wire    [31:0]      gpio_rdata;
wire    [1:0]       gpio_rresp;
wire                gpio_rvalid;
wire                gpio_rready;

uriscv_axi_top u_riscv (
    .clk                    (clk                ),
    .rst_n                  (rst_n              ),
    .intr_i                 (1'b0               ),
    .awlen                  (cpu_awlen          ),
    .awsize                 (cpu_awsize         ),
    .awburst                (cpu_awburst        ),
    .awaddr                 (cpu_awaddr         ),
    .awvalid                (cpu_awvalid        ),
    .awready                (cpu_awready        ),
    .wdata                  (cpu_wdata          ),
    .wstrb                  (cpu_wstrb          ),
    .wlast                  (cpu_wlast          ),
    .wvalid                 (cpu_wvalid         ),
    .wready                 (cpu_wready         ),
    .bresp                  (cpu_bresp          ),
    .bvalid                 (cpu_bvalid         ),
    .bready                 (cpu_bready         ),
    .arlen                  (cpu_arlen          ),
    .arsize                 (cpu_arsize         ),
    .arburst                (cpu_arburst        ),
    .araddr                 (cpu_araddr         ),
    .arvalid                (cpu_arvalid        ),
    .arready                (cpu_arready        ),
    .rdata                  (cpu_rdata          ),
    .rlast                  (cpu_rlast          ),
    .rresp                  (cpu_rresp          ),
    .rvalid                 (cpu_rvalid         ),
    .rready                 (cpu_rready         )
);

axi_crossbar #(
    .S_COUNT                (1                                  ),
    .M_COUNT                (4                                  ),
    .S_ID_WIDTH             (4                                  ),
    .M_ID_WIDTH             (4                                  ),
    .M_REGIONS              (1                                  ),
    .M_BASE_ADDR            (0                                  ),
    .M_ADDR_WIDTH           ({32'd24, 32'd24, 32'd24, 32'd29}   )
) u_axi_crossbar (
    .clk                    (clk                    ),
    .rst                    (~rst_n                 ),
    .s_axi_awid             (4'h0                   ),
    .s_axi_awaddr           (cpu_awaddr             ),
    .s_axi_awlen            (cpu_awlen              ),
    .s_axi_awsize           (cpu_awsize             ),
    .s_axi_awburst          (cpu_awburst            ),
    .s_axi_awlock           (1'b0                   ),
    .s_axi_awcache          (4'h0                   ),
    .s_axi_awprot           (3'h0                   ),
    .s_axi_awqos            (4'h0                   ),
    .s_axi_awuser           (1'h0                   ),
    .s_axi_awvalid          (cpu_awvalid            ),
    .s_axi_awready          (cpu_awready            ),
    .s_axi_wdata            (cpu_wdata              ),
    .s_axi_wstrb            (cpu_wstrb              ),
    .s_axi_wlast            (cpu_wlast              ),
    .s_axi_wuser            (1'h0                   ),
    .s_axi_wvalid           (cpu_wvalid             ),
    .s_axi_wready           (cpu_wready             ),
    .s_axi_bid              (),
    .s_axi_bresp            (cpu_bresp              ),
    .s_axi_buser            (),
    .s_axi_bvalid           (cpu_bvalid             ),
    .s_axi_bready           (cpu_bready             ),
    .s_axi_arid             (4'h0                   ),
    .s_axi_araddr           (cpu_araddr             ),
    .s_axi_arlen            (cpu_arlen              ),
    .s_axi_arsize           (cpu_arsize             ),
    .s_axi_arburst          (cpu_arburst            ),
    .s_axi_arlock           (1'b0                   ),
    .s_axi_arcache          (4'h0                   ),
    .s_axi_arprot           (3'h0                   ),
    .s_axi_arqos            (4'h0                   ),
    .s_axi_aruser           (1'h0                   ),
    .s_axi_arvalid          (cpu_arvalid            ),
    .s_axi_arready          (cpu_arready            ),
    .s_axi_rid              (),
    .s_axi_rdata            (cpu_rdata              ),
    .s_axi_rresp            (cpu_rresp              ),
    .s_axi_rlast            (cpu_rlast              ),
    .s_axi_ruser            (),
    .s_axi_rvalid           (cpu_rvalid             ),
    .s_axi_rready           (cpu_rready             ),
    .m_axi_awid             ({gpio_awid, uart_awid, ram_awid, ddr_awid}),
    .m_axi_awaddr           ({gpio_awaddr, uart_awaddr, ram_awaddr, ddr_awaddr}),
    .m_axi_awlen            ({gpio_awlen, uart_awlen, ram_awlen, ddr_awlen}),
    .m_axi_awsize           ({gpio_awsize, uart_awsize, ram_awsize, ddr_awsize}),
    .m_axi_awburst          ({gpio_awburst, uart_awburst, ram_awburst, ddr_awburst}),
    .m_axi_awlock           (),
    .m_axi_awcache          (),
    .m_axi_awprot           (),
    .m_axi_awqos            (),
    .m_axi_awregion         (),
    .m_axi_awuser           (),
    .m_axi_awvalid          ({gpio_awvalid, uart_awvalid, ram_awvalid, ddr_awvalid}),
    .m_axi_awready          ({gpio_awready, uart_awready, ram_awready, ddr_awready}),
    .m_axi_wdata            ({gpio_wdata, uart_wdata, ram_wdata, ddr_wdata}),
    .m_axi_wstrb            ({gpio_wstrb, uart_wstrb, ram_wstrb, ddr_wstrb}),
    .m_axi_wlast            ({gpio_wlast, uart_wlast, ram_wlast, ddr_wlast}),
    .m_axi_wuser            (),
    .m_axi_wvalid           ({gpio_wvalid, uart_wvalid, ram_wvalid, ddr_wvalid}),
    .m_axi_wready           ({gpio_wready, uart_wready, ram_wready, ddr_wready}),
    .m_axi_bid              ({4'd0, 4'd0, ram_bid, ddr_bid}),
    .m_axi_bresp            ({gpio_bresp, uart_bresp, ram_bresp, ddr_bresp}),
    .m_axi_buser            ({1'h0, 1'h0, 1'h0, 1'h0}),
    .m_axi_bvalid           ({gpio_bvalid, uart_bvalid, ram_bvalid, ddr_bvalid}),
    .m_axi_bready           ({gpio_bready, uart_bready, ram_bready, ddr_bready}),
    .m_axi_arid             ({gpio_arid, uart_arid, ram_arid, ddr_arid}),
    .m_axi_araddr           ({gpio_araddr, uart_araddr, ram_araddr, ddr_araddr}),
    .m_axi_arlen            ({gpio_arlen, uart_arlen, ram_arlen, ddr_arlen}),
    .m_axi_arsize           ({gpio_arsize, uart_arsize, ram_arsize, ddr_arsize}),
    .m_axi_arburst          ({gpio_arburst, uart_arburst, ram_arburst, ddr_arburst}),
    .m_axi_arlock           (),
    .m_axi_arcache          (),
    .m_axi_arprot           (),
    .m_axi_arqos            (),
    .m_axi_arregion         (),
    .m_axi_aruser           (),
    .m_axi_arvalid          ({gpio_arvalid, uart_arvalid, ram_arvalid, ddr_arvalid}),
    .m_axi_arready          ({gpio_arready, uart_arready, ram_arready, ddr_arready}),
    .m_axi_rid              ({4'h0, 4'h0, ram_rid, ddr_rid}),
    .m_axi_rdata            ({gpio_rdata, uart_rdata, ram_rdata, ddr_rdata}),
    .m_axi_rlast            ({1'b1, 1'b1, ram_rlast, ddr_rlast}),
    .m_axi_ruser            ({1'b0, 1'b0, 1'b0, 1'b0}),
    .m_axi_rresp            ({gpio_rresp, uart_rresp, ram_rresp, ddr_rresp}),
    .m_axi_rvalid           ({gpio_rvalid, uart_rvalid, ram_rvalid, ddr_rvalid}),
    .m_axi_rready           ({gpio_rready, uart_rready, ram_rready, ddr_rready})
);

/*
axi_bus_m2s4 u_axi_bus_m2s4 (
    .ACLK                   (clk                ),
    .ARESETn                (rst_n              ),
    .M0_MID                 (4'h0               ),
    .M0_AWID                (4'h0               ),
    .M0_AWADDR              (cpu_awaddr         ),
    .M0_AWLEN               (cpu_awlen          ),
    .M0_AWLOCK              (2'h0               ),
    .M0_AWSIZE              (cpu_awsize         ),
    .M0_AWBURST             (cpu_awburst        ),
    .M0_AWVALID             (cpu_awvalid        ),
    .M0_AWREADY             (cpu_awready        ),
    .M0_WID                 (4'h0               ),
    .M0_WDATA               (cpu_wdata          ),
    .M0_WSTRB               (cpu_wstrb          ),
    .M0_WLAST               (cpu_wlast          ),
    .M0_WVALID              (cpu_wvalid         ),
    .M0_WREADY              (cpu_wready         ),
    .M0_BID                 (),
    .M0_BRESP               (cpu_bresp          ),
    .M0_BVALID              (cpu_bvalid         ),
    .M0_BREADY              (cpu_bready         ),
    .M0_ARID                (4'h0               ),
    .M0_ARADDR              (cpu_araddr         ),
    .M0_ARLEN               (cpu_arlen          ),
    .M0_ARLOCK              (2'h0               ),
    .M0_ARSIZE              (cpu_arsize         ),
    .M0_ARBURST             (cpu_arburst        ),
    .M0_ARVALID             (cpu_arvalid        ),
    .M0_ARREADY             (cpu_arready        ),
    .M0_RID                 (),
    .M0_RDATA               (cpu_rdata          ),
    .M0_RRESP               (cpu_rresp          ),
    .M0_RLAST               (cpu_rlast          ),
    .M0_RVALID              (cpu_rvalid         ),
    .M0_RREADY              (cpu_rready         ),
    .M1_MID                 (4'h1               ),
    .M1_AWID                (4'h0               ),
    .M1_AWADDR              (32'h0              ),
    .M1_AWLEN               (4'h0               ),
    .M1_AWLOCK              (2'h0               ),
    .M1_AWSIZE              (3'h2               ),
    .M1_AWBURST             (2'h0               ),
    .M1_AWVALID             (1'b0               ),
    .M1_AWREADY             (),
    .M1_WID                 (4'h0               ),
    .M1_WDATA               (32'h0              ),
    .M1_WSTRB               (4'h0               ),
    .M1_WLAST               (1'b0               ),
    .M1_WVALID              (1'b0               ),
    .M1_WREADY              (),
    .M1_BID                 (),
    .M1_BRESP               (),
    .M1_BVALID              (),
    .M1_BREADY              (1'b1               ),
    .M1_ARID                (4'h0               ),
    .M1_ARADDR              (32'h0              ),
    .M1_ARLEN               (4'h0               ),
    .M1_ARLOCK              (2'b0               ),
    .M1_ARSIZE              (3'h2               ),
    .M1_ARBURST             (2'h0               ),
    .M1_ARVALID             (1'b0               ),
    .M1_ARREADY             (),
    .M1_RID                 (),
    .M1_RDATA               (),
    .M1_RRESP               (),
    .M1_RLAST               (),
    .M1_RVALID              (),
    .M1_RREADY              (1'b1               ),
    .S0_AWID                (ddr_awid           ),
    .S0_AWADDR              (ddr_awaddr         ),
    .S0_AWLEN               (ddr_awlen          ),
    .S0_AWLOCK              (),
    .S0_AWSIZE              (ddr_awsize         ),
    .S0_AWBURST             (ddr_awburst        ),
    .S0_AWVALID             (ddr_awvalid        ),
    .S0_AWREADY             (ddr_awready        ),
    .S0_WID                 (),
    .S0_WDATA               (ddr_wdata          ),
    .S0_WSTRB               (ddr_wstrb          ),
    .S0_WLAST               (ddr_wlast          ),
    .S0_WVALID              (ddr_wvalid         ),
    .S0_WREADY              (ddr_wready         ),
    .S0_BID                 ({4'h0, ddr_bid}    ),
    .S0_BRESP               (ddr_bresp          ),
    .S0_BVALID              (ddr_bvalid         ),
    .S0_BREADY              (ddr_bready         ),
    .S0_ARID                (ddr_arid           ),
    .S0_ARADDR              (ddr_araddr         ),
    .S0_ARLEN               (ddr_arlen          ),
    .S0_ARLOCK              (),
    .S0_ARSIZE              (ddr_arsize         ),
    .S0_ARBURST             (ddr_arburst        ),
    .S0_ARVALID             (ddr_arvalid        ),
    .S0_ARREADY             (ddr_arready        ),
    .S0_RID                 ({4'h0, ddr_rid}    ),
    .S0_RDATA               (ddr_rdata          ),
    .S0_RRESP               (ddr_rresp          ),
    .S0_RLAST               (ddr_rlast          ),
    .S0_RVALID              (ddr_rvalid         ),
    .S0_RREADY              (ddr_rready         ),
    .S1_AWID                (ram_awid           ),
    .S1_AWADDR              (ram_awaddr         ),
    .S1_AWLEN               (ram_awlen          ),
    .S1_AWLOCK              (),
    .S1_AWSIZE              (ram_awsize         ),
    .S1_AWBURST             (ram_awburst        ),
    .S1_AWVALID             (ram_awvalid        ),
    .S1_AWREADY             (ram_awready        ),
    .S1_WID                 (),
    .S1_WDATA               (ram_wdata          ),
    .S1_WSTRB               (ram_wstrb          ),
    .S1_WLAST               (ram_wlast          ),
    .S1_WVALID              (ram_wvalid         ),
    .S1_WREADY              (ram_wready         ),
    .S1_BID                 ({4'h0, ram_bid}    ),
    .S1_BRESP               (ram_bresp          ),
    .S1_BVALID              (ram_bvalid         ),
    .S1_BREADY              (ram_bready         ),
    .S1_ARID                (ram_arid           ),
    .S1_ARADDR              (ram_araddr         ),
    .S1_ARLEN               (ram_arlen          ),
    .S1_ARLOCK              (),
    .S1_ARSIZE              (ram_arsize         ),
    .S1_ARBURST             (ram_arburst        ),
    .S1_ARVALID             (ram_arvalid        ),
    .S1_ARREADY             (ram_arready        ),
    .S1_RID                 ({4'h0, ram_rid}    ),
    .S1_RDATA               (ram_rdata          ),
    .S1_RRESP               (ram_rresp          ),
    .S1_RLAST               (ram_rlast          ),
    .S1_RVALID              (ram_rvalid         ),
    .S1_RREADY              (ram_rready         ),
    .S2_AWID                (),
    .S2_AWADDR              (uart_awaddr        ),
    .S2_AWLEN               (),
    .S2_AWLOCK              (),
    .S2_AWSIZE              (),
    .S2_AWBURST             (),
    .S2_AWVALID             (uart_awvalid       ),
    .S2_AWREADY             (uart_awready       ),
    .S2_WID                 (),
    .S2_WDATA               (uart_wdata         ),
    .S2_WSTRB               (uart_wstrb         ),
    .S2_WLAST               (),
    .S2_WVALID              (uart_wvalid        ),
    .S2_WREADY              (uart_wready        ),
    .S2_BID                 (8'h0               ),
    .S2_BRESP               (uart_bresp         ),
    .S2_BVALID              (uart_bvalid        ),
    .S2_BREADY              (uart_bready        ),
    .S2_ARID                (),
    .S2_ARADDR              (uart_araddr        ),
    .S2_ARLEN               (),
    .S2_ARLOCK              (),
    .S2_ARSIZE              (),
    .S2_ARBURST             (),
    .S2_ARVALID             (uart_arvalid       ),
    .S2_ARREADY             (uart_arready       ),
    .S2_RID                 (8'h0               ),
    .S2_RDATA               (uart_rdata         ),
    .S2_RRESP               (uart_rresp         ),
    .S2_RLAST               (1'b1               ),
    .S2_RVALID              (uart_rvalid        ),
    .S2_RREADY              (uart_rready        ),
    .S3_AWID                (),
    .S3_AWADDR              (gpio_awaddr        ),
    .S3_AWLEN               (),
    .S3_AWLOCK              (),
    .S3_AWSIZE              (),
    .S3_AWBURST             (),
    .S3_AWVALID             (gpio_awvalid       ),
    .S3_AWREADY             (gpio_awready       ),
    .S3_WID                 (),
    .S3_WDATA               (gpio_wdata         ),
    .S3_WSTRB               (gpio_wstrb         ),
    .S3_WLAST               (),
    .S3_WVALID              (gpio_wvalid        ),
    .S3_WREADY              (gpio_wready        ),
    .S3_BID                 (8'h0               ),
    .S3_BRESP               (gpio_bresp         ),
    .S3_BVALID              (gpio_bvalid        ),
    .S3_BREADY              (gpio_bready        ),
    .S3_ARID                (),
    .S3_ARADDR              (gpio_araddr        ),
    .S3_ARLEN               (),
    .S3_ARLOCK              (),
    .S3_ARSIZE              (),
    .S3_ARBURST             (),
    .S3_ARVALID             (gpio_arvalid       ),
    .S3_ARREADY             (gpio_arready       ),
    .S3_RID                 (8'h0               ),
    .S3_RDATA               (gpio_rdata         ),
    .S3_RRESP               (gpio_rresp         ),
    .S3_RLAST               (1'b1               ),
    .S3_RVALID              (gpio_rvalid        ),
    .S3_RREADY              (gpio_rready        )
); */

axi_ram u_ddr (
    .clk                    (clk                ),
    .rst_n                  (rst_n              ),
    .s_axi_awid             (ddr_awid           ),
    .s_axi_awlen            (ddr_awlen          ),
    .s_axi_awsize           (ddr_awsize         ),
    .s_axi_awburst          (ddr_awburst        ),
    .s_axi_awaddr           (ddr_awaddr[12:0]   ),
    .s_axi_awvalid          (ddr_awvalid        ),
    .s_axi_awready          (ddr_awready        ),
    .s_axi_wdata            (ddr_wdata          ),
    .s_axi_wstrb            (ddr_wstrb          ),
    .s_axi_wlast            (ddr_wlast          ),
    .s_axi_wvalid           (ddr_wvalid         ),
    .s_axi_wready           (ddr_wready         ),
    .s_axi_bid              (ddr_bid            ),
    .s_axi_bresp            (ddr_bresp          ),
    .s_axi_bvalid           (ddr_bvalid         ),
    .s_axi_bready           (ddr_bready         ),
    .s_axi_arid             (ddr_arid           ),
    .s_axi_arlen            (ddr_arlen          ),
    .s_axi_arsize           (ddr_arsize         ),
    .s_axi_arburst          (ddr_arburst        ),
    .s_axi_araddr           (ddr_araddr[12:0]   ),
    .s_axi_arvalid          (ddr_arvalid        ),
    .s_axi_arready          (ddr_arready        ),
    .s_axi_rid              (ddr_rid            ),
    .s_axi_rdata            (ddr_rdata          ),
    .s_axi_rresp            (ddr_rresp          ),
    .s_axi_rlast            (ddr_rlast          ),
    .s_axi_rvalid           (ddr_rvalid         ),
    .s_axi_rready           (ddr_rready         )
);

axi_ram u_ram (
    .clk                    (clk                ),
    .rst_n                  (rst_n              ),
    .s_axi_awid             (ram_awid           ),
    .s_axi_awlen            (ram_awlen          ),
    .s_axi_awsize           (ram_awsize         ),
    .s_axi_awburst          (ram_awburst        ),
    .s_axi_awaddr           (ram_awaddr[12:0]   ),
    .s_axi_awvalid          (ram_awvalid        ),
    .s_axi_awready          (ram_awready        ),
    .s_axi_wdata            (ram_wdata          ),
    .s_axi_wstrb            (ram_wstrb          ),
    .s_axi_wlast            (ram_wlast          ),
    .s_axi_wvalid           (ram_wvalid         ),
    .s_axi_wready           (ram_wready         ),
    .s_axi_bid              (ram_bid            ),
    .s_axi_bresp            (ram_bresp          ),
    .s_axi_bvalid           (ram_bvalid         ),
    .s_axi_bready           (ram_bready         ),
    .s_axi_arid             (ram_arid           ),
    .s_axi_arlen            (ram_arlen          ),
    .s_axi_arsize           (ram_arsize         ),
    .s_axi_arburst          (ram_arburst        ),
    .s_axi_araddr           (ram_araddr[12:0]   ),
    .s_axi_arvalid          (ram_arvalid        ),
    .s_axi_arready          (ram_arready        ),
    .s_axi_rid              (ram_rid            ),
    .s_axi_rdata            (ram_rdata          ),
    .s_axi_rresp            (ram_rresp          ),
    .s_axi_rlast            (ram_rlast          ),
    .s_axi_rvalid           (ram_rvalid         ),
    .s_axi_rready           (ram_rready         )
);

axilite_slave u_uart (
    .s_axi_aclk             (clk                ),
    .s_axi_aresetn          (rst_n              ),
    .s_axi_awaddr           (uart_awaddr[3:0]   ),
    .s_axi_awvalid          (uart_awvalid       ),
    .s_axi_awready          (uart_awready       ),
    .s_axi_wdata            (uart_wdata         ),
    .s_axi_wstrb            (uart_wstrb         ),
    .s_axi_wvalid           (uart_wvalid        ),
    .s_axi_wready           (uart_wready        ),
    .s_axi_bresp            (uart_bresp         ),
    .s_axi_bvalid           (uart_bvalid        ),
    .s_axi_bready           (uart_bready        ),
    .s_axi_araddr           (uart_araddr[3:0]   ),
    .s_axi_arvalid          (uart_arvalid       ),
    .s_axi_arready          (uart_arready       ),
    .s_axi_rdata            (uart_rdata         ),
    .s_axi_rresp            (uart_rresp         ),
    .s_axi_rvalid           (uart_rvalid        ),
    .s_axi_rready           (uart_rready        )
);

axilite_slave u_pio (
    .s_axi_aclk             (clk                ),
    .s_axi_aresetn          (rst_n              ),
    .s_axi_awaddr           (gpio_awaddr[3:0]   ),
    .s_axi_awvalid          (gpio_awvalid       ),
    .s_axi_awready          (gpio_awready       ),
    .s_axi_wdata            (gpio_wdata         ),
    .s_axi_wstrb            (gpio_wstrb         ),
    .s_axi_wvalid           (gpio_wvalid        ),
    .s_axi_wready           (gpio_wready        ),
    .s_axi_bresp            (gpio_bresp         ),
    .s_axi_bvalid           (gpio_bvalid        ),
    .s_axi_bready           (gpio_bready        ),
    .s_axi_araddr           (gpio_araddr[3:0]   ),
    .s_axi_arvalid          (gpio_arvalid       ),
    .s_axi_arready          (gpio_arready       ),
    .s_axi_rdata            (gpio_rdata         ),
    .s_axi_rresp            (gpio_rresp         ),
    .s_axi_rvalid           (gpio_rvalid        ),
    .s_axi_rready           (gpio_rready        )
);

`endif

endmodule

