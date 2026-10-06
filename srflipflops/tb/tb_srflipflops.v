`timescale 1ns/1ps
module tb_srflipflops;
  reg clk;
  reg rst;
  reg [3:0] din;
  wire [3:0] dout;

  srflipflops dut (
    .clk(clk),
    .rst(rst),
    .din(din),
    .dout(dout)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_srflipflops);
    $monitor("%0t clk=%h rst=%h din=%h dout=%h", $time, clk, rst, din, dout);
    clk = 0;
    rst = 1;
    din = 0;
    #20 rst = 0;
    // TODO: drive the inputs here
    repeat (20) @(posedge clk);
    $display("done");
    $finish;
  end
endmodule
    