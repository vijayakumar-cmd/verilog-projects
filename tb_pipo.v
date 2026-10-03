module tb_pipo;

    // Testbench signals
    logic clk;
    logic reset;
    logic [3:0] data_in;
    
    // Outputs from the two different modules
    logic [3:0] data_out_beh;
    logic [3:0] data_out_str;

    // Instantiate Behavioral PIPO
    pipo_behavioral uut_beh (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out_beh)
    );

    // Instantiate Structural PIPO
    pipo_structural uut_str (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out_str)
    );

    // Clock generation: toggles every 5 time units (10 unit period)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for the mobile simulator
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pipo);

        // Print header and monitor signal changes
        $display("Time | rst | data_in | out_beh | out_str");
        $display("-------------------------------------------");
        $monitor("%4t |  %b  |   %4b  |   %4b  |   %4b", 
                 $time, reset, data_in, data_out_beh, data_out_str);

        // 1. Initialize and apply reset
        clk = 0;
        data_in = 4'b0000;
        reset = 1; #15; 
        reset = 0;
        
        // 2. Feed parallel data and wait for clock edges
        data_in = 4'b1010; #10; // Load 1010
        data_in = 4'b0101; #10; // Load 0101
        data_in = 4'b1111; #10; // Load 1111
        data_in = 4'b0011; #10; // Load 0011
        
        // 3. Test reset while data is present
        reset = 1; #10;
        reset = 0; #10;

        // End simulation
        $finish;
    end

endmodule
    