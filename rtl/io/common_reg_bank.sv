module common_reg_bank (
  /* Generic signals. */
  input wire clk,
  input wire rst_n,

  /* Core-facing port. */
  input  io_bus_req_t  req_i,
  output io_bus_resp_t resp_o

  // TODO: Add sideband connections
 );

endmodule