module tb_siso;

    // Testbench signals
    logic clk;
    logic reset;
    logic serial_in;
    
    // Outputs from the two different modules
    logic serial_out_beh;
    logic serial_out_str;

    // Instantiate Behavioral SISO
    siso_behavioral uut_beh (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .serial_out(serial_out_beh)
    );

    // Instantiate Structural SISO
    siso_structural uut_str (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .serial_out(serial_out_str)
    );

    // Clock generation: toggles every 5 time units (10 unit period)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for the mobile app
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_siso);

        // Print header and monitor signal changes
        $display("Time | rst | serial_in | out_beh | out_str");
        $display("-------------------------------------------");
        $monitor("%4t |  %b  |     %b     |    %b    |    %b", 
                 $time, reset, serial_in, serial_out_beh, serial_out_str);

        // 1. Initialize and reset
        clk = 0;
        serial_in = 0;
        reset = 1; #15; // Hold reset through the first rising edge
        reset = 0;
        
        // 2. Feed sequence: 1, 1, 0, 1
        // Shift in a 1
        serial_in = 1; #10;
        
        // Shift in another 1
        serial_in = 1; #10;
        
        // Shift in a 0
        serial_in = 0; #10;
        
        // Shift in a 1 (By the end of this cycle, the first '1' appears at the output)
        serial_in = 1; #10;
        
        // 3. Shift in 0s to flush the register and watch the rest of the sequence emerge
        serial_in = 0; #10;
        serial_in = 0; #10;
        serial_in = 0; #10;
        serial_in = 0; #10;

        // End simulation
        $finish;
    end

endmodule
    