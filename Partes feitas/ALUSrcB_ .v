module ALUSrcB_(
	input wire [1:0] ALUSrcBControl, 
	input wire [31:0] sign_extended16_32_out, 
	input wire [31:0] ConstQuatro, 
	input wire [31:0] RegB_out,
	input wire [31:0] shift_left_2x_out,
	output reg [31:0] ALUSrcB_out /* saida */
);
always @(*) begin
        case(ALUSrcBControl)
            2'b00 : ALUSrcB_out  = sign_extended16_32_out ;
            2'b01 :  ALUSrcB_out = ConstQuatro ; 
            2'b10 :  ALUSrcB_out = RegB_out;
            2'b11 :  ALUSrcB_out = shift_left_2x_out;
        endcase
 end
endmodule
