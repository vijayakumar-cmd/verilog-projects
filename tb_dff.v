module tb_dff;

    // Testbench signals
    logic d;
    logic clk;
    logic rst;
    logic q;
    logic qbar;

    // Instantiate the Unit Under Test (UUT)
    dff uut (
        .d(d),
        .clk(clk),
        .rst(rst),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation: toggles every 5 time units (10 unit period)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for the app
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_dff);

        // Print header and monitor signal changes
        $display("Time | rst | clk | d | q | qbar");
        $display("------------------------------");
        $monitor("%4t |  %b  |  %b  | %b | %b |  %b", 
                 $time, rst, clk, d, q, qbar);

        // Initialize inputs
        clk = 0;
        d = 0;
        
        // 1. Apply Reset
        rst = 1; #10;
        rst = 0; 
        
        // 2. Drive D = 1
        d = 1; #10;
        
        // 3. Drive D = 0
        d = 0; #10;
        
        // 4. Drive D = 1 again to show the change
        d = 1; #10;

        // End simulation
        $finish;
    end

endmodule
    