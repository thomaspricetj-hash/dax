module dax_meu #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64
)(
    input  wire                   clk,
    input  wire                   rst,

    // Control
    input  wire                   ldx_en,
    input  wire                   stx_en,

    input  wire [ADDR_WIDTH-1:0]  addrM,
    input  wire [ADDR_WIDTH-1:0]  addrD,
    input  wire [DATA_WIDTH-1:0]  new_value,

    // Master memory interface (read-only)
    output reg  [ADDR_WIDTH-1:0]  m_addr,
    input  wire [DATA_WIDTH-1:0]  m_data,

    // Delta memory interface (read/write)
    output reg  [ADDR_WIDTH-1:0]  d_addr,
    input  wire [DATA_WIDTH-1:0]  d_data,
    output reg  [DATA_WIDTH-1:0]  d_wdata,
    output reg                    d_we,

    // Effective value out
    output reg  [DATA_WIDTH-1:0]  v_out
);

    reg [DATA_WIDTH-1:0] M;
    reg [DATA_WIDTH-1:0] D;

    always @(posedge clk) begin
        if (rst) begin
            m_addr  <= {ADDR_WIDTH{1'b0}};
            d_addr  <= {ADDR_WIDTH{1'b0}};
            d_wdata <= {DATA_WIDTH{1'b0}};
            d_we    <= 1'b0;
            v_out   <= {DATA_WIDTH{1'b0}};
        end else begin
            // Issue reads
            m_addr <= addrM;
            d_addr <= addrD;

            // Capture data
            M <= m_data;
            D <= d_data;

            // LDX: V = M XOR D
            if (ldx_en) begin
                v_out <= M ^ D;
                d_we  <= 1'b0;
            end

            // STX: D' = M XOR new_value
            if (stx_en) begin
                d_wdata <= M ^ new_value;
                d_we    <= 1'b1;
            end
        end
    end

endmodule
