module uart_rx #(parameter CLKS_PER_BIT = 8)(
  input clk, rst, rx,
  output reg [7:0] data,
  output reg valid
);
  localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;
  reg [1:0] state;
  reg [$clog2(CLKS_PER_BIT)-1:0] cnt;
  reg [2:0] idx;
  reg r1, r2;
  always @(posedge clk) begin r1 <= rx; r2 <= r1; end
  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE; valid <= 0; cnt <= 0; idx <= 0; data <= 0;
    end else begin
      valid <= 0;
      case (state)
        IDLE: begin
          cnt <= 0; idx <= 0;
          if (!r2) state <= START;
        end
        START: begin
          if (cnt == (CLKS_PER_BIT-1)/2) begin
            cnt <= 0;
            if (!r2) state <= DATA; else state <= IDLE;
          end else cnt <= cnt + 1;
        end
        DATA: begin
          if (cnt == CLKS_PER_BIT-1) begin
            cnt <= 0;
            data[idx] <= r2;
            if (idx == 7) state <= STOP; else idx <= idx + 1;
          end else cnt <= cnt + 1;
        end
        STOP: begin
          if (cnt == CLKS_PER_BIT-1) begin
            cnt <= 0; valid <= 1; state <= IDLE;
          end else cnt <= cnt + 1;
        end
      endcase
    end
  end
endmodule