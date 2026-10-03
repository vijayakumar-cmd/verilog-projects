// 4-Bit SISO Register using Behavioral Modeling
module siso_behavioral (
    input  logic clk,
    input  logic reset,
    input  logic serial_in,
    output logic serial_out
);
    logic [3:0] shift_reg;

    // always_ff is the standard SystemVerilog block for sequential logic
    always_ff @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0000;
        else
            // Shift left: concatenate the lower 3 bits with the new incoming bit
            shift_reg <= {shift_reg[2:0], serial_in};
    end

    assign serial_out = shift_reg[3];
endmodule


// D Flip-Flop for Structural Modeling
module dff_siso (
    input  logic clk,
    input  logic reset,
    input  logic D,
    output logic Q
);
    always_ff @(posedge clk) begin
        if (reset)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule


// 4-Bit SISO Register using Structural Modeling
module siso_structural (
    input  logic clk,
    input  logic reset,
    input  logic serial_in,
    output logic serial_out
);
    // Replaced wire with logic for internal nets
    logic q0, q1, q2, q3;

    dff_siso FF0 (
        .clk(clk), .reset(reset),
        .D(serial_in), .Q(q0)
    );

    dff_siso FF1 (
        .clk(clk), .reset(reset),
        .D(q0), .Q(q1)
    );

    dff_siso FF2 (
        .clk(clk), .reset(reset),
        .D(q1), .Q(q2)
    );

    dff_siso FF3 (
        .clk(clk), .reset(reset),
        .D(q2), .Q(q3)
    );

    assign serial_out = q3;
endmodule
    