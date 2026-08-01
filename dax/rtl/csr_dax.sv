module csr_dax #(
    parameter DATA_WIDTH = 32
)(
    input  wire              clk,
    input  wire              rst,

    // Simple CSR write interface
    input  wire              csr_we,
    input  wire [3:0]        csr_addr,
    input  wire [DATA_WIDTH-1:0] csr_wdata,

    // Outputs
    output reg               dax_en,
    output reg [DATA_WIDTH-1:0] dax_stats_ldx,
    output reg [DATA_WIDTH-1:0] dax_stats_stx
);

    always @(posedge clk) begin
        if (rst) begin
            dax_en        <= 1'b0;
            dax_stats_ldx <= {DATA_WIDTH{1'b0}};
            dax_stats_stx <= {DATA_WIDTH{1'b0}};
        end else begin
            if (csr_we) begin
                case (csr_addr)
                    4'h0: dax_en        <= csr_wdata[0];
                    4'h1: dax_stats_ldx <= csr_wdata;
                    4'h2: dax_stats_stx <= csr_wdata;
                    default: ;
                endcase
            end
        end
    end

    // Stats increment logic driven externally
endmodule
