module sign_extended16_32(
    input wire [15:0] OFFSET,
    output wire [31:0] sign_extended16_32_out
);

// replica o bit de sinal
assign sign_extended16_32_out = (OFFSET[15]) ? {{16{1'b1}}, OFFSET} : {{16{1'b0}}, OFFSET};

endmodule
