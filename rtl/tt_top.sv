/* SPDX-License-Identifier: Apache-2.0 OR CERN-OHL-P-2.0 */

/*
 * Copyright 2024 Tiny Tapeout Ltd.
 * Copyright 2026 UBC ASIC contributors (Montreal project).
 * All rights reserved.
 *
 * Authors: Tiny Tapeout contributors
 *          Chathil Rajamanthree <chathil.rajaman3@gmail.com>
 *          Colin Yeung          <colinyeung.main@gmail.com>
 *
 * Tiny Tapeout top-level module and QSPI PMOD controller
 */

`default_nettype none

/*
 * Tiny Tapeout top-level wrapper.
 *
 * IMPORTANT: The module definition MUST follow the Tiny Tapeout specification
 *            exactly. Do not modify the port names.
 */
/* verilog_lint: waive module-filename */

`include "config_pkg.sv"

import config_pkg::*;

module tt_top_ubc_montreal (
  /* verilog_lint: waive-start port-name-suffix */
  /* Dedicated inputs. */
  input wire [7:0] ui_in,

  /* Dedicated outputs. */
  output wire [7:0] uo_out,

  /* I/O: input path. */
  input  wire [7:0] uio_in,
  /* I/O: output path. */
  output wire [7:0] uio_out,
  /* I/O: active-high output enable. */
  output wire [7:0] uio_oe,

  /* Design enable signal. This will be 1 when the design is powered. */
  input wire en,
  /* Clock. */
  input wire clk,
  /* Active-low reset. */
  input wire rst_n
  /* verilog_lint: waive-stop port-name-suffix */
);

  // For ALU: to be connected to control unit later
  logic [31:0] a;
  logic [31:0] b;
  logic        sel;
  logic [31:0] y;
  logic        overflow;

  // For regfile: to be connected to control unit later
  logic                [SLICE_ADDR_WIDTH-1:0] slice_sel;
  logic  [NUM_READ_PORTS-1:0][ADDR_WIDTH-1:0] raddr;
  logic [NUM_READ_PORTS-1:0][SLICE_WIDTH-1:0] rdata;
  logic                                       wen;
  logic                     [ADDR_WIDTH-1:0]  waddr;
  logic                     [SLICE_WIDTH-1:0] wdata;

  /* Temporary output assignments. Unused pins must be assigned to 0. */
  assign uo_out  = ui_in + uio_in;
  assign uio_out = '0;
  assign uio_oe  = '0;

  /* Connect all unused inputs to prevent warnings. */
  wire unused = &{ena, clk, rst_n, 1'b0};

  rv32e_core_wrapper u_rv32e_core_wrapper ();

  qspi_controller u_qspi_controller (
    .clk(clk),
    .rst_n(rst_n),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe)
  );

  simple_alu u_simple_alu(
    .clk_i(clk),
    .a_i(a),
    .b_i(b),
    .sel_i(sel),
    .rst_ni(rst_n),
    .y_o(y),
    .overflow_o(overflow)
  );

  regfile #(.XLEN(XLEN),
            .SLICE_WIDTH(SLICE_WIDTH),
            .ADDR_WIDTH(REG_ADDR_WIDTH),
            .NUM_READ_PORTS(REG_NUM_READ_PORTS),
            .NUM_WORDS(2**REG_ADDR_WIDTH),
            .SLICE_ADDR_WIDTH($clog2(XLEN / SLICE_WIDTH))
  ) u_regfile (.clk_i(clk),
               .rst_ni(rst_n),
               .slice_sel_i(slice_sel),
               .raddr_i(raddr),
               .rdata_o(rdata),
               .wen_i(wen),
               .waddr_i(waddr),
               .wdata_i(wdata)
  );

endmodule : tt_top_ubc_montreal
