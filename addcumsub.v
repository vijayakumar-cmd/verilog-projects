// ============================================================
// 4-bit Adder-cum-Subtractor (complete code)
// M = 0 -> S = A + B
// M = 1 -> S = A - B  (B flipped, +1 added through carry[0])
// ============================================================

// ---------- 1. Full Adder ----------
module full_adder (
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule


// ---------- 2. 4-bit Adder/Subtractor ----------
module adder_subtractor_4bit (
    input  [3:0] A, B,
    input        M,
    output [3:0] S,
    output       Cout, Overflow
);
    wire [3:0] B_xor = B ^ {4{M}};   // flip B when M = 1
    wire [4:0] carry;

    assign carry[0] = M;             // the "+1" for subtraction

    full_adder FA0 (A[0], B_xor[0], carry[0], S[0], carry[1]);
    full_adder FA1 (A[1], B_xor[1], carry[1], S[1], carry[2]);
    full_adder FA2 (A[2], B_xor[2], carry[2], S[2], carry[3]);
    full_adder FA3 (A[3], B_xor[3], carry[3], S[3], carry[4]);

    assign Cout     = carry[4];
    assign Overflow = carry[4] ^ carry[3];
endmodule


// ---------- 3. Top Module (for FPGA board: switches / LEDs) ----------
module top_adder_subtractor (
    input  [7:0] SW,     // SW[3:0] = A, SW[7:4] = B
    input        BTNC,   // push-button as mode select M
    output [3:0] LED,    // result S
    output       LED_C,  // Cout
    output       LED_V   // Overflow
);
    adder_subtractor_4bit UUT (
        .A(SW[3:0]),
        .B(SW[7:4]),
        .M(BTNC),
        .S(LED),
        .Cout(LED_C),
        .Overflow(LED_V)
    );
endmodule


// ---------- 4. Testbench (for simulation) ----------
module tb_adder_subtractor;
    reg  [3:0] A, B;
    reg        M;
    wire [3:0] S;
    wire       Cout, Overflow;

    adder_subtractor_4bit uut (
        .A(A), .B(B), .M(M),
        .S(S), .Cout(Cout), .Overflow(Overflow)
    );

    initial begin
        $monitor("t=%0t | M=%b A=%b (%0d) B=%b (%0d) | S=%b (%0d) Cout=%b Ovf=%b",
                 $time, M, A, A, B, B, S, S, Cout, Overflow);

        // Addition tests (M = 0)
        M = 0; A = 4'd5;  B = 4'd2;  #10;   // 5 + 2 = 7
        M = 0; A = 4'd5;  B = 4'd3;  #10;   // 5 + 3 = 8 -> signed overflow
        M = 0; A = 4'd9;  B = 4'd7;  #10;   // 9 + 7 = 16 -> carry out

        // Subtraction tests (M = 1)
        M = 1; A = 4'd5;  B = 4'd3;  #10;   // 5 - 3 = 2
        M = 1; A = 4'd3;  B = 4'd5;  #10;   // 3 - 5 = -2 (1110)
        M = 1; A = 4'd7;  B = 4'd7;  #10;   // 7 - 7 = 0

        $finish;
    end
endmodule