module tb_jkff;

    // Testbench signals
    logic j;
    logic k;
    logic clk;
    logic rst;
    logic q;
    logic qbar;

    // Instantiate the Unit Under Test (UUT)
    jkff uut (
        .j(j),
        .k(k),
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
        $dumpvars(0, tb_jkff);

        // Print header and monitor signal changes
        $display("Time | rst | clk | j | k | q | qbar");
        $display("-----------------------------------");
        $monitor("%4t |  %b  |  %b  | %b | %b | %b |  %b", 
                 $time, rst, clk, j, k, q, qbar);

        // Initialize inputs
        clk = 0;
        j = 0;
        k = 0;
        
        // 1. Apply Reset
        rst = 1; #10;
        rst = 0; 
        
        // 2. Test Set Condition (j=1, k=0)
        j = 1; k = 0; #10;
        
        // 3. Test Hold Condition (j=0, k=0) -> q should stay 1
        j = 0; k = 0; #10;
        
        // 4. Test Reset Condition (j=0, k=1) -> q should become 0
        j = 0; k = 1; #10;
        
        // 5. Test Toggle Condition (j=1, k=1) -> q should flip 0 to 1
        j = 1; k = 1; #10;
        
        // 6. Test Toggle Condition again -> q should flip 1 to 0
        #10;

        // End simulation
        $finish;
    end

endmodule
    