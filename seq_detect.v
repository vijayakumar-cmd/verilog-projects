module seq_detect(input clk, input rst, input din, output reg found);
  localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3;
  reg [1:0] state;
  always @(posedge clk) begin
    if (rst) begin
      state <= S0;
      found <= 0;
    end else begin
      found <= 0;
      case (state)
        S0: state <= din ? S1 : S0;
        S1: state <= din ? S1 : S2;
        S2: state <= din ? S3 : S0;
        S3: begin
          if (din) begin found <= 1; state <= S1; end
          else state <= S2;
        end
      endcase
    end
  end
endmodule
    