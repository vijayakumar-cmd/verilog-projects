module tb_adder_subtractor_4bit;

    // Testbench signals
    logic [3:0] A;
    logic [3:0] B;
    logic       M;
    logic [3:0] S;
    logic       Cout;
    logic       Overflow;

    // Instantiate the Unit Under Test (UUT)
    adder_subtractor_4bit uut (
        .A(A),
        .B(B),
        .M(M),
        .S(S),
        .Cout(Cout),
        .Overflow(Overflow)
    );

    initial begin
        // Generate waveform file
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder_subtractor_4bit);

        // Print header and monitor signal changes
        $display("Time | M (Mode) | A    | B    | S (Sum/Diff) | Cout | Overflow");
        $display("---------------------------------------------------------------");
        $monitor("%4t |    %0b     | %4b | %4b |     %4b     |   %0b  |    %0b", 
                 $time, M, A, B, S, Cout, Overflow);

        // Test Case 1: Standard Addition (5 + 3 = 8)
        M = 0; A = 4'b0101; B = 4'b0011; #10;
        
        // Test Case 2: Standard Subtraction (5 - 3 = 2)
        M = 1; A = 4'b0101; B = 4'b0011; #10;

        // Test Case 3: Subtraction yielding a negative number (3 - 5 = -2)
        // Result 'S' should be 1110 (2's complement for -2)
        M = 1; A = 4'b0011; B = 4'b0101; #10;

        // Test Case 4: Addition causing signed overflow (7 + 1)
        // 0111 + 0001 = 1000 (-8 in signed representation). Overflow should be 1.
        M = 0; A = 4'b0111; B = 4'b0001; #10;

        // Test Case 5: Subtraction causing signed overflow (-8 - 1)
        // 1000 - 0001 = 0111 (+7 in signed representation). Overflow should be 1.
        M = 1; A = 4'b1000; B = 4'b0001; #10;

        // End simulation
        $finish;
    end

endmodule
    