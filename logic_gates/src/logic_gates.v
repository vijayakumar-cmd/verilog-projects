// Basic & Universal Logic Gates using Dataflow Modeling
module logic_gates (
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_not,
    output wire out_nand,
    output wire out_nor,
    output wire out_xor,
    output wire out_xnor
);

    assign out_and  = a & b;   // AND Gate
    assign out_or   = a | b;   // OR Gate
    assign out_not  = ~a;      // NOT Gate (Inverter)
    assign out_nand = ~(a & b);// NAND Gate
    assign out_nor  = ~(a | b);// NOR Gate
    assign out_xor  = a ^ b;   // XOR Gate
    assign out_xnor = ~(a ^ b);// XNOR Gate

endmodule
    