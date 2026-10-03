// 4x1 Multiplexer using Behavioral Modeling 
module mux4x1 (
    input  logic [3:0] I, 
    input  logic [1:0] S, 
    output logic Y
);
    // always_comb is the standard SV block for combinational logic
    always_comb begin 
        case (S) 
            2'b00: Y = I[0]; 
            2'b01: Y = I[1];
            2'b10: Y = I[2]; 
            2'b11: Y = I[3]; 
            default: Y = 1'b0; 
        endcase 
    end 
endmodule 

// 2x1 Multiplexer using Behavioral Modeling 
module mux2x1 ( 
    input  logic [1:0] I, 
    input  logic S, 
    output logic Y 
); 
    always_comb begin 
        case (S) 
            1'b0: Y = I[0]; 
            1'b1: Y = I[1]; 
            default: Y = 1'b0; 
        endcase 
    end 
endmodule 

// 8x1 Multiplexer using two 4x1 MUXes and one 2x1 MUX 
module mux8x1 ( 
    input  logic [7:0] I, 
    input  logic [2:0] S, 
    output logic Y 
); 
    // Replaced wire with logic for internal nets
    logic Y0, Y1; 

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
    