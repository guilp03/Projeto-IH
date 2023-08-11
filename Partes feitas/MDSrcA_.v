module MDSrcA_( 
    input wire MDSrcAControl, /* Entrada de controle */
    input wire [31:0] RegA_out,
    input wire [31:0] MDR_out,   /* PC */
    output reg [31:0] MDSrcA_out   /* Saída selecionada pelo multiplexador */
);
  
always @(*) begin
    case (MDSrcAControl) 
         /* Verifica o valor do seletor */
	    1'b0: MDSrcA_out = RegA_out;
        1'b1: MDSrcA_out = MDR_out; /* Seletor = 2'b00, seleciona input1 (PC) */
	
        endcase
end

endmodule