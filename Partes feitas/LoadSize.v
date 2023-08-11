module LoadSize(
    input wire [1:0] LScontrol,
    input wire [31:0] MDR_out,

    output reg [31:0] LS_out
);

    always @(*) begin
        case (LScontrol)
            2'b01: // lw
                LS_out <= MDR_out;
            2'b11: // lh
                LS_out <= {16'd0, MDR_out[15:0]};
            2'b10: // lb
                LS_out <= {24'd0, MDR_out[7:0]};
        endcase
    end
endmodule