module memory_delta #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter DEPTH      = 1024
)(
    input  wire                   clk,
    input  wire [ADDR_WIDTH-1:0]  addr,
    input  wire [DATA_WIDTH-1:0]  wdata,
    input  wire                   we,
    output reg  [DATA_WIDTH-1:0]  rdata
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    always @(posedge clk) begin
        if (we) begin
            mem[addr[ADDR_WIDTH-1:0] % DEPTH] <= wdata;
        end
        rdata <= mem[addr[ADDR_WIDTH-1:0] % DEPTH];
    end

endmodule
