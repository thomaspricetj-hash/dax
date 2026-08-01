module memory_master #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter DEPTH      = 1024
)(
    input  wire                   clk,
    input  wire [ADDR_WIDTH-1:0]  addr,
    output reg  [DATA_WIDTH-1:0]  rdata
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Simple init for simulation; replace with real preload for FPGA
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
        mem[0] = 64'hDEADBEEFCAFEBABE;
        mem[1] = 64'h0123456789ABCDEF;
    end

    always @(posedge clk) begin
        rdata <= mem[addr[ADDR_WIDTH-1:0] % DEPTH];
    end

endmodule
