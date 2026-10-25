// Pipelined wrappers for the bitmap ROMs.
//
// Stage 1 looks up the low LO address bits in every 2**LO-entry slice of
// the ROM and registers each slice's output.  Stage 2 (combinational here,
// registered by the caller) picks the slice addressed by the high bits.
//
// addr_lo_lead must be the low bits of the address one clock early, i.e. the
// value addr_hi's address will have on the next clock, so that `out` for the
// current address is available in the same cycle as the unpipelined ROM.

module galton_rom_pipe #(
    parameter LO = 8
) (
    input  wire              clk,
    input  wire [LO-1:0]     addr_lo_lead,
    input  wire [12-LO:0]    addr_hi,
    output wire [1:0]        out
);
    localparam N = 1 << (13 - LO);

    reg  [2*N-1:0] slice_r;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : g_slice
            localparam [12-LO:0] HI = i;
            wire [1:0] slice;

            galton_rom rom (
                .addr ( {HI, addr_lo_lead} ),
                .out  ( slice              )
            );

            always @(posedge clk)
                slice_r[2*i +: 2] <= slice;
        end
    endgenerate

    assign out = slice_r[2*addr_hi +: 2];
endmodule

module name_rom_pipe #(
    parameter LO = 8
) (
    input  wire              clk,
    input  wire [LO-1:0]     addr_lo_lead,
    input  wire [11-LO:0]    addr_hi,
    output wire              out
);
    localparam N = 1 << (12 - LO);

    reg  [N-1:0] slice_r;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : g_slice
            localparam [11-LO:0] HI = i;
            wire slice;

            name_rom rom (
                .addr ( {HI, addr_lo_lead} ),
                .out  ( slice              )
            );

            always @(posedge clk)
                slice_r[i] <= slice;
        end
    endgenerate

    assign out = slice_r[addr_hi];
endmodule
