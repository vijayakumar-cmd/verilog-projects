module srflipflop(input s, r, clk, rst, output reg q, output qbar);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else case ({s, r})
            2'b00: q <= q;      // hold
            2'b01: q <= 1'b0;   // reset
            2'b10: q <= 1'b1;   // set
            2'b11: q <= 1'bx;   // invalid (or pick 1'b0)
        endcase
    end
    assign qbar = ~q;
endmodule