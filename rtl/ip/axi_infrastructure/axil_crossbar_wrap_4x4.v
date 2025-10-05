/*

Copyright (c) 2021 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4 lite 4x4 crossbar (wrapper)
 */
module axil_crossbar_wrap_4x4 #
(
    // Width of data bus in bits
    parameter DATA_WIDTH = 32,
    // Width of address bus in bits
    parameter ADDR_WIDTH = 32,
    // Width of wstrb (width of data bus in words)
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    // Number of concurrent operations
    parameter S00_ACCEPT = 16,
    // Number of concurrent operations
    parameter S01_ACCEPT = 16,
    // Number of concurrent operations
    parameter S02_ACCEPT = 16,
    // Number of concurrent operations
    parameter S03_ACCEPT = 16,
    // Number of regions per master interface
    parameter M_REGIONS = 1,
    // Master interface base addresses
    // M_REGIONS concatenated fields of ADDR_WIDTH bits
    parameter M00_BASE_ADDR = 0,
    // Master interface address widths
    // M_REGIONS concatenated fields of 32 bits
    parameter M00_ADDR_WIDTH = {M_REGIONS{32'd24}},
    // Read connections between interfaces
    // S_COUNT bits
    parameter M00_CONNECT_READ = 4'b1111,
    // Write connections between interfaces
    // S_COUNT bits
    parameter M00_CONNECT_WRITE = 4'b1111,
    // Number of concurrent operations for each master interface
    parameter M00_ISSUE = 16,
    // Secure master (fail operations based on awprot/arprot)
    parameter M00_SECURE = 0,
    // Master interface base addresses
    // M_REGIONS concatenated fields of ADDR_WIDTH bits
    parameter M01_BASE_ADDR = 0,
    // Master interface address widths
    // M_REGIONS concatenated fields of 32 bits
    parameter M01_ADDR_WIDTH = {M_REGIONS{32'd24}},
    // Read connections between interfaces
    // S_COUNT bits
    parameter M01_CONNECT_READ = 4'b1111,
    // Write connections between interfaces
    // S_COUNT bits
    parameter M01_CONNECT_WRITE = 4'b1111,
    // Number of concurrent operations for each master interface
    parameter M01_ISSUE = 16,
    // Secure master (fail operations based on awprot/arprot)
    parameter M01_SECURE = 0,
    // Master interface base addresses
    // M_REGIONS concatenated fields of ADDR_WIDTH bits
    parameter M02_BASE_ADDR = 0,
    // Master interface address widths
    // M_REGIONS concatenated fields of 32 bits
    parameter M02_ADDR_WIDTH = {M_REGIONS{32'd24}},
    // Read connections between interfaces
    // S_COUNT bits
    parameter M02_CONNECT_READ = 4'b1111,
    // Write connections between interfaces
    // S_COUNT bits
    parameter M02_CONNECT_WRITE = 4'b1111,
    // Number of concurrent operations for each master interface
    parameter M02_ISSUE = 16,
    // Secure master (fail operations based on awprot/arprot)
    parameter M02_SECURE = 0,
    // Master interface base addresses
    // M_REGIONS concatenated fields of ADDR_WIDTH bits
    parameter M03_BASE_ADDR = 0,
    // Master interface address widths
    // M_REGIONS concatenated fields of 32 bits
    parameter M03_ADDR_WIDTH = {M_REGIONS{32'd24}},
    // Read connections between interfaces
    // S_COUNT bits
    parameter M03_CONNECT_READ = 4'b1111,
    // Write connections between interfaces
    // S_COUNT bits
    parameter M03_CONNECT_WRITE = 4'b1111,
    // Number of concurrent operations for each master interface
    parameter M03_ISSUE = 16,
    // Secure master (fail operations based on awprot/arprot)
    parameter M03_SECURE = 0,
    // Slave interface AW channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S00_AW_REG_TYPE = 0,
    // Slave interface W channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S00_W_REG_TYPE = 0,
    // Slave interface B channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S00_B_REG_TYPE = 1,
    // Slave interface AR channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S00_AR_REG_TYPE = 0,
    // Slave interface R channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S00_R_REG_TYPE = 2,
    // Slave interface AW channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S01_AW_REG_TYPE = 0,
    // Slave interface W channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S01_W_REG_TYPE = 0,
    // Slave interface B channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S01_B_REG_TYPE = 1,
    // Slave interface AR channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S01_AR_REG_TYPE = 0,
    // Slave interface R channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S01_R_REG_TYPE = 2,
    // Slave interface AW channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S02_AW_REG_TYPE = 0,
    // Slave interface W channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S02_W_REG_TYPE = 0,
    // Slave interface B channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S02_B_REG_TYPE = 1,
    // Slave interface AR channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S02_AR_REG_TYPE = 0,
    // Slave interface R channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S02_R_REG_TYPE = 2,
    // Slave interface AW channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S03_AW_REG_TYPE = 0,
    // Slave interface W channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S03_W_REG_TYPE = 0,
    // Slave interface B channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S03_B_REG_TYPE = 1,
    // Slave interface AR channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S03_AR_REG_TYPE = 0,
    // Slave interface R channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter S03_R_REG_TYPE = 2,
    // Master interface AW channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M00_AW_REG_TYPE = 1,
    // Master interface W channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M00_W_REG_TYPE = 2,
    // Master interface B channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M00_B_REG_TYPE = 0,
    // Master interface AR channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M00_AR_REG_TYPE = 1,
    // Master interface R channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M00_R_REG_TYPE = 0,
    // Master interface AW channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M01_AW_REG_TYPE = 1,
    // Master interface W channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M01_W_REG_TYPE = 2,
    // Master interface B channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M01_B_REG_TYPE = 0,
    // Master interface AR channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M01_AR_REG_TYPE = 1,
    // Master interface R channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M01_R_REG_TYPE = 0,
    // Master interface AW channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M02_AW_REG_TYPE = 1,
    // Master interface W channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M02_W_REG_TYPE = 2,
    // Master interface B channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M02_B_REG_TYPE = 0,
    // Master interface AR channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M02_AR_REG_TYPE = 1,
    // Master interface R channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M02_R_REG_TYPE = 0,
    // Master interface AW channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M03_AW_REG_TYPE = 1,
    // Master interface W channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M03_W_REG_TYPE = 2,
    // Master interface B channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M03_B_REG_TYPE = 0,
    // Master interface AR channel register type (output)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M03_AR_REG_TYPE = 1,
    // Master interface R channel register type (input)
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter M03_R_REG_TYPE = 0
)
(
    input  wire                     clk,
    input  wire                     rst,

    /*
     * AXI lite slave interfaces
     */
    input  wire [ADDR_WIDTH-1:0]    s00_axil_awaddr,
    input  wire [2:0]               s00_axil_awprot,
    input  wire                     s00_axil_awvalid,
    output wire                     s00_axil_awready,
    input  wire [DATA_WIDTH-1:0]    s00_axil_wdata,
    input  wire [STRB_WIDTH-1:0]    s00_axil_wstrb,
    input  wire                     s00_axil_wvalid,
    output wire                     s00_axil_wready,
    output wire [1:0]               s00_axil_bresp,
    output wire                     s00_axil_bvalid,
    input  wire                     s00_axil_bready,
    input  wire [ADDR_WIDTH-1:0]    s00_axil_araddr,
    input  wire [2:0]               s00_axil_arprot,
    input  wire                     s00_axil_arvalid,
    output wire                     s00_axil_arready,
    output wire [DATA_WIDTH-1:0]    s00_axil_rdata,
    output wire [1:0]               s00_axil_rresp,
    output wire                     s00_axil_rvalid,
    input  wire                     s00_axil_rready,

    input  wire [ADDR_WIDTH-1:0]    s01_axil_awaddr,
    input  wire [2:0]               s01_axil_awprot,
    input  wire                     s01_axil_awvalid,
    output wire                     s01_axil_awready,
    input  wire [DATA_WIDTH-1:0]    s01_axil_wdata,
    input  wire [STRB_WIDTH-1:0]    s01_axil_wstrb,
    input  wire                     s01_axil_wvalid,
    output wire                     s01_axil_wready,
    output wire [1:0]               s01_axil_bresp,
    output wire                     s01_axil_bvalid,
    input  wire                     s01_axil_bready,
    input  wire [ADDR_WIDTH-1:0]    s01_axil_araddr,
    input  wire [2:0]               s01_axil_arprot,
    input  wire                     s01_axil_arvalid,
    output wire                     s01_axil_arready,
    output wire [DATA_WIDTH-1:0]    s01_axil_rdata,
    output wire [1:0]               s01_axil_rresp,
    output wire                     s01_axil_rvalid,
    input  wire                     s01_axil_rready,

    input  wire [ADDR_WIDTH-1:0]    s02_axil_awaddr,
    input  wire [2:0]               s02_axil_awprot,
    input  wire                     s02_axil_awvalid,
    output wire                     s02_axil_awready,
    input  wire [DATA_WIDTH-1:0]    s02_axil_wdata,
    input  wire [STRB_WIDTH-1:0]    s02_axil_wstrb,
    input  wire                     s02_axil_wvalid,
    output wire                     s02_axil_wready,
    output wire [1:0]               s02_axil_bresp,
    output wire                     s02_axil_bvalid,
    input  wire                     s02_axil_bready,
    input  wire [ADDR_WIDTH-1:0]    s02_axil_araddr,
    input  wire [2:0]               s02_axil_arprot,
    input  wire                     s02_axil_arvalid,
    output wire                     s02_axil_arready,
    output wire [DATA_WIDTH-1:0]    s02_axil_rdata,
    output wire [1:0]               s02_axil_rresp,
    output wire                     s02_axil_rvalid,
    input  wire                     s02_axil_rready,

    input  wire [ADDR_WIDTH-1:0]    s03_axil_awaddr,
    input  wire [2:0]               s03_axil_awprot,
    input  wire                     s03_axil_awvalid,
    output wire                     s03_axil_awready,
    input  wire [DATA_WIDTH-1:0]    s03_axil_wdata,
    input  wire [STRB_WIDTH-1:0]    s03_axil_wstrb,
    input  wire                     s03_axil_wvalid,
    output wire                     s03_axil_wready,
    output wire [1:0]               s03_axil_bresp,
    output wire                     s03_axil_bvalid,
    input  wire                     s03_axil_bready,
    input  wire [ADDR_WIDTH-1:0]    s03_axil_araddr,
    input  wire [2:0]               s03_axil_arprot,
    input  wire                     s03_axil_arvalid,
    output wire                     s03_axil_arready,
    output wire [DATA_WIDTH-1:0]    s03_axil_rdata,
    output wire [1:0]               s03_axil_rresp,
    output wire                     s03_axil_rvalid,
    input  wire                     s03_axil_rready,

    /*
     * AXI lite master interfaces
     */
    output wire [ADDR_WIDTH-1:0]    m00_axil_awaddr,
    output wire [2:0]               m00_axil_awprot,
    output wire                     m00_axil_awvalid,
    input  wire                     m00_axil_awready,
    output wire [DATA_WIDTH-1:0]    m00_axil_wdata,
    output wire [STRB_WIDTH-1:0]    m00_axil_wstrb,
    output wire                     m00_axil_wvalid,
    input  wire                     m00_axil_wready,
    input  wire [1:0]               m00_axil_bresp,
    input  wire                     m00_axil_bvalid,
    output wire                     m00_axil_bready,
    output wire [ADDR_WIDTH-1:0]    m00_axil_araddr,
    output wire [2:0]               m00_axil_arprot,
    output wire                     m00_axil_arvalid,
    input  wire                     m00_axil_arready,
    input  wire [DATA_WIDTH-1:0]    m00_axil_rdata,
    input  wire [1:0]               m00_axil_rresp,
    input  wire                     m00_axil_rvalid,
    output wire                     m00_axil_rready,

    output wire [ADDR_WIDTH-1:0]    m01_axil_awaddr,
    output wire [2:0]               m01_axil_awprot,
    output wire                     m01_axil_awvalid,
    input  wire                     m01_axil_awready,
    output wire [DATA_WIDTH-1:0]    m01_axil_wdata,
    output wire [STRB_WIDTH-1:0]    m01_axil_wstrb,
    output wire                     m01_axil_wvalid,
    input  wire                     m01_axil_wready,
    input  wire [1:0]               m01_axil_bresp,
    input  wire                     m01_axil_bvalid,
    output wire                     m01_axil_bready,
    output wire [ADDR_WIDTH-1:0]    m01_axil_araddr,
    output wire [2:0]               m01_axil_arprot,
    output wire                     m01_axil_arvalid,
    input  wire                     m01_axil_arready,
    input  wire [DATA_WIDTH-1:0]    m01_axil_rdata,
    input  wire [1:0]               m01_axil_rresp,
    input  wire                     m01_axil_rvalid,
    output wire                     m01_axil_rready,

    output wire [ADDR_WIDTH-1:0]    m02_axil_awaddr,
    output wire [2:0]               m02_axil_awprot,
    output wire                     m02_axil_awvalid,
    input  wire                     m02_axil_awready,
    output wire [DATA_WIDTH-1:0]    m02_axil_wdata,
    output wire [STRB_WIDTH-1:0]    m02_axil_wstrb,
    output wire                     m02_axil_wvalid,
    input  wire                     m02_axil_wready,
    input  wire [1:0]               m02_axil_bresp,
    input  wire                     m02_axil_bvalid,
    output wire                     m02_axil_bready,
    output wire [ADDR_WIDTH-1:0]    m02_axil_araddr,
    output wire [2:0]               m02_axil_arprot,
    output wire                     m02_axil_arvalid,
    input  wire                     m02_axil_arready,
    input  wire [DATA_WIDTH-1:0]    m02_axil_rdata,
    input  wire [1:0]               m02_axil_rresp,
    input  wire                     m02_axil_rvalid,
    output wire                     m02_axil_rready,

    output wire [ADDR_WIDTH-1:0]    m03_axil_awaddr,
    output wire [2:0]               m03_axil_awprot,
    output wire                     m03_axil_awvalid,
    input  wire                     m03_axil_awready,
    output wire [DATA_WIDTH-1:0]    m03_axil_wdata,
    output wire [STRB_WIDTH-1:0]    m03_axil_wstrb,
    output wire                     m03_axil_wvalid,
    input  wire                     m03_axil_wready,
    input  wire [1:0]               m03_axil_bresp,
    input  wire                     m03_axil_bvalid,
    output wire                     m03_axil_bready,
    output wire [ADDR_WIDTH-1:0]    m03_axil_araddr,
    output wire [2:0]               m03_axil_arprot,
    output wire                     m03_axil_arvalid,
    input  wire                     m03_axil_arready,
    input  wire [DATA_WIDTH-1:0]    m03_axil_rdata,
    input  wire [1:0]               m03_axil_rresp,
    input  wire                     m03_axil_rvalid,
    output wire                     m03_axil_rready
);

localparam S_COUNT = 4;
localparam M_COUNT = 4;

// parameter sizing helpers
function [ADDR_WIDTH*M_REGIONS-1:0] w_a_r(input [ADDR_WIDTH*M_REGIONS-1:0] val);
    w_a_r = val;
endfunction

function [32*M_REGIONS-1:0] w_32_r(input [32*M_REGIONS-1:0] val);
    w_32_r = val;
endfunction

function [S_COUNT-1:0] w_s(input [S_COUNT-1:0] val);
    w_s = val;
endfunction

function [31:0] w_32(input [31:0] val);
    w_32 = val;
endfunction

function [1:0] w_2(input [1:0] val);
    w_2 = val;
endfunction

function w_1(input val);
    w_1 = val;
endfunction

axil_crossbar #(
    .S_COUNT(S_COUNT),
    .M_COUNT(M_COUNT),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .S_ACCEPT({ w_32(S03_ACCEPT), w_32(S02_ACCEPT), w_32(S01_ACCEPT), w_32(S00_ACCEPT) }),
    .M_REGIONS(M_REGIONS),
    .M_BASE_ADDR({ w_a_r(M03_BASE_ADDR), w_a_r(M02_BASE_ADDR), w_a_r(M01_BASE_ADDR), w_a_r(M00_BASE_ADDR) }),
    .M_ADDR_WIDTH({ w_32_r(M03_ADDR_WIDTH), w_32_r(M02_ADDR_WIDTH), w_32_r(M01_ADDR_WIDTH), w_32_r(M00_ADDR_WIDTH) }),
    .M_CONNECT_READ({ w_s(M03_CONNECT_READ), w_s(M02_CONNECT_READ), w_s(M01_CONNECT_READ), w_s(M00_CONNECT_READ) }),
    .M_CONNECT_WRITE({ w_s(M03_CONNECT_WRITE), w_s(M02_CONNECT_WRITE), w_s(M01_CONNECT_WRITE), w_s(M00_CONNECT_WRITE) }),
    .M_ISSUE({ w_32(M03_ISSUE), w_32(M02_ISSUE), w_32(M01_ISSUE), w_32(M00_ISSUE) }),
    .M_SECURE({ w_1(M03_SECURE), w_1(M02_SECURE), w_1(M01_SECURE), w_1(M00_SECURE) }),
    .S_AR_REG_TYPE({ w_2(S03_AR_REG_TYPE), w_2(S02_AR_REG_TYPE), w_2(S01_AR_REG_TYPE), w_2(S00_AR_REG_TYPE) }),
    .S_R_REG_TYPE({ w_2(S03_R_REG_TYPE), w_2(S02_R_REG_TYPE), w_2(S01_R_REG_TYPE), w_2(S00_R_REG_TYPE) }),
    .S_AW_REG_TYPE({ w_2(S03_AW_REG_TYPE), w_2(S02_AW_REG_TYPE), w_2(S01_AW_REG_TYPE), w_2(S00_AW_REG_TYPE) }),
    .S_W_REG_TYPE({ w_2(S03_W_REG_TYPE), w_2(S02_W_REG_TYPE), w_2(S01_W_REG_TYPE), w_2(S00_W_REG_TYPE) }),
    .S_B_REG_TYPE({ w_2(S03_B_REG_TYPE), w_2(S02_B_REG_TYPE), w_2(S01_B_REG_TYPE), w_2(S00_B_REG_TYPE) }),
    .M_AR_REG_TYPE({ w_2(M03_AR_REG_TYPE), w_2(M02_AR_REG_TYPE), w_2(M01_AR_REG_TYPE), w_2(M00_AR_REG_TYPE) }),
    .M_R_REG_TYPE({ w_2(M03_R_REG_TYPE), w_2(M02_R_REG_TYPE), w_2(M01_R_REG_TYPE), w_2(M00_R_REG_TYPE) }),
    .M_AW_REG_TYPE({ w_2(M03_AW_REG_TYPE), w_2(M02_AW_REG_TYPE), w_2(M01_AW_REG_TYPE), w_2(M00_AW_REG_TYPE) }),
    .M_W_REG_TYPE({ w_2(M03_W_REG_TYPE), w_2(M02_W_REG_TYPE), w_2(M01_W_REG_TYPE), w_2(M00_W_REG_TYPE) }),
    .M_B_REG_TYPE({ w_2(M03_B_REG_TYPE), w_2(M02_B_REG_TYPE), w_2(M01_B_REG_TYPE), w_2(M00_B_REG_TYPE) })
)
axil_crossbar_inst (
    .clk(clk),
    .rst(rst),
    .s_axil_awaddr({ s03_axil_awaddr, s02_axil_awaddr, s01_axil_awaddr, s00_axil_awaddr }),
    .s_axil_awprot({ s03_axil_awprot, s02_axil_awprot, s01_axil_awprot, s00_axil_awprot }),
    .s_axil_awvalid({ s03_axil_awvalid, s02_axil_awvalid, s01_axil_awvalid, s00_axil_awvalid }),
    .s_axil_awready({ s03_axil_awready, s02_axil_awready, s01_axil_awready, s00_axil_awready }),
    .s_axil_wdata({ s03_axil_wdata, s02_axil_wdata, s01_axil_wdata, s00_axil_wdata }),
    .s_axil_wstrb({ s03_axil_wstrb, s02_axil_wstrb, s01_axil_wstrb, s00_axil_wstrb }),
    .s_axil_wvalid({ s03_axil_wvalid, s02_axil_wvalid, s01_axil_wvalid, s00_axil_wvalid }),
    .s_axil_wready({ s03_axil_wready, s02_axil_wready, s01_axil_wready, s00_axil_wready }),
    .s_axil_bresp({ s03_axil_bresp, s02_axil_bresp, s01_axil_bresp, s00_axil_bresp }),
    .s_axil_bvalid({ s03_axil_bvalid, s02_axil_bvalid, s01_axil_bvalid, s00_axil_bvalid }),
    .s_axil_bready({ s03_axil_bready, s02_axil_bready, s01_axil_bready, s00_axil_bready }),
    .s_axil_araddr({ s03_axil_araddr, s02_axil_araddr, s01_axil_araddr, s00_axil_araddr }),
    .s_axil_arprot({ s03_axil_arprot, s02_axil_arprot, s01_axil_arprot, s00_axil_arprot }),
    .s_axil_arvalid({ s03_axil_arvalid, s02_axil_arvalid, s01_axil_arvalid, s00_axil_arvalid }),
    .s_axil_arready({ s03_axil_arready, s02_axil_arready, s01_axil_arready, s00_axil_arready }),
    .s_axil_rdata({ s03_axil_rdata, s02_axil_rdata, s01_axil_rdata, s00_axil_rdata }),
    .s_axil_rresp({ s03_axil_rresp, s02_axil_rresp, s01_axil_rresp, s00_axil_rresp }),
    .s_axil_rvalid({ s03_axil_rvalid, s02_axil_rvalid, s01_axil_rvalid, s00_axil_rvalid }),
    .s_axil_rready({ s03_axil_rready, s02_axil_rready, s01_axil_rready, s00_axil_rready }),
    .m_axil_awaddr({ m03_axil_awaddr, m02_axil_awaddr, m01_axil_awaddr, m00_axil_awaddr }),
    .m_axil_awprot({ m03_axil_awprot, m02_axil_awprot, m01_axil_awprot, m00_axil_awprot }),
    .m_axil_awvalid({ m03_axil_awvalid, m02_axil_awvalid, m01_axil_awvalid, m00_axil_awvalid }),
    .m_axil_awready({ m03_axil_awready, m02_axil_awready, m01_axil_awready, m00_axil_awready }),
    .m_axil_wdata({ m03_axil_wdata, m02_axil_wdata, m01_axil_wdata, m00_axil_wdata }),
    .m_axil_wstrb({ m03_axil_wstrb, m02_axil_wstrb, m01_axil_wstrb, m00_axil_wstrb }),
    .m_axil_wvalid({ m03_axil_wvalid, m02_axil_wvalid, m01_axil_wvalid, m00_axil_wvalid }),
    .m_axil_wready({ m03_axil_wready, m02_axil_wready, m01_axil_wready, m00_axil_wready }),
    .m_axil_bresp({ m03_axil_bresp, m02_axil_bresp, m01_axil_bresp, m00_axil_bresp }),
    .m_axil_bvalid({ m03_axil_bvalid, m02_axil_bvalid, m01_axil_bvalid, m00_axil_bvalid }),
    .m_axil_bready({ m03_axil_bready, m02_axil_bready, m01_axil_bready, m00_axil_bready }),
    .m_axil_araddr({ m03_axil_araddr, m02_axil_araddr, m01_axil_araddr, m00_axil_araddr }),
    .m_axil_arprot({ m03_axil_arprot, m02_axil_arprot, m01_axil_arprot, m00_axil_arprot }),
    .m_axil_arvalid({ m03_axil_arvalid, m02_axil_arvalid, m01_axil_arvalid, m00_axil_arvalid }),
    .m_axil_arready({ m03_axil_arready, m02_axil_arready, m01_axil_arready, m00_axil_arready }),
    .m_axil_rdata({ m03_axil_rdata, m02_axil_rdata, m01_axil_rdata, m00_axil_rdata }),
    .m_axil_rresp({ m03_axil_rresp, m02_axil_rresp, m01_axil_rresp, m00_axil_rresp }),
    .m_axil_rvalid({ m03_axil_rvalid, m02_axil_rvalid, m01_axil_rvalid, m00_axil_rvalid }),
    .m_axil_rready({ m03_axil_rready, m02_axil_rready, m01_axil_rready, m00_axil_rready })
);

endmodule

`resetall
