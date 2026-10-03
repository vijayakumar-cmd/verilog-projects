module dff (
    input  logic d, 
    input  logic clk, 
    input  logic rst, 
    output logic q, 
    output logic qbar
); 

    // always_ff is the standard SystemVerilog block for sequential logic
    always_ff @(posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            // Upgraded to non-blocking assignments (<=) for flip-flop behavior
            q    <= 1'b0; 
            qbar <= 1'b1; 
        end else begin 
            // Simplified the logic: Q simply follows D on the clock edge
            q    <= d; 
            qbar <= ~d; 
        end 
    end 
endmodule
    