module ALUSrcA_( 
    input wire [1:0] ALUSrcAControl, /* Entrada de controle */
	input wire [31:0] ALUOut_out,
    input wire [31:0] PC_out,   /* PC */
    input wire [31:0] RegA_out,   /* reg A */
    input wire [31:0] MDR_out,   /* addm */
    output reg [31:0] ALUSrcA_out   /* Saída selecionada pelo multiplexador */
);
  
always @(*) begin
    case (ALUSrcAControl) 
         /* Verifica o valor do seletor */
	    2'b00: ALUSrcA_out = ALUOut_out;
        2'b01: ALUSrcA_out = PC_out; /* Seletor = 2'b00, seleciona input1 (PC) */
        2'b10: ALUSrcA_out = RegA_out; /* Seletor = 2'b10, seleciona input3 (reg A) */
        2'b11: ALUSrcA_out = MDR_out; /* Seletor = 2'b01, seleciona input2 (addm) */
	
        endcase
end

endmodule
