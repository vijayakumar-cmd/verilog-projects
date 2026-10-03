`timescale 1ns/1ps
module tb_alu;
  reg [3:0] a, b;
  reg [2:0] op;
  reg [3:0] expv;
  wire [3:0] y;
  wire zero;
  alu dut(.a(a), .b(b), .op(op), .y(y), .zero(zero));
  integer i, errors;
  initial begin
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_alu);
    a = 4'd9; b = 4'd5;
    for (i = 0; i < 8; i = i + 1) begin
      op = i;
      #10;
      case (op)
        3'd0: expv = a + b;
        3'd1: expv = a - b;
        3'd2: expv = a & b;
        3'd3: expv = a | b;
        3'd4: expv = a ^ b;
        3'd5: expv = ~a;
        3'd6: expv = a << 1;
        default: expv = a >> 1;
      endcase
      if (y !== expv) errors = errors + 1;
      $display("op=%0d y=%0d expected=%0d", op, y, expv);
    end
    if (errors == 0) $display("PASS");
    else $display("FAIL: %0d errors", errors);
    $finish;
  end
endmodule
    