`timescale 1ns/1ps
module tb_counter;
  reg clk = 0, rst = 1;
  wire [3:0] q;
  counter dut(.clk(clk), .rst(rst), .q(q));
  always #5 clk = ~clk;
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_counter);
    #22 rst = 0;
    #100;
    if (q == 4'd10) $display("PASS q=%0d", q);
    else $display("FAIL q=%0d", q);
    $finish;
  end
endmodule
    