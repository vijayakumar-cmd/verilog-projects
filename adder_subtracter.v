module ader_subtractor_4bit ( 
    input  logic [3:0] A, 
    input  logic [3:0] B, 
    input  logic M, 
    output logic [3:0] Y, 
    output logic Cout 
); 
    // always_comb replaces always @(*) for combinational logic
    always_comb begin 
        if (M == 1'b0) begin 
            // Addition 
            {Cout, Y} = A + B; 
        end else begin 
            // Subtraction using 2's complement (A - B = A + ~B + 1)
            {Cout, Y} = A + (~B) + 1'b1; 
        end 
    end 
endmodule 
    