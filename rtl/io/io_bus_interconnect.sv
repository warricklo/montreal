module io_bus_interconnect (
  /* Generic signals. */
  input wire clk,
  input wire rst_n,

  /* Core-facing port. */
  input  io_bus_req_t  core_req_i,
  output io_bus_resp_t core_resp_o,

  /* Fan-out to QSPI Controller. */
  output io_bus_req_t  qspi_req_i,
  input  io_bus_resp_t qspi_resp_o,

  /* Fan-out to UART Controller. */
  output io_bus_req_t  uart_req_i,
  input  io_bus_resp_t uart_resp_o,

  /* Fan-out to Common Regbank. */
  output io_bus_req_t  regbank_req_i,
  input  io_bus_resp_t regbank_resp_o
 );




endmodule : io_bus_interconnect
