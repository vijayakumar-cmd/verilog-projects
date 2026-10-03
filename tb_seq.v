`timescale 1ns/1ps
module tb_seq;
  reg clk = 0, rst = 1, din = 0;
  wire found;
  seq_detect dut(.clk(clk), .rst(rst), .din(din), .found(found));
  always #5 clk = ~clk;
  reg [15:0] pattern = 16'b0010110110111010;
  integer i, cnt;
  initial begin
    cnt = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_seq);
    #12 rst = 0;
    for (i = 15; i >= 0; i = i - 1) begin
      din = pattern[i];
      @(posedge clk);
      #1;
      if (found) cnt = cnt + 1;
    end
    #20;
    if (cnt == 3) $display("PASS: 1011 found %0d times", cnt);
    else $display("FAIL: found %0d times", cnt);
    $finish;
  end
endmodule
    