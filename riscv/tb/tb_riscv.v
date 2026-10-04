`timescale 1ns/1ps
module tb_riscv;
  reg clk = 0, rst = 1;
  riscv_soc dut(.clk(clk), .rst(rst));
  always #5 clk = ~clk;

  integer errors;

  task check(input [31:0] got, input [31:0] expv, input [127:0] name);
    begin
      if (got !== expv) begin
        $display("FAIL %0s: got %0d expected %0d", name, got, expv);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_riscv);

    // program (machine code)
    dut.imem[0]  = 32'h00000513; // addi x10, x0, 0
    dut.imem[1]  = 32'h00500093; // addi x1,  x0, 5
    dut.imem[2]  = 32'h00700113; // addi x2,  x0, 7
    dut.imem[3]  = 32'h002081b3; // add  x3,  x1, x2   -> 12
    dut.imem[4]  = 32'h40110233; // sub  x4,  x2, x1   -> 2
    dut.imem[5]  = 32'h00302023; // sw   x3, 0(x0)
    dut.imem[6]  = 32'h00002283; // lw   x5, 0(x0)     -> 12
    dut.imem[7]  = 32'h00300313; // addi x6,  x0, 3
    dut.imem[8]  = 32'hfff30313; // loop: addi x6, x6, -1
    dut.imem[9]  = 32'hfe031ee3; // bne  x6, x0, loop
    dut.imem[10] = 32'h0020f3b3; // and  x7,  x1, x2   -> 5
    dut.imem[11] = 32'h0020e433; // or   x8,  x1, x2   -> 7
    dut.imem[12] = 32'h0020a4b3; // slt  x9,  x1, x2   -> 1
    dut.imem[13] = 32'h00000463; // beq  x0, x0, +8 (skips next line)
    dut.imem[14] = 32'h06300513; // addi x10, x0, 99   (must be skipped)
    dut.imem[15] = 32'h00100593; // addi x11, x0, 1
    dut.imem[16] = 32'h0000006f; // jal  x0, 0 (stop here)

    #22 rst = 0;
    #600;

    check(dut.core.regs[3],  32'd12, "add");
    check(dut.core.regs[4],  32'd2,  "sub");
    check(dut.core.regs[5],  32'd12, "lw/sw");
    check(dut.core.regs[6],  32'd0,  "loop");
    check(dut.core.regs[7],  32'd5,  "and");
    check(dut.core.regs[8],  32'd7,  "or");
    check(dut.core.regs[9],  32'd1,  "slt");
    check(dut.core.regs[10], 32'd0,  "beq skip");
    check(dut.core.regs[11], 32'd1,  "beq target");

    if (errors == 0) $display("PASS: RISC-V core ran the program");
    else $display("FAIL: %0d errors", errors);
    $finish;
  end
endmodule