module  RegDst_(
    input wire [1:0] RegDstControl,
    input wire [31:0] ConstVinte_nove,
    input wire [20:16] RT,
    input wire [31:0] ConstTrinta_um,
    input wire [15:0] OFFSET,
    output reg [31:0] RegDst_out
);
    


    always @(*)begin
        case(RegDstControl)
            2'b00 : RegDst_out = ConstVinte_nove;
            2'b01 : RegDst_out = RT;
            2'b01 : RegDst_out = ConstTrinta_um;
            2'b11 : RegDst_out = OFFSET[15:11];
        endcase
    end
