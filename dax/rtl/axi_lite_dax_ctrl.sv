module axi_lite_dax_ctrl #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  ACLK,
    input  wire                  ARESETN,

    // AXI-Lite slave interface
    input  wire [ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  wire                  S_AXI_AWVALID,
    output reg                   S_AXI_AWREADY,

    input  wire [DATA_WIDTH-1:0] S_AXI_WDATA,
    input  wire [3:0]            S_AXI_WSTRB,
    input  wire                  S_AXI_WVALID,
    output reg                   S_AXI_WREADY,

    output reg [1:0]             S_AXI_BRESP,
    output reg                   S_AXI_BVALID,
    input  wire                  S_AXI_BREADY,

    input  wire [ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  wire                  S_AXI_ARVALID,
    output reg                   S_AXI_ARREADY,

    output reg [DATA_WIDTH-1:0]  S_AXI_RDATA,
    output reg [1:0]             S_AXI_RRESP,
    output reg                   S_AXI_RVALID,
    input  wire                  S_AXI_RREADY,

    // DAX control outputs
    output reg                   ldx_en,
    output reg                   stx_en,
    output reg [ADDR_WIDTH-1:0]  addrM,
    output reg [ADDR_WIDTH-1:0]  addrD,
    output reg [63:0]            new_value,
    output reg                   dax_en
);

    // Register map (word addresses):
    // 0x00: DAX_EN
    // 0x04: LDX_EN (pulse)
    // 0x08: STX_EN (pulse)
    // 0x0C: ADDR_M
    // 0x10: ADDR_D
    // 0x14: NEW_VALUE_LO
    // 0x18: NEW_VALUE_HI

    reg [DATA_WIDTH-1:0] reg_dax_en;
    reg [DATA_WIDTH-1:0] reg_ldx_en;
    reg [DATA_WIDTH-1:0] reg_stx_en;
    reg [ADDR_WIDTH-1:0] reg_addrM;
    reg [ADDR_WIDTH-1:0] reg_addrD;
    reg [31:0]           reg_new_lo;
    reg [31:0]           reg_new_hi;

    reg aw_hs, w_hs;
    wire write_hs = aw_hs & w_hs;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_AWREADY <= 1'b0;
            S_AXI_WREADY  <= 1'b0;
            S_AXI_BVALID  <= 1'b0;
            S_AXI_BRESP   <= 2'b00;
            aw_hs         <= 1'b0;
            w_hs          <= 1'b0;

            reg_dax_en    <= 0;
            reg_ldx_en    <= 0;
            reg_stx_en    <= 0;
            reg_addrM     <= 0;
            reg_addrD     <= 0;
            reg_new_lo    <= 0;
            reg_new_hi    <= 0;

            ldx_en        <= 1'b0;
            stx_en        <= 1'b0;
            addrM         <= 0;
            addrD         <= 0;
            new_value     <= 0;
            dax_en        <= 1'b0;
        end else begin
            if (!S_AXI_AWREADY && S_AXI_AWVALID)
                S_AXI_AWREADY <= 1'b1;
            else
                S_AXI_AWREADY <= 1'b0;

            if (!S_AXI_WREADY && S_AXI_WVALID)
                S_AXI_WREADY <= 1'b1;
            else
                S_AXI_WREADY <= 1'b0;

            aw_hs <= S_AXI_AWREADY & S_AXI_AWVALID;
            w_hs  <= S_AXI_WREADY  & S_AXI_WVALID;

            if (write_hs) begin
                case (S_AXI_AWADDR[5:2])
                    4'h0: reg_dax_en <= S_AXI_WDATA;
                    4'h1: reg_ldx_en <= S_AXI_WDATA;
                    4'h2: reg_stx_en <= S_AXI_WDATA;
                    4'h3: reg_addrM  <= S_AXI_WDATA;
                    4'h4: reg_addrD  <= S_AXI_WDATA;
                    4'h5: reg_new_lo <= S_AXI_WDATA;
                    4'h6: reg_new_hi <= S_AXI_WDATA;
                    default: ;
                endcase

                S_AXI_BVALID <= 1'b1;
                S_AXI_BRESP  <= 2'b00;
            end else if (S_AXI_BVALID && S_AXI_BREADY) begin
                S_AXI_BVALID <= 1'b0;
            end

            dax_en    <= reg_dax_en[0];
            addrM     <= reg_addrM;
            addrD     <= reg_addrD;
            new_value <= {reg_new_hi, reg_new_lo};

            ldx_en <= (write_hs && S_AXI_AWADDR[5:2] == 4'h1);
            stx_en <= (write_hs && S_AXI_AWADDR[5:2] == 4'h2);
        end
    end

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            S_AXI_ARREADY <= 1'b0;
            S_AXI_RVALID  <= 1'b0;
            S_AXI_RRESP   <= 2'b00;
            S_AXI_RDATA   <= 0;
        end else begin
            if (!S_AXI_ARREADY && S_AXI_ARVALID)
                S_AXI_ARREADY <= 1'b1;
            else
                S_AXI_ARREADY <= 1'b0;

            if (S_AXI_ARREADY && S_AXI_ARVALID) begin
                case (S_AXI_ARADDR[5:2])
                    4'h0: S_AXI_RDATA <= reg_dax_en;
                    4'h1: S_AXI_RDATA <= reg_ldx_en;
                    4'h2: S_AXI_RDATA <= reg_stx_en;
                    4'h3: S_AXI_RDATA <= reg_addrM[31:0];
                    4'h4: S_AXI_RDATA <= reg_addrD[31:0];
                    4'h5: S_AXI_RDATA <= reg_new_lo;
                    4'h6: S_AXI_RDATA <= reg_new_hi;
                    default: S_AXI_RDATA <= 0;
                endcase
                S_AXI_RVALID <= 1'b1;
                S_AXI_RRESP  <= 2'b00;
            end else if (S_AXI_RVALID && S_AXI_RREADY) begin
                S_AXI_RVALID <= 1'b0;
            end
        end
    end

endmodule
