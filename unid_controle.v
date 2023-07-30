module control(
    input wire clock,
    input wire reset
// Flags
    input wire Overflow;
    input wire Neg;
    input wire Zero;
    input wire EQ;
    input wire GT;
    input wire LT;

// Control wires
   output wire WriteMemControl;
   output wire IRWriteControl;
   output wire [2:0] ShiftRegControl;
   output wire RegWriteControl;
   output wire [2:0] ALUControl;
   output wire PcControl;
   output wire HI_writeControl;
   output wire LO_writeControl;
   output wire RegAControl;
   output wire RegBControl;
   output wire ALUOutControl;
   output wire WriteMDRControl;
   output wire EpcControl;
   output wire EX_control;
   output wire [1:0] PcSourceControl;
   output wire [2:0] IorDControl;
   output wire [1:0] RegDstControl;
   output wire [1:0] ShiftAmtControl;
   output wire [1:0] ShiftSrcControl;
   output wire [2:0] DataSrcControl;
   output wire [1:0] ALUSrcAControl;
   output wire [2:0] ALUSrcBControl;
   output wire [1:0] SSControl;
   output wire [1:0] LScontrol;
   output wire reset_out
);

reg [5:0] state;
reg [5:0] counter;

always @(posedge clk) begin
    
end

endmodule