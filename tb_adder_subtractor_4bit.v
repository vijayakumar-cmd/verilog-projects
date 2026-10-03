module tb_adder_subtractor_4bit;

    // Testbench signals
    logic [3:0] A;
    logic [3:0] B;
    logic M;
    logic [3:0] Y;
    logic Cout;

    // Instantiate the Unit Under Test
    adder_subtractor_4bit uut (
        .A(A),
        .B(B),
        .M(M),
        .Y(Y),
        .Cout(Cout)
    );

    initial begin
        // Generate waveform file for the mobile app
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder_subtractor_4bit);

        // Print header and monitor signal changes
        $display("Time | Mode (M) |  A   |  B   | Output (Y) | Cout");
        $display("-------------------------------------------------");
        $monitor("%4t |     %b    | %4b | %4b |    %4b    |   %b", 
                 $time, M, A, B, Y, Cout);

        // 1. Test Addition (M = 0)
        // 5 + 3 = 8 (0101 + 0011 = 1000, Cout = 0)
        M = 0; A = 4'b0101; B = 4'b0011; #10;
        
        // 15 + 2 = 17 (1111 + 0010 = 0001, Cout = 1) -> Tests carry out
        M = 0; A = 4'b1111; B = 4'b0010; #10;
        
        // 2. Test Subtraction (M = 1)
        // 7 - 4 = 3 (0111 - 0100 = 0011, Cout = 1)
        // Note: In 2's complement subtraction, Cout=1 indicates a positive or zero result.
        M = 1; A = 4'b0111; B = 4'b0100; #10;
        
        // 3 - 5 = -2 (0011 - 0101 = 1110, Cout = 0)
        // Note: Cout=0 indicates a negative result in 2's complement form.
        M = 1; A = 4'b0011; B = 4'b0101; #10;

        // End simulation
        $finish;
    end

endmodule
    