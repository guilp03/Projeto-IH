module ShiftAmt_(
    input wire [1:0] ShiftAmtControl,
    input wire [15:0] OFFSET,
    input wire [31:0] ConstDezesseis, 
    input wire [31:0] RegB_out,
    output reg [4:0] ShiftAmt_out
);

always @(OFFSET or ConstDezesseis or RegB_out ) begin
    case ( ShiftAmtControl)          
        2'b00: ShiftAmt_out = OFFSET[10:6]; 
        2'b01: ShiftAmt_out = ConstDezesseis; 
        2'b10: ShiftAmt_out = RegB_out; 
    endcase
end

endmodule
