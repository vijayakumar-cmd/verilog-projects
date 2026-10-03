// 4-Bit PIPO Register using Behavioral Modeling
module pipo_behavioral (
    input  logic clk,
    input  logic reset,
    input  logic [3:0] data_in,
    output logic [3:0] data_out
);
    // always_ff replaces always @ for sequential flip-flop logic
    always_ff @(posedge clk) begin
        if (reset)
            data_out <= 4'b0000;
        else
            data_out <= data_in;
    end
endmodule


// D Flip-Flop for PIPO Register
module dff_pipo (
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


// 4-Bit PIPO Register using Structural Modeling
module pipo_structural (
    input  logic clk,
    input  logic reset,
    input  logic [3:0] data_in,
    output logic [3:0] data_out
);
    dff_pipo FF0 (
        .clk(clk), .reset(reset),
        .D(data_in[0]), .Q(data_out[0])
    );
    
    dff_pipo FF1 (
        .clk(clk), .reset(reset),
        .D(data_in[1]), .Q(data_out[1])
    );
    
    dff_pipo FF2 (
        .clk(clk), .reset(reset),
        .D(data_in[2]), .Q(data_out[2])
    );
    
    dff_pipo FF3 (
        .clk(clk), .reset(reset),
        .D(data_in[3]), .Q(data_out[3])
    );
endmodule
    