module DataSrc_(
    input wire [2:0] DataSrcControl
    input wire [31:0] LS_out,   
    input wire [31:0] HI_out,   
    input wire [31:0] LO_out, 
    input wire [31:0] ShiftReg_out, 
    input wire [31:0] ConstDuzentos_vinte_sete,
    input wire [31:0] SE1_32_out, 
    input wire [31:0] ALUOut_out, 
    output reg [31:0] DataSrc_out  
);
  
	always @(LS_out or HI_out or LO_out or ShiftReg_out or ConstDuzentos_vinte_sete or SE1_32_out or ALUOut_out) begin
    case (inputControl)          
        3'b000: DataSrc_out   = LS_out; 
        3'b001: DataSrc_out  = HI_out; 
        3'b010: DataSrc_out  = LO_out; 
	3'b011: DataSrc_out  = ShiftReg_out;
	3'b100: DataSrc_out  = ConstDuzentos_vinte_sete;
	3'b101: DataSrc_out  = SE1_32_out;
	3'b110: DataSrc_out  = ALUOut_out_out;
        endcase
end

endmodule
