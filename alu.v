module alu(input [3:0] a, b, input [2:0] op,
           output reg [3:0] y, output reg zero);
  always @(*) begin
    case (op)
      3'd0: y = a + b;
      3'd1: y = a - b;
      3'd2: y = a & b;
      3'd3: y = a | b;
      3'd4: y = a ^ b;
      3'd5: y = ~a;
      3'd6: y = a << 1;
      3'd7: y = a >> 1;
    endcase
    zero = (y == 0);
  end
endmodule
    