module logic_gates_tb;
  reg a, b;
  wire y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor;

  // Instantiate the Unit Under Test (UUT)
  logic_gates uut (
    .a(a), .b(b),
    .y_and(y_and), .y_or(y_or), .y_not(y_not),
    .y_nand(y_nand), .y_nor(y_nor),
    .y_xor(y_xor), .y_xnor(y_xnor)
  );

  // Stimulus
  initial begin
    $dumpfile("logic_gates.vcd");
    $dumpvars(0, logic_gates_tb);

    a = 0; b = 0;
    #10 a = 0; b = 1;
    #10 a = 1; b = 0;
    #10 a = 1; b = 1;
    #10 $finish;
  end

  // Monitor (string kept on one line)
  initial begin
    $monitor("Time=%0t | a=%b b=%b || AND=%b OR=%b NOT=%b NAND=%b NOR=%b XOR=%b XNOR=%b",
             $time, a, b, y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor);
  end
endmodule