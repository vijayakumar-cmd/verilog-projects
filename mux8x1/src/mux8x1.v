// 4x1 Multiplexer
module mux4x1 (
    input  wire [3:0] I,
    input  wire [1:0] S,
    output reg        Y
);
    always @(*) begin
        case (S)
            2'b00:   Y = I[0];
            2'b01:   Y = I[1];
            2'b10:   Y = I[2];
            2'b11:   Y = I[3];
            default: Y = 1'b0;
        endcase
    end
endmodule

// 2x1 Multiplexer
module mux2x1 (
    input  wire [1:0] I,
    input  wire       S,
    output reg        Y
);
    always @(*) begin
        case (S)
            1'b0:    Y = I[0];
            1'b1:    Y = I[1];
            default: Y = 1'b0;
        endcase
    end
endmodule

// 8x1 Multiplexer using two 4x1 MUXes and one 2x1 MUX
module mux8x1 (
    input  wire [7:0] I,
    input  wire [2:0] S,
    output wire       Y
);
    wire Y0, Y1;

    mux4x1 M1 (
        .I(I[3:0]),
        .S(S[1:0]),
        .Y(Y0)
    );

    mux4x1 M2 (
        .I(I[7:4]),
        .S(S[1:0]),
        .Y(Y1)
    );

    mux2x1 M3 (
        .I({Y1, Y0}),
        .S(S[2]),
        .Y(Y)
    );
endmodule