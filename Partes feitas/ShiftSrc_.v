module ShiftSrc_(
    input wire [1:0] ShiftSrcControl,
    input wire [31:0] RegB_out,
    input wire [31:0] RegA_out, 
    input wire [31:0] SL16_32_out,
    output reg [31:0]  ShiftSrc_out
);

always @(*) begin
    case ( ShiftSrcControl)          
        2'b00:  ShiftSrc_out = RegB_out; //rt
        2'b01:  ShiftSrc_out = RegA_out; //rs 
        2'b10:  ShiftSrc_out = SL16_32_out; 
        endcase 
end

endmodule
