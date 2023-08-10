module EX_( 
    input wire EX_control, /* Entrada de controle */
    input wire [31:0] PCSource_out,
    input wire [31:0] Mem_out,   /* PC */
    output reg [31:0] EX_out   /* Saída selecionada pelo multiplexador */
);
  
always @(*) begin
    case (EX_control) 
         /* Verifica o valor do seletor */
	    1'b0: EX_out = PCSource_out;
        1'b1: EX_out = Mem_out; /* Seletor = 2'b00, seleciona input1 (PC) */
	
        endcase
end

endmodule
