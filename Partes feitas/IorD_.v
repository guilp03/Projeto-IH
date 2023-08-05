module  IorD_(
    input wire [2:0]IorDControl,
    input wire [31:0]  PC_out,
    input wire [31:0] ConstDiv0,
    input wire [31:0] ConstOverflow,
    input wire [31:0] ConstNo_Opcode,
    input wire [31:0] ALUresult,
    input wire [31:0] RegA_out,
    input wire [31:0] RegB_out,
    output reg [31:0] IorD_output
);
    


	always @(PC_out or ConstDiv0 or ConstOverflow or ConstNo_Opcode or ALUresult or RegA_out or RegB_out )begin
        case(IorDControl)
            3'b000 : IorD_output =  PC_out;
            3'b001 : IorD_output = ConstDiv0;
            3'b010 : IorD_output = ConstOverflow;
            3'b011 : IorD_output = ConstNo_Opcode;
	    3'b100 : IorD_output = ALUresult;
            3'b101 : IorD_output = RegA_out;
            3'b110 : IorD_output = RegB_out;
        endcase
    end

endmodule
