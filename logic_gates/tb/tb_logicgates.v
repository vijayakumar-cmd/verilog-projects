`timescale 1ns/1ps

module tb_logic_gates;
    reg a, b;
    wire out_and, out_or, out_not, out_nand, out_nor, out_xor, out_xnor;

    // Instantiate the Unit Under Test (UUT)
    logic_gates uut (
        .a(a), .b(b),
        .out_and(out_and), .out_or(out_or), .out_not(out_not),
        .out_nand(out_nand), .out_nor(out_nor),
        .out_xor(out_xor), .out_xnor(out_xnor)
    );

    initial begin
        // Setup waveform dumping for GTKWave / ModelSim
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_logic_gates);

        // Console output tracking
        $monitor("Time=%0t ns | A=%b B=%b | AND=%b OR=%b NOT=%b NAND=%b NOR=%b XOR=%b XNOR=%b",
                 $time, a, b, out_and, out_or, out_not, out_nand, out_nor, out_xor, out_xnor);

        // Extended timing stimulus (50 ns per state)
        a = 0; b = 0; #50;  // 0 ns to 50 ns
        a = 0; b = 1; #50;  // 50 ns to 100 ns
        a = 1; b = 0; #50;  // 100 ns to 150 ns
        a = 1; b = 1; #50;  // 150 ns to 200 ns

        // Hold final state for an extra 20 ns before finishing
        #20;               // Total simulation run: 220 ns
        $finish;
    end
endmodule
    