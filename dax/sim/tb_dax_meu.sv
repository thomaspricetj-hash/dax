`timescale 1ns/1ps

module tb_dax_meu;

    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 64;

    reg clk = 0;
    reg rst = 1;

    // Wires to top
    top u_top (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting DAX MEU testbench...");
        #50 rst = 0;

        // Run for some cycles
        #500;

        $display("Simulation done.");
        $finish;
    end

endmodule
