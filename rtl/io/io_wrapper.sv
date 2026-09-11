/* SPDX-License-Identifier: CERN-OHL-P-2.0 */

/*
 * Copyright 2026 UBC ASIC contributors (Montreal project).
 * All rights reserved.
 *
 * Authors: Chathil Rajamanthree <chathil.rajaman3@gmail.com>
 *
 * Montreal RV32E IO Wrapper
 *
 * Provides a clean, generic bus interface between the Montreal core and IO block.
 */

module io_wrapper (
    /* Generic signals. */
    input wire clk,
    input wire rst_n,

    /* Core-facing port. */
    input  io_bus_req_t  core_req_i,
    output io_bus_resp_t core_resp_o,

    /* Sideband port. */
    // TODO

    /* Chip level pins. */
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
 );
    
    io_bus_req_t  uart_req;
    io_bus_resp_t uart_resp;
    io_bus_req_t  qspi_req;
    io_bus_resp_t qspi_resp;
    io_bus_req_t  regbank_req;
    io_bus_resp_t regbank_resp;

    // Contains packet forwarding logic from one master to many slaves
    // TODO: Leave unstitched until relevant modules completed and initial verif complete
    io_bus_interconnect u_io_bus_interconnect (
        /* Generic signals. */
        .clk(),
        .rst_n(),

        /* Core-facing port. */
        .core_req_i(),
        .core_resp_o(),

        /* Fan-out to QSPI Controller. */
        .qspi_req_i(),
        .qspi_resp_o(),

        /* Fan-out to UART Controller. */
        .uart_req_i(),
        .uart_resp_o(),

        /* Fan-out to Common Regbank. */
        .regbank_req_i(),
        .regbank_resp_o()
    );

    // TODO: Leave unstitched until relevant modules completed and initial verif complete
    qspi_controller u_qspi_controller (
        // Clock 
        .clk,
        // Active-low reset
        .rst_n,

        // IO Bus Interconnect path
        .req_i(),
        .resp_o(),

        // I/O: input path
        .uio_in(),
        // I/O: output path
        .uio_out(),
        // I/O: active high output enable
        .uio_oe()
     );

    
    // TODO: Stitch UART module

    // Common register bank
    // TODO: Leave unstitched until relevant modules completed and initial verif complete
    common_reg_bank u_common_reg_bank (
        // Clock 
        .clk(),
        // Active-low reset
        .rst_n(),

        // IO Bus Interconnect path
        .req_i(),
        .resp_o()

        // TODO: Add sideband connections
    );

endmodule : io_wrapper
