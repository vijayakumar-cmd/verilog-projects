module srflipflop (
    input  logic s, 
    input  logic r, 
    input  logic clk, 
    input  logic rst, 
    output logic q, 
    output logic qbar
); 

    // always_ff explicitly declares this as sequential, flip-flop logic
    always_ff @(posedge clk or posedge rst) begin 
        if (rst == 1'b1) begin 
            // Use non-blocking assignments (<=) for sequential logic
            q    <= 1'b0;
            qbar <= 1'b1; 
        end else begin 
            case ({s, r})
                2'b00: begin 
                    q    <= q;      // Hold state
                    qbar <= qbar;
                end 
                2'b01: begin 
                    q    <= 1'b0;   // Reset state
                    qbar <= 1'b1; 
                end 
                2'b10: begin 
                    q    <= 1'b1;   // Set state
                    qbar <= 1'b0; 
                end 
                2'b11: begin 
                    q    <= 1'bx;   // Invalid state
                    qbar <= 1'bx; 
                end 
            endcase
        end 
    end 
endmodule
    