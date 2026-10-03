module tb_srflipflop;

    // Testbench signals
    logic s;
    logic r;
    logic clk;
    logic rst;
    logic q;
    logic qbar;

    // Instantiate the Unit Under Test (UUT)
    srflipflop uut (
        .s(s),
        .r(r),
        .clk(clk),
        .rst(rst),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation (Period = 10 time units)
    always #5 clk = ~clk;

    initial begin
        // Generate waveform file for your app
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_srflipflop);

        // Print header and monitor signal changes
        $display("Time | rst | clk | s | r | q | qbar");
        $display("-----------------------------------");
        $monitor("%4t |  %b  |  %b  | %b | %b | %b |  %b", 
                 $time, rst, clk, s, r, q, qbar);

        // Initialize signals
        clk = 0;
        s = 0;
        r = 0;
        
        // 1. Apply Reset
        rst = 1; #10;
        rst = 0; 
        
        // 2. Test Set Condition
        s = 1; r = 0; #10;
        
        // 3. Test Hold Condition (should stay 1)
        s = 0; r = 0; #10;
        
        // 4. Test Reset Condition
        s = 0; r = 1; #10;
        
        // 5. Test Hold Condition (should stay 0)
        s = 0; r = 0; #10;
        
        // 6. Test Invalid State
        s = 1; r = 1; #10;

        // End simulation
        $finish;
    end

endmodule
    