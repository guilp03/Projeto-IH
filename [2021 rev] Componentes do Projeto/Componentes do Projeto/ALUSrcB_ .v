module ALUSrcB_ (
	input wire ALUSrcBControl, 
	input wire [31:0] SE16_32_out, 
	input wire [31:0] ConstQuatro, 
	input wire [31:0] RegB_out,
	input wire [31:0] SL2_out, 
	output reg [31:0] ALUSrcB_out /* saida */
);
always @(SE16_32_out or ConstQuatro or RegB_out or SL2_out ) begin
        case(ALUSrcBControl)
            2'b00 : ALUSrcB_out  = SE16_32_out ;
            2'b01 :  ALUSrcB_out = ConstQuatro ; 
            2'b10 :  ALUSrcB_out = RegB_out;
            2'b11 :  ALUSrcB_out = SL2_out ;
        endcase
 end
endmodule
