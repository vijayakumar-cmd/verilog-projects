// Single-cycle RISC-V core (RV32I subset)
// Supports: add sub and or xor slt | addi andi ori xori slti | lw sw | beq bne | jal | lui
module riscv_core(
  input         clk,
  input         rst,
  output reg [31:0] pc,
  input  [31:0] instr,
  output [31:0] daddr,
  output [31:0] dwdata,
  output        dwe,
  input  [31:0] drdata
);
  localparam OP_R   = 7'b0110011;
  localparam OP_I   = 7'b0010011;
  localparam OP_LW  = 7'b0000011;
  localparam OP_SW  = 7'b0100011;
  localparam OP_B   = 7'b1100011;
  localparam OP_JAL = 7'b1101111;
  localparam OP_LUI = 7'b0110111;

  reg [31:0] regs [0:31];

  // ---- decode ----
  wire [6:0] opcode = instr[6:0];
  wire [4:0] rd     = instr[11:7];
  wire [2:0] f3     = instr[14:12];
  wire [4:0] rs1    = instr[19:15];
  wire [4:0] rs2    = instr[24:20];
  wire       f7b5   = instr[30];

  wire is_r   = (opcode == OP_R);
  wire is_i   = (opcode == OP_I);
  wire is_lw  = (opcode == OP_LW);
  wire is_sw  = (opcode == OP_SW);
  wire is_b   = (opcode == OP_B);
  wire is_jal = (opcode == OP_JAL);
  wire is_lui = (opcode == OP_LUI);

  wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
  wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
  wire [31:0] imm_b = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
  wire [31:0] imm_j = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
  wire [31:0] imm_u = {instr[31:12], 12'b0};

  // ---- register read (x0 is always 0) ----
  wire [31:0] rv1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
  wire [31:0] rv2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

  // ---- ALU ----
  wire [31:0] opb = is_r ? rv2 : imm_i;
  reg  [31:0] alu;
  always @(*) begin
    case (f3)
      3'b000:  alu = (is_r && f7b5) ? (rv1 - opb) : (rv1 + opb);
      3'b010:  alu = ($signed(rv1) < $signed(opb)) ? 32'd1 : 32'd0;
      3'b100:  alu = rv1 ^ opb;
      3'b110:  alu = rv1 | opb;
      3'b111:  alu = rv1 & opb;
      default: alu = 32'd0;
    endcase
  end

  // ---- data memory interface ----
  assign daddr  = rv1 + (is_sw ? imm_s : imm_i);
  assign dwdata = rv2;
  assign dwe    = is_sw & ~rst;

  // ---- next PC ----
  wire eq   = (rv1 == rv2);
  wire take = is_b & (((f3 == 3'b000) & eq) | ((f3 == 3'b001) & ~eq));
  wire [31:0] next_pc = is_jal ? (pc + imm_j) :
                        take   ? (pc + imm_b) : (pc + 32'd4);

  // ---- write back ----
  wire wen = (is_r | is_i | is_lw | is_jal | is_lui) & (rd != 5'd0);
  wire [31:0] wdata = is_lw  ? drdata :
                      is_jal ? (pc + 32'd4) :
                      is_lui ? imm_u : alu;

  always @(posedge clk) begin
    if (rst) pc <= 32'd0;
    else begin
      pc <= next_pc;
      if (wen) regs[rd] <= wdata;
    end
  end
endmodule