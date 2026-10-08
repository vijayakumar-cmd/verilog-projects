`timescale 1ns/1ps

module tb_small;
    reg  [7:0] I;
    reg  [2:0] S;
    wire       Y;

    mux8x1 dut (.I(I), .S(S), .Y(Y));

    initial begin
        $dumpfile("small.vcd");     // name of the waveform file
        $dumpvars(0, tb_small);     // record all signals in this module and below

        I = 8'b10110100;

        S = 3'd0; #10;
        S = 3'd2; #10;
        S = 3'd7; #10;

        $finish;
    end

    initial $monitor("S=%d  Y=%b", S, Y);
endmodule