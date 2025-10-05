/*

Copyright (c) 2018-2021 Alex Forencich

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
 * AXI4-Stream 4 port frame joiner (wrapper)
 */
module axis_frame_join_wrap_4 #
(
    // Width of AXI stream interfaces in bits
    parameter DATA_WIDTH = 8,
    // Prepend data with tag
    parameter TAG_ENABLE = 1,
    // Tag field width
    parameter TAG_WIDTH = 16
)
(
    input  wire                  clk,
    input  wire                  rst,

    /*
     * AXI Stream inputs
     */
    input  wire [DATA_WIDTH-1:0] s00_axis_tdata,
    input  wire                  s00_axis_tvalid,
    output wire                  s00_axis_tready,
    input  wire                  s00_axis_tlast,
    input  wire                  s00_axis_tuser,

    input  wire [DATA_WIDTH-1:0] s01_axis_tdata,
    input  wire                  s01_axis_tvalid,
    output wire                  s01_axis_tready,
    input  wire                  s01_axis_tlast,
    input  wire                  s01_axis_tuser,

    input  wire [DATA_WIDTH-1:0] s02_axis_tdata,
    input  wire                  s02_axis_tvalid,
    output wire                  s02_axis_tready,
    input  wire                  s02_axis_tlast,
    input  wire                  s02_axis_tuser,

    input  wire [DATA_WIDTH-1:0] s03_axis_tdata,
    input  wire                  s03_axis_tvalid,
    output wire                  s03_axis_tready,
    input  wire                  s03_axis_tlast,
    input  wire                  s03_axis_tuser,

    /*
     * AXI Stream output
     */
    output wire [DATA_WIDTH-1:0] m_axis_tdata,
    output wire                  m_axis_tvalid,
    input  wire                  m_axis_tready,
    output wire                  m_axis_tlast,
    output wire                  m_axis_tuser,

    /*
     * Configuration
     */
    input  wire [TAG_WIDTH-1:0]  tag,

    /*
     * Status signals
     */
    output wire                  busy
);

axis_frame_join #(
    .S_COUNT(4),
    .DATA_WIDTH(DATA_WIDTH),
    .TAG_ENABLE(TAG_ENABLE),
    .TAG_WIDTH(TAG_WIDTH)
)
axis_frame_join_inst (
    .clk(clk),
    .rst(rst),
    // AXI inputs
    .s_axis_tdata({ s03_axis_tdata, s02_axis_tdata, s01_axis_tdata, s00_axis_tdata }),
    .s_axis_tvalid({ s03_axis_tvalid, s02_axis_tvalid, s01_axis_tvalid, s00_axis_tvalid }),
    .s_axis_tready({ s03_axis_tready, s02_axis_tready, s01_axis_tready, s00_axis_tready }),
    .s_axis_tlast({ s03_axis_tlast, s02_axis_tlast, s01_axis_tlast, s00_axis_tlast }),
    .s_axis_tuser({ s03_axis_tuser, s02_axis_tuser, s01_axis_tuser, s00_axis_tuser }),
    // AXI output
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tuser(m_axis_tuser),
    // Configuration
    .tag(tag),
    // Status
    .busy(busy)
);

endmodule

`resetall
