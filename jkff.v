module jkff (
    input  logic j, 
    input  logic k, 
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
            // A case statement is much cleaner for truth tables than an if-else chain
            case ({j, k})
                2'b00: begin 
                    q    <= q;       // Hold
                    qbar <= qbar; 
                end 
                2'b01: begin 
                    q    <= 1'b0;    // Reset
                    qbar <= 1'b1; 
                end 
                2'b10: begin 
                    q    <= 1'b1;    // Set
                    qbar <= 1'b0; 
                end 
                2'b11: begin 
                    q    <= ~q;      // Toggle (The unique feature of a JK flip-flop)
                    qbar <= ~qbar; 
                end 
            endcase
        end 
    end 
endmodule
    