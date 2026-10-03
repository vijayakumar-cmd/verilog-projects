module full_adder (
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module adder_subtractor_4bit (
    input  logic [3:0] A, B,
    input  logic M,
    output logic [3:0] S,
    output logic Cout, Overflow
);
    logic [3:0] B_xor;
    logic [4:0] carry;

    assign B_xor = B ^ {4{M}};
    assign carry[0] = M;

    // Converted positional instantiation to named port mapping for safer connections
    full_adder FA0 (.a(A[0]), .b(B_xor[0]), .cin(carry[0]), .sum(S[0]), .cout(carry[1]));
    full_adder FA1 (.a(A[1]), .b(B_xor[1]), .cin(carry[1]), .sum(S[1]), .cout(carry[2]));
    full_adder FA2 (.a(A[2]), .b(B_xor[2]), .cin(carry[2]), .sum(S[2]), .cout(carry[3]));
    full_adder FA3 (.a(A[3]), .b(B_xor[3]), .cin(carry[3]), .sum(S[3]), .cout(carry[4]));

    assign Cout = carry[4];
    assign Overflow = carry[4] ^ carry[3];
endmodule

module top_adder_subtractor (
    input  logic [7:0] SW,   // SW[3:0]=A, SW[7:4]=B
    input  logic BTNC,       // push-button as mode select M
    output logic [3:0] LED
);
    adder_subtractor_4bit UUT (
        .A(SW[3:0]), 
        .B(SW[7:4]), 
        .M(BTNC), 
        .S(LED),
        .Cout(),      // Explicitly listing unconnected ports is standard SV practice
        .Overflow()
    );
endmodule
    