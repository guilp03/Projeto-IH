module PcSource_   (
	input wire [1:0]PcSourceControl,
	input wire [31:0] ALUresult, /* jump */
	input wire [31:0] conc_SL26_PC_out, /* branch */
	input wire [31:0] ALUOut_out, /* PC+4 */
	input wire [31:0]  EPC_out, /* EPC */ 
	output reg [31:0] PCSource_out
);
always @(*) begin
    case (PcSourceControl)          
        2'b00: PCSource_out = ALUresult; 
        2'b01: PCSource_out = conc_SL26_PC_out; 
        2'b10: PCSource_out = ALUOut_out; 
	2'b11: PCSource_out = EPC_out;
        endcase
end

endmodule
