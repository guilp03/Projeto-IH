module  RegDst_(
    input wire [1:0] RegDstControl,
    input wire [31:0] ConstVinte_nove,
    input wire [20:16] RT,
    input wire [31:0] ConstTrinta_um,
    input wire [15:0] OFFSET,
    output reg [4:0] RegDst_out
);

    always @(RegDstControl or ConstVinte_nove or RT or ConstTrinta_um or OFFSET)begin
        case(RegDstControl)
            2'b00 : RegDst_out = ConstVinte_nove;
            2'b01 : RegDst_out = RT;
            2'b10 : RegDst_out = ConstTrinta_um;
            2'b11 : RegDst_out = OFFSET[15:11];
        endcase
    end
endmodule