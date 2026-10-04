// Small system for simulation: core + instruction memory + data memory
module riscv_soc(input clk, input rst);
  reg [31:0] imem [0:63];
  reg [31:0] dmem [0:63];
  wire [31:0] pc, instr, daddr, dwdata, drdata;
  wire        dwe;

  assign instr  = imem[pc[7:2]];
  assign drdata = dmem[daddr[7:2]];

  riscv_core core(
    .clk(clk), .rst(rst),
    .pc(pc), .instr(instr),
    .daddr(daddr), .dwdata(dwdata), .dwe(dwe), .drdata(drdata)
  );

  always @(posedge clk)
    if (dwe) dmem[daddr[7:2]] <= dwdata;
endmodule