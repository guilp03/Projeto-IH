module shift_left_16to32(
    input wire [15:0] OFFSET,

    output wire [31:0] SL_16_32_out
);
    wire [31:0] A1;
    assign A1 = {{16{1'b0}}, OFFSET};

    assign SL_16_32_out = A1 << 16; 

endmodule