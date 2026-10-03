module uart_top #(parameter CLKS_PER_BIT = 8)(
  input clk, rst, start,
  input [7:0] din,
  output busy, valid,
  output [7:0] dout
);
  wire line;
  uart_tx #(CLKS_PER_BIT) tx0(.clk(clk), .rst(rst), .start(start),
    .data(din), .tx(line), .busy(busy));
  uart_rx #(CLKS_PER_BIT) rx0(.clk(clk), .rst(rst), .rx(line),
    .data(dout), .valid(valid));
endmodule