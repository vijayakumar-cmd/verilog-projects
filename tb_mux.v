module tb_mux8x1;

    // Testbench signals
    logic [7:0] I;
    logic [2:0] S;
    logic Y;
    
    // Loop variable
    integer i;

    // Instantiate the Unit Under Test (UUT)
    mux8x1 uut (
        .I(I),
        .S(S),
        .Y(Y)
    );

    initial begin
        // Generate waveform file for the app
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_mux8x1);

        // Print header and monitor signal changes
        $display("Time |    I (Data Input)   | S (Select) | Y (Output)");
        $display("------------------------------------------------------");
        $monitor("%4t |      %b     |     %b    |     %b", 
                 $time, I, S, Y);

        // Set a recognizable test pattern on the data inputs
        // I = 8'b10101100
        // I[0]=0, I[1]=0, I[2]=1, I[3]=1, I[4]=0, I[5]=1, I[6]=0, I[7]=1
        I = 8'b10101100;
        
        // Sweep through all 8 select combinations
        for (i = 0; i < 8; i = i + 1) begin
            S = i; 
            #10; // Wait 10 time units for combinational logic to resolve
        end

        // End simulation
        $finish;
    end

endmodule
    