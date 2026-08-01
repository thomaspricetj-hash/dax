module top (
    input  wire clk,
    input  wire rst,

    // AXI-Lite interface from PCIe/host
    input  wire [31:0] S_AXI_AWADDR,
    input  wire        S_AXI_AWVALID,
    output wire        S_AXI_AWREADY,

    input  wire [31:0] S_AXI_WDATA,
    input  wire [3:0]  S_AXI_WSTRB,
    input  wire        S_AXI_WVALID,
    output wire        S_AXI_WREADY,

    output wire [1:0]  S_AXI_BRESP,
    output wire        S_AXI_BVALID,
    input  wire        S_AXI_BREADY,

    input  wire [31:0] S_AXI_ARADDR,
    input  wire        S_AXI_ARVALID,
    output wire        S_AXI_ARREADY,

    output wire [31:0] S_AXI_RDATA,
    output wire [1:0]  S_AXI_RRESP,
    output wire        S_AXI_RVALID,
    input  wire        S_AXI_RREADY
);

    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 64;

    // Control signals driven by AXI-Lite
    wire                   ldx_en;
    wire                   stx_en;
    wire [ADDR_WIDTH-1:0]  addrM;
    wire [ADDR_WIDTH-1:0]  addrD;
    wire [DATA_WIDTH-1:0]  new_value;
    wire                   dax_en;

    // MEU <-> memories
    wire [ADDR_WIDTH-1:0]  m_addr;
    wire [DATA_WIDTH-1:0]  m_data;
    wire [ADDR_WIDTH-1:0]  d_addr;
    wire [DATA_WIDTH-1:0]  d_data;
    wire [DATA_WIDTH-1:0]  d_wdata;
    wire                   d_we;
    wire [DATA_WIDTH-1:0]  v_out;

    // AXI-Lite DAX control block
    axi_lite_dax_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(32)
    ) u_dax_ctrl (
        .ACLK(clk),
        .ARESETN(~rst),

        .S_AXI_AWADDR(S_AXI_AWADDR),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_AWREADY(S_AXI_AWREADY),

        .S_AXI_WDATA(S_AXI_WDATA),
        .S_AXI_WSTRB(S_AXI_WSTRB),
        .S_AXI_WVALID(S_AXI_WVALID),
        .S_AXI_WREADY(S_AXI_WREADY),

        .S_AXI_BRESP(S_AXI_BRESP),
        .S_AXI_BVALID(S_AXI_BVALID),
        .S_AXI_BREADY(S_AXI_BREADY),

        .S_AXI_ARADDR(S_AXI_ARADDR),
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .S_AXI_ARREADY(S_AXI_ARREADY),

        .S_AXI_RDATA(S_AXI_RDATA),
        .S_AXI_RRESP(S_AXI_RRESP),
        .S_AXI_RVALID(S_AXI_RVALID),
        .S_AXI_RREADY(S_AXI_RREADY),

        // Outputs to MEU
        .ldx_en(ldx_en),
        .stx_en(stx_en),
        .addrM(addrM),
        .addrD(addrD),
        .new_value(new_value),
        .dax_en(dax_en)
    );

    // Instantiate master memory
    memory_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_master (
        .clk   (clk),
        .addr  (m_addr),
        .rdata (m_data)
    );

    // Instantiate delta memory
    memory_delta #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_delta (
        .clk   (clk),
        .addr  (d_addr),
        .wdata (d_wdata),
        .we    (d_we),
        .rdata (d_data)
    );

    // Instantiate DAX MEU
    dax_meu #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_meu (
        .clk      (clk),
        .rst      (rst),
        .ldx_en   (ldx_en),
        .stx_en   (stx_en),
        .addrM    (addrM),
        .addrD    (addrD),
        .new_value(new_value),
        .m_addr   (m_addr),
        .m_data   (m_data),
        .d_addr   (d_addr),
        .d_data   (d_data),
        .d_wdata  (d_wdata),
        .d_we     (d_we),
        .v_out    (v_out)
    );

endmodule

