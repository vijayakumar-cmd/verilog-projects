`timescale 1ns/1ps

module tb_adder_subtractor;
    reg  [3:0] A, B;
    reg        M;
    wire [3:0] S;
    wire       Cout, Overflow;

    // Device under test
    adder_subtractor_4bit uut (
        .A(A), .B(B), .M(M),
        .S(S), .Cout(Cout), .Overflow(Overflow)
    );

    initial begin
        // Waveform dump
        $dumpfile("adder_subtractor.vcd");
        $dumpvars(0, tb_adder_subtractor);

        // Console monitor
        $monitor("t=%0t | M=%b A=%b (%0d) B=%b (%0d) | S=%b (%0d) Cout=%b Ovf=%b",
                 $time, M, A, A, B, B, S, S, Cout, Overflow);

        // Addition tests (M = 0)
        M = 0; A = 4'd5;  B = 4'd2;  #10;   // 5 + 2 = 7
        M = 0; A = 4'd5;  B = 4'd3;  #10;   // 5 + 3 = 8  -> signed overflow
        M = 0; A = 4'd9;  B = 4'd7;  #10;   // 9 + 7 = 16 -> carry out

        // Subtraction tests (M = 1)
        M = 1; A = 4'd5;  B = 4'd3;  #10;   // 5 - 3 = 2
        M = 1; A = 4'd3;  B = 4'd5;  #10;   // 3 - 5 = -2 (1110)
        M = 1; A = 4'd7;  B = 4'd7;  #10;   // 7 - 7 = 0

        #10;
        $finish;
    end
endmodule