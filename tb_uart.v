`timescale 1ns/1ps
module tb_uart;
  reg clk = 0, rst = 1, start = 0;
  reg [7:0] data;
  wire line, busy, valid;
  wire [7:0] rx_data;
  uart_tx #(8) u_tx(.clk(clk), .rst(rst), .start(start),
    .data(data), .tx(line), .busy(busy));
  uart_rx #(8) u_rx(.clk(clk), .rst(rst), .rx(line),
    .data(rx_data), .valid(valid));
  always #5 clk = ~clk;

  reg [7:0] msg [0:3];
  integer i, errors;

  initial begin
    #100000;
    $display("FAIL: timeout");
    $finish;
  end

  initial begin
    msg[0] = 8'h55; msg[1] = 8'hA3; msg[2] = 8'h00; msg[3] = 8'hFF;
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_uart);
    #30 rst = 0;
    for (i = 0; i < 4; i = i + 1) begin
      @(posedge clk); #1;
      data = msg[i]; start = 1;
      @(posedge clk); #1;
      start = 0;
      @(posedge valid);
      #1;
      if (rx_data !== msg[i]) errors = errors + 1;
      $display("sent %h received %h", msg[i], rx_data);
      wait (!busy);
    end
    #50;
    if (errors == 0) $display("PASS");
    else $display("FAIL: %0d errors", errors);
    $finish;
  end
endmodule