module cpu (input clk, input rst);
  reg [15:0] pc;
  reg [15:0] imem [0:63];
  reg [15:0] dmem [0:63];
  reg [15:0] rf   [0:7];

  wire [15:0] instr = imem[pc[5:0]];
  wire [3:0]  op  = instr[15:12];
  wire [2:0]  rd  = instr[11:9];
  wire [2:0]  rs1 = instr[8:6];
  wire [2:0]  rs2 = instr[5:3];
  wire [15:0] imm = {{10{instr[5]}}, instr[5:0]};

  // control (your Step 3 table)
  reg we, use_imm, mem_we, mem_to_reg, branch, rd_src;
  reg [1:0] alu_op;
  always @* begin
    we=0; use_imm=0; mem_we=0; mem_to_reg=0;
    branch=0; rd_src=0; alu_op=2'b00;
    case (op)
      4'h0: begin we=1; alu_op=2'b00; end
      4'h1: begin we=1; alu_op=2'b01; end
      4'h2: begin we=1; alu_op=2'b10; end
      4'h3: begin we=1; alu_op=2'b11; end
      4'h4: begin we=1; use_imm=1; end
      4'h5: begin we=1; use_imm=1; mem_to_reg=1; end
      4'h6: begin mem_we=1; use_imm=1; rd_src=1; end
      4'h7: begin branch=1; rd_src=1; end
    endcase
  end

  // datapath
  wire [2:0]  ra2 = rd_src ? rd : rs2;
  wire [15:0] a   = (rs1 == 0) ? 16'd0 : rf[rs1];
  wire [15:0] b   = (ra2 == 0) ? 16'd0 : rf[ra2];
  wire [15:0] opb = use_imm ? imm : b;

  reg [15:0] alu_out;
  always @* case (alu_op)
    2'b00: alu_out = a + opb;
    2'b01: alu_out = a - opb;
    2'b10: alu_out = a & opb;
    2'b11: alu_out = a | opb;
  endcase

  wire [15:0] wb    = mem_to_reg ? dmem[alu_out[5:0]] : alu_out;
  wire        taken = branch & (a == b);

  always @(posedge clk) begin
    if (rst) pc <= 16'd0;
    else begin
      pc <= taken ? pc + 16'd1 + imm : pc + 16'd1;
      if (we && rd != 0) rf[rd] <= wb;
      if (mem_we)        dmem[alu_out[5:0]] <= b;
    end
  end
endmodule