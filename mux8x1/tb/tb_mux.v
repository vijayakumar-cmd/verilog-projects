`timescale 1ns/1ps

module tb_mux8x1;
    reg  [7:0] I;
    reg  [2:0] S;
    wire       Y;

    reg        expected;
    integer    i, s, errors;

    // Device under test
    mux8x1 dut (
        .I(I),
        .S(S),
        .Y(Y)
    );

    initial begin
        $dumpfile("mux8x1.vcd");
        $dumpvars(0, tb_mux8x1);
        errors = 0;

        // Exhaustive test: every data pattern with every select value
        for (i = 0; i < 256; i = i + 1) begin
            for (s = 0; s < 8; s = s + 1) begin
                I = i[7:0];
                S = s[2:0];
                #5;                  // let combinational logic settle
                expected = I[S];     // the selected input bit

                if (Y !== expected) begin
                    errors = errors + 1;
                    $display("FAIL: I=%b S=%b -> Y=%b (expected %b)",
                             I, S, Y, expected);
                end
            end
        end

        if (errors == 0)
            $display("PASS: all 2048 combinations correct.");
        else
            $display("DONE: %0d errors.", errors);

        $finish;
    end
endmodule