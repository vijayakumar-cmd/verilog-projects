`timescale 1ns/1ps

module cpu_tb;
  reg clk = 0;
  reg rst = 1;

  cpu dut (.clk(clk), .rst(rst));

  always #5 clk = ~clk;          // 10 ns period

  integer i;
  integer errors = 0;

  // compare helper
  task check(input [127:0] name, input [15:0] got, input [15:0] exp);
    begin
      if (got === exp)
        $display("PASS  %0s = %0d", name, got);
      else begin
        $display("FAIL  %0s: got %0d, expected %0d", name, got, exp);
        errors = errors + 1;
      end
    end
  endtask

  // trace: shows the state before each clock edge (the instruction about to execute)
  always @(posedge clk)
    if (!rst)
      $display("t=%0t  pc=%0d  instr=%h  R1=%0d R2=%0d R3=%0d R4=%0d",
               $time, dut.pc, dut.instr,
               dut.rf[1], dut.rf[2], dut.rf[3], dut.rf[4]);

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_tb);

    // clear memories and registers
    for (i = 0; i < 64; i = i + 1) begin
      dut.imem[i] = 16'h0000;    // 0x0000 = ADD R0,R0,R0 (harmless no-op)
      dut.dmem[i] = 16'h0000;
    end
    for (i = 0; i < 8; i = i + 1) dut.rf[i] = 16'h0000;

    // load program
    dut.imem[0] = 16'h4205;   // ADDI R1,R0,5
    dut.imem[1] = 16'h4403;   // ADDI R2,R0,3
    dut.imem[2] = 16'h0650;   // ADD  R3,R1,R2
    dut.imem[3] = 16'h6600;   // SW   R3,0(R0)
    dut.imem[4] = 16'h5800;   // LW   R4,0(R0)
    dut.imem[5] = 16'h773F;   // BEQ  R3,R4,-1  (branches to itself = halt)

    // reset for 2 clocks, release on the falling edge to avoid races
    repeat (2) @(posedge clk);
    @(negedge clk) rst = 0;

    // run long enough for 6 instructions plus a few halt cycles
    repeat (12) @(posedge clk);
    #1;

    // self-check against the hand trace
    $display("---- checking results ----");
    check("PC",     dut.pc,      16'd5);
    check("R0",     dut.rf[0],   16'd0);
    check("R1",     dut.rf[1],   16'd5);
    check("R2",     dut.rf[2],   16'd3);
    check("R3",     dut.rf[3],   16'd8);
    check("R4",     dut.rf[4],   16'd8);
    check("mem[0]", dut.dmem[0], 16'd8);

    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);

    $finish;
  end
endmodule