module StoreSize(
    input wire [1:0] SScontrol,
    input wire [31:0] RegB_out,
    input wire [31:0] MDR_out,

    output reg [31:0] SS_out
);

    always @(*) begin
        case (SScontrol)
            2'b01: // sw
                SS_out <= RegB_out;
            2'b11: // sh
                SS_out <= {MDR_out[31:16], RegB_out[15:0]};
            2'b10: // sb
                SS_out <= {MDR_out[31:8], RegB_out[7:0]};
        endcase
    end
endmodule