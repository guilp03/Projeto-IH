module MDSrcB_( 
    input wire MDSrcBControl, /* Entrada de controle */
    input wire [31:0] RegB_out,
    input wire [31:0] Mem_out,   /* PC */
    output reg [31:0] MDSrcB_out   /* Saída selecionada pelo multiplexador */
);
  
always @(*) begin
    case (MDSrcBControl) 
         /* Verifica o valor do seletor */
	    1'b0: MDSrcB_out = RegB_out;
        1'b1: MDSrcB_out = Mem_out; /* Seletor = 2'b00, seleciona input1 (PC) */

    endcase
end

endmodule