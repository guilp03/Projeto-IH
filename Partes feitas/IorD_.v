module  IorD_(
    input wire [2:0]IorDControl,
    input wire [31:0]  PC_out,
    input wire [31:0] ConstDiv0,
    input wire [31:0] ConstOverflow,
    input wire [31:0] ConstNo_Opcode,
    input wire [31:0] ALUresult,
    input wire [31:0] RegA_out,
    input wire [31:0] RegB_out,
    output reg [31:0] IorD_out
);
    


	always @(*)begin
        case(IorDControl)
            3'b000 : IorD_out =  PC_out;
            3'b001 : IorD_out = ConstDiv0;
            3'b010 : IorD_out = ConstOverflow;
            3'b011 : IorD_out = ConstNo_Opcode;
	        3'b100 : IorD_out = ALUresult;
            3'b101 : IorD_out = RegA_out;
            3'b110 : IorD_out = RegB_out;
        endcase
    end

endmodule
